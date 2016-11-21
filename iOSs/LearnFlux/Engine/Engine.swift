//
//  Engine.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/6/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher
import EventKit

extension UIViewController{
    func e_globalResignFirstResponderRec(view: UIView){
        self.view.window?.endEditing(true);
        if view.respondsToSelector(#selector(self.resignFirstResponder)) {
            view.resignFirstResponder()
        }
        for subview: UIView in view.subviews {
            self.e_globalResignFirstResponderRec(subview)
        }
    }
}

enum RequestStatusType {
    case InternetNotWorking
    case InvalidAccessToken
    case ServerError
    case GeneralError
    case CustomError
    case NoResponseError
    case Success
}

enum RequestType{
    case MakeToken
    case UploadImage
    case None
}

typealias dictType = Dictionary<String, AnyObject>
typealias arrType = Array<dictType>
typealias JSONreturn = ((RequestStatusType, AnyObject?)->Void)

struct LFColor{
    static let green = UIColor(red: 124/255.0, green: 191/255.0, blue: 49/255.0, alpha: 1)
    static let blue = UIColor(red: 10/255.0, green: 65/255.0, blue: 71/255.0, alpha: 1.0)
}

class Engine : NSObject {
    static var clientData = Data.sharedInstance
    private static var locked : Bool = false;
    
    static func getJSON (param: [String: AnyObject])->String {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted)
            let dataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!
            return dataString as String;
        } catch let error as NSError {
            print(error)
        }
        return "";
    }
    
    static func printErrorCode (statusCode: Int) -> String {
        return (clientData.getIsProduction() ? "" : "\nStatus code: \n\(statusCode)")
    }
    
    private static func statusMaker (statusCode : Int?, JSON : AnyObject?)->RequestStatusType {
        if (statusCode == nil) {
            return .GeneralError;
        }
        else {
            switch (statusCode!) {
            case 200...299: return .Success;
            case 401: return .InvalidAccessToken;
            case 500: return .ServerError;
            default: if let json = JSON{
                if let dicJSON = json as? NSDictionary{
                    if (dicJSON.objectForKey("error") != nil || dicJSON.objectForKey("errors") != nil) {
                        return .CustomError;
                    }
                }
            }else{
                return .GeneralError
                }
            }
        }
        return .GeneralError
    }
    
    private static func makeQueryString (param: Dictionary<String,AnyObject>)->String {
        var result = "";
        for (key, value) in param {
            if (result != "") { result += "&"; }
            result += key + "=" + (value as! String);
        }
        result = result.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        if (result != "") { result = "?" + result; }
        return result;
    }
    
    static func autoLogin(refreshToken: String, callback: JSONreturn?){
        makeToken(param: ["refresh_token" : refreshToken]){ status, JSON in
            if status == .Success && JSON != nil{
                loadDataAfterLogin(){ status, JSON in
                    if callback != nil{ callback!(status, JSON) }
                }
            }else{
                if callback != nil{ callback!(status, JSON) }
            }
        }
    }
    
    static func loadDataAfterLogin(viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        me(viewController) { status, JSON in
            guard status == .Success else{
                if let vc = viewController{ Util.stopIndicator(vc.view) }
                return
            }
            guard let dataJSON = JSON as? dictType else{
                if let vc = viewController{ Util.stopIndicator(vc.view) }
                return
            }
            if !dataJSON.isEmpty{
                getGroups(){status in
                    if !self.clientData.getGroups().isEmpty{
                        for eachGroup in self.clientData.getGroups(){
                            getGroupInfo(groupId: eachGroup.id)
                        }
                    }
                }
                getThreads()
                getEvents(){ status, JSON in
                    if let events = Engine.clientData.getMyEvents(){
                        for eachEvent in events{
                            getEventDetail(event: eachEvent)
                        }
                    }
                }
                getConnection()
                clientData.setMyChildrens()
                getImageSelf()
            }else{
                if let vc = viewController{
                    Util.stopIndicator(vc.view)
                    Util.showMessageInViewController(vc, title: "Our apologies.", message: "We sincerely apologize for the inconvenience. Our server is currently in maintenance, but will return shortly. Thank you for your patience", buttonOKTitle: "OK", callback: nil)
                }
            }
            if callback != nil{ callback!(status, JSON) }
        }
    }

    static func updateTokenParam(param: Dictionary<String, AnyObject>?) -> (Dictionary<String, AnyObject>?){
        if let param = param{
            var mparam = param
            mparam["client_id"] = clientData.getClientID()
            mparam["client_secret"] = clientData.getClientSecret()
            mparam["scope"] = clientData.getScope()
            mparam["grant_type"] = mparam["password"] != nil ? "password" : "refresh_token"
            return mparam
        }else{
            return nil
        }
    }
    
    static func makeToken (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String = Url.token, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
        let newParam = updateTokenParam(param)
        let urlReq = createURLRequest(url, method: method, param: newParam)
        self.makeRequestAlamofire(viewController, method: method, url: urlReq.URLString, param: method == .GET ? nil : newParam, requestType: .MakeToken, callback: { status, JSON in
            if status == .Success{
                clientData.setRefreshToken(JSON!["refresh_token"] as! String)
                clientData.setAccessToken(JSON!["access_token"] as! String)
            }
            if callback != nil { callback!(status, JSON) }
        })
    }
    
    static func refreshToken (viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        self.makeToken(viewController, method: .GET, url: Url.token, param: ["refresh_token" : clientData.getRefreshToken()]) { status, JSON in
            if (status == .Success) {
                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (status, JSON); } } )
            }
        }
    }
    
    static func stopAllRequests(){
        Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
    
    static func makeRequestAlamofire(viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, requestType : RequestType = .None, callback: JSONreturn? = nil) {
        let urlReq = self.createURLRequest(url, method: method, param: param)
        Alamofire.request(method, urlReq.URLString, parameters: method == .GET ? nil : param, encoding: .JSON, headers: urlReq.allHTTPHeaderFields)
            .responseJSON { response in
                handleResponseOfAlamofire(viewController, method: method, urlReq: urlReq, response: response, param: param, requestType: requestType, callback: callback)
        }
    }
    
    static func makeUploadAlamofire(viewController: UIViewController? = nil, method : Alamofire.Method = .PUT, url: String, image: UIImage, param: Dictionary<String,AnyObject>? = nil, callback: JSONreturn? = nil){
        let imageData = UIImagePNGRepresentation(image)!
        let urlReq = self.createURLRequest(url, method: method, param: param, requestType: .UploadImage)
        Alamofire.upload(method, urlReq.URLString, headers: urlReq.allHTTPHeaderFields, data: imageData).responseJSON{ response in
            handleResponseOfAlamofire(viewController, method: method, urlReq: urlReq, response: response, param: param, requestType: .None, callback: callback)
        }/*.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            print(bytesRead, totalBytesRead, totalBytesExpectedToRead)
        }*/
    }
    
    static func handleResponseOfAlamofire(viewController: UIViewController?, method: Alamofire.Method, urlReq: NSURLRequest, response: Response<AnyObject, NSError>, param: Dictionary<String, AnyObject>?, requestType: RequestType, callback: JSONreturn?){
        if let json = response.result.value{
            let restat = statusMaker(response.response!.statusCode, JSON: json)
            switch (restat) {
            case .Success:
                if (callback != nil) { callback! (restat, json); }
                break;
            case .CustomError:
                print("CustomError")
                print("Status Code: \(response.response!.statusCode)")
                print("JSON: \(json)")
                if let errorDesc = json["error_description"]! {
                    if let viewController = viewController{
                        Util.showMessageInViewController(viewController, title: "Error", message: errorDesc as! String) {
                            if callback != nil{ callback! (restat, json) }
                        }
                    }else{
                        if callback != nil{ callback!(restat, json) }
                    }
                }
                else {
                    if (callback != nil) { callback! (restat, json); }
                }
                break;
            case .InvalidAccessToken:
                print("InvalidAccessToken")
                print("Status Code: \(response.response!.statusCode)")
                print("JSON: \(json)")
                if requestType == .MakeToken{
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, json); } } );
                }else{
                    if (!locked) {
                        locked = true;
                        refreshToken() { status, JSON in
                            if JSON == nil {
                                Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
                                    print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(urlReq.URLString)\nWith param: \(param)\nError code: \((response.response?.statusCode)!)");
                                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                }
                            }
                            else {
                                makeRequestAlamofire(viewController, method: method, url: urlReq.URLString, param: param) { status, JSON in
                                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                }
                            }
                        }
                    }
                    locked = false;
                }
                break;
            default:
                print("Error \(urlReq.URLString)")
                print("Status Code: \(response.response!.statusCode)")
                print("JSON: \(json)")
                if let viewController = viewController{
                    Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later." + printErrorCode((response.response?.statusCode)!)) {
                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, json); } } );
                    };
                }else{
                    if callback != nil { callback!(restat, json) }
                }
                break;
            }
        }else{
            if callback != nil{ callback!(.ServerError, nil) }
        }
    }
    
    static func requestImage(urlString: String, shouldCacheData: Bool = false, callback: ((UIImage?) -> Void)?){
        let downloader = KingfisherManager.sharedManager.downloader
        downloader.requestModifier = { mutableUrl in
            mutableUrl.setValue("Bearer \(clientData.getAccessToken())", forHTTPHeaderField: "Authorization")
        }
        
        ImageDownloader.defaultDownloader.downloadImageWithURL(NSURL(string: urlString)!, options: [], progressBlock: nil) { (image, error, imageURL, originalData) in
            if let image = image{
                if callback != nil { callback!(image) }
                if shouldCacheData{
                    ImageCache.defaultCache.storeImage(image, forKey: urlString)
                }
            }
        }
    }
    
    static func fetchCacheImage(key: String, callback: ((UIImage?) -> Void)?){
        ImageCache.defaultCache.retrieveImageForKey(key, options: []) { image, cacheType in
            if callback != nil{ callback!(image) }
        }
    }
    
    private static func createURLRequest(string: String, method: Alamofire.Method, param: Dictionary<String,AnyObject>?, requestType: RequestType = .None) -> (NSMutableURLRequest){
        let headers = authHeaders(string, requestType: requestType)
        var newUrl = string
        let urlReq = NSMutableURLRequest()
        if let tParam = param{
            if method == .GET {
                newUrl += makeQueryString(tParam)
            }else if method == .POST || (method == .DELETE && string == Url.messages){
                do{
                    let post = try NSJSONSerialization.dataWithJSONObject(tParam, options: .PrettyPrinted)
                    urlReq.HTTPBody = post
                }catch let error as NSError{
                    print("Make JSON error : \(error)")
                }
                
            }
        }
        urlReq.URL = NSURL(string: newUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)!
        urlReq.cachePolicy = .UseProtocolCachePolicy
        urlReq.timeoutInterval = 10.0
        urlReq.HTTPMethod = "\(method)"
        urlReq.allHTTPHeaderFields = headers
        return urlReq
    }
    
    private static func authHeaders(urlString: String, requestType: RequestType = .None) -> (Dictionary<String, String>){
        let headers : Dictionary<String, String> = [
            "Content-Type"  : requestType != .UploadImage ? "application/json" : "image/*",
            "cache-control" : "no-cache",
            "Authorization" : urlString == Url.register ? "" : "Bearer \(clientData.getAccessToken())"
        ]
        return headers
    }
    
    static func login(viewController: UIViewController? = nil, username : String, password : String, callback: JSONreturn? = nil) {
        makeToken(viewController, param: ["username" : username, "password": password]) { status, JSON in
            if (JSON == nil) {
                if (status == .GeneralError) {
                    Util.showMessageInViewController(viewController, title: "Cannot login", message: "Please check your username or password.") {
                        if (callback != nil) { callback! (status, JSON); }
                    };
                }
                else if (callback != nil) { callback! (status, JSON); }
            }
            else if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func me(viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        makeRequestAlamofire(viewController, url: Url.me, param: nil) { status, JSON in
            guard status == .Success else{
                if (callback != nil) { callback! (status, JSON); }
                return
            }
            if var dataJSON = JSON as? Dictionary<String, AnyObject>{
                var dataLinks = dataJSON[keyCacheMe.links] as! Dictionary<String, AnyObject>
                for each in dataLinks{
                    var data = dataLinks[each.0] as! Dictionary<String, AnyObject>
                    if var dataHref = data["href"] as? String{
                        dataHref = dataHref.stringByReplacingOccurrencesOfString("/api", withString: "")
                        dataHref = dataHref.stringByReplacingOccurrencesOfString("?id=", withString: "?key=")
                        data["href"] = dataHref
                        dataLinks[each.0] = data
                    }
                }
                dataJSON[keyCacheMe.links] = dataLinks
                clientData.saveMe(dataJSON)
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func getSpecificEventsByIdGroup(viewController: UIViewController? = nil, idGroup: String, callback: JSONreturn? = nil){
        if clientData.getSpecificEventsByIdGroup(idGroup) != nil{
            if callback != nil { callback!(.Success, nil) }
        }else{
            makeRequestAlamofire(url: Url.groupEvent(idGroup: idGroup), param: nil){status, JSON in
                if status == .Success{
                    if let arr = self.getArrData(JSON){
                        if arr.isEmpty{
                            clientData.addEmptySpecificEvents(idGroup)
                        }else{
                            clientData.addSpecificEvents(idGroup, arrDictEvents: arr)
                        }
                    }
                }
                if callback != nil { callback!(status, JSON) }
                getDetailSpecificEventsByIdGroup(idGroup)
            }
        }
        
    }
    
    static func getDetailSpecificEventsByIdGroup(idGroup: String){
        if let events = clientData.getSpecificEventsByIdGroup(idGroup) where !events.isEmpty{
            for event in events{
                makeRequestAlamofire(url: Url.events + "/\(event.id)", param: nil){status, JSON in
                    if status == .Success && JSON != nil{
                        if let dict = self.getDictData(JSON){
                            clientData.updateSpecificEventsByIdGroup(idGroup, events: [Event(dict: dict)])
                        }
                    }
                }
            }
        }
    }
    
    static func reloadDataAPI(){
        getConnection(isNew: false)
        getGroups(isNew: false){ status in
            if !clientData.getGroups().isEmpty{
                for eachGroup in clientData.getGroups(){
                    Engine.getGroupInfo(groupId: eachGroup.id)
                }
            }
        }
        getThreads()
        getEvents(){ status, JSON in
            if let events = Engine.clientData.getMyEvents(){
                for eachEvent in events{
                    Engine.getEventDetail(event: eachEvent)
                }
            }
        }
    }
    
    static func getEvents(viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.events, param: nil){ status, dataJSON in
            guard let rawJSON = dataJSON as? Dictionary<String, AnyObject> else{
                if callback != nil{ callback!(status, dataJSON) }
                return
            }
            if let arrData = rawJSON["data"] as? Array<Dictionary<String, AnyObject>>{
                clientData.setMyEvents(arrData)
            }
            if callback != nil{ callback!(status, dataJSON) }
        }
    }
    
    static func getConnection(viewController: UIViewController? = nil, isNew: Bool = true, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: clientData.cacheLinkFriends() != nil ? Url.getBaseUrl() + clientData.cacheLinkFriends()! : Url.connections, param: nil){ status, dataJSON in
            guard let rawJSON = dataJSON where status == .Success else{
                if callback != nil { callback!(status, dataJSON) }
                return
            }
            guard let json = JSON(rawJSON).dictionaryObject else{
                if callback != nil { callback!(status, dataJSON) }
                return
            }
            let arrFriends = json[keyCacheFriends.friends] as! Array<Dictionary<String, AnyObject>>
            let arrPendingFriends = json[keyCacheFriends.pending] as! Array<Dictionary<String, AnyObject>>
            let arrRequestedFriends = (json[keyCacheFriends.request] as! Array<Dictionary<String, AnyObject>>)
            if isNew{
                clientData.setMyConnections(arrFriends, arrPendingFriends, arrRequestedFriends)
            }else{
                clientData.checkUpdateMyConnections(arrFriends, arrPendingFriends, arrRequestedFriends)
            }
            if callback != nil{ callback!(status, dataJSON) }
        }
    }
    
    static func getEventDetail(viewController: UIViewController? = nil, event: Event, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.events + "/\(event.id)", param: nil){ status, JSON in
            if status == .Success{
                if let dictJSON = JSON!["data"] as? Dictionary<String, AnyObject>{
                    event.update(dictJSON)
                }
            }
            if callback != nil { callback!(status, JSON) }
        }
    }

    static func getArrData (dataJSON : AnyObject?) -> arrType? {
        guard let rawJSON = dataJSON else { return nil; }
        guard let json = JSON(rawJSON).dictionaryObject else { return nil; }
        guard let data = json["data"] else { return nil; }
        return data as? arrType;
    }

    static func getDictData (dataJSON : AnyObject?) -> dictType? {
        guard let rawJSON = dataJSON else { return nil; }
        guard let json = JSON(rawJSON).dictionaryObject else { return nil; }
        guard let data = json["data"] else { return nil; }
        return data as? dictType;
    }

    static func getGroups(viewController: UIViewController? = nil, isNew: Bool = true, callback: ((RequestStatusType)->Void)? = nil){
        makeRequestAlamofire(viewController, url: Url.groups, param: nil){ status, dataJSON in
            if let arrGroups = self.getArrData(dataJSON){
                if isNew{
                    self.clientData.setGroups(arrGroups)
                }else{
                    self.clientData.checkUpdateGroups(arrGroups)
                }
            }
            if callback != nil { callback!(status) }
        }
    }
    
    static func getImageGroup(viewController: UIViewController? = nil, group: Group, fromCache: Bool = false, callback: ((UIImage?) -> Void)? = nil){
        let urlString = Url.getImage(.Group, id: group.id)
        if fromCache  && ImageCache.defaultCache.isImageCachedForKey(urlString).cached{
            fetchCacheImage(urlString, callback: callback)
        }else{
            requestImage(urlString, shouldCacheData: false, callback: callback)
        }
    }
    
    static func getImageSelf(viewController: UIViewController? = nil, fromCache: Bool = false){
        if let linkImage = clientData.cacheLinkPhoto(){
            getImageIndividual(viewController, urlIndividual: linkImage, fromCache: false){ image in
                if let image = image{
                    clientData.photo = image
                }
            }
        }
    }
    
    static func getImageIndividual(viewController: UIViewController? = nil, urlIndividual: String?, fromCache: Bool = false, callback: ((UIImage?) -> Void)? = nil){
        guard let link = urlIndividual else{
            if callback != nil { callback!(nil) }
            return
        }
        let urlString = Url.getBaseUrl() + link
        if fromCache  && ImageCache.defaultCache.isImageCachedForKey(urlString).cached{
            fetchCacheImage(urlString, callback: callback)
        }else{
            requestImage(urlString, shouldCacheData: true){ image in
                if callback != nil{ callback!(image) }
            }
        }
    }
    
    static func getNotifications(viewController: UIViewController? = nil, callback: ((Array<Dictionary<String, AnyObject>>) -> Void)? = nil){
        makeRequestAlamofire(viewController, url: Url.notifications, param: nil){status, JSON in
            if status == .Success && !(JSON!["data"] as! Array<Dictionary<String, AnyObject>>).isEmpty{
                let arrNotifications = JSON!["data"] as! Array<Dictionary<String, AnyObject>>
                clientData.updateNotifications(arrNotifications)
            }
            if callback != nil { callback!(clientData.cacheNotifications().reverse()) }
        }
    }
    
    static func getChildsOfAllOrganizations(viewController: UIViewController? = nil, callback: ((Array<Group>?) -> Void)? = nil){
        let organizationHaveChild = clientData.getGroups(.Organisation).filter({ $0.child != nil && !$0.child!.isEmpty })
        let unorderedChilds = organizationHaveChild.map({ $0.child! })
        let childs = unorderedChilds.reduce([Group](), combine: { $0 + $1 })
        if callback != nil { callback!(childs) }
    }
    
    static func getPhotoOfConnection(indexPath: NSIndexPath, callback: (Bool -> Void)?){
        if clientData.getMyConnection().friends[indexPath.row].photo == nil{
            Engine.getImageIndividual(urlIndividual: clientData.getMyConnection().friends[indexPath.row].picture){image in
                if image != nil{
                    self.clientData.getMyConnection().friends[indexPath.row].photo = image
                    if callback != nil { callback!(true) }
                }
            }
        }
    }
    
    static func getSelfRoles() -> String{
        let flatted = clientData.getGroups(.Organisation).reduce([String](), combine: { a, b in
            guard let role = b.role else{ return a }
            if role.lowercaseString != "user"{
                return a + ["\(role) of \(b.name)"]
            }else{
                return a
            }
        })
        return flatted.isEmpty ? "" : flatted.joinWithSeparator(", ")
    }
    
    static func getAvailableInterests(viewController: UIViewController? = nil, callback: (([String]?)->Void)? = nil) {
        makeRequestAlamofire(viewController, url: Url.availableInterests, param: nil){ status, dataJSON in
            if status == .Success{
                guard let arrInterests = dataJSON as? Array<String> else{
                    if callback != nil { callback!(nil) }
                    return
                }
                if callback != nil { callback!(arrInterests) }
            }
        }
    }
    
    static func getAllContacts(callback: (Array<Dictionary<String, String>> -> Void)){
        var allContacts = Array<Dictionary<String, String>>()
        Engine.getChildsOfAllOrganizations(){ groups in
            allContacts += clientData.getMyConnection().friends.map({ ["type" : "individual", "id" : "\($0.userId!)", "name" : $0.firstName!] })
            if let groups = groups{
                allContacts += groups.map({ ["type" : "group", "id" : "\($0.id)", "name" : $0.name] })
            }
            allContacts += clientData.getGroups(.Organisation).map({ ["type" : "organization", "id" : "\($0.id)", "name" : $0.name] })
            allContacts.sortInPlace({ $0["name"] < $1["name"] })
            callback(allContacts)
        }
    }
    
    static func generateContactsByFirstLetter(arrContacts: Array<Dictionary<String, String>>) -> Dictionary<String, Array<Dictionary<String, String>>>{
        var allContacts = Dictionary<String, Array<Dictionary<String, String>>>()
        for each in arrContacts{
            let key = each["name"]!.substringToIndex(each["name"]!.startIndex.advancedBy(1)).uppercaseString
            if var contactValues = allContacts[key]{
                contactValues.append(each)
                allContacts[key] = contactValues
            }else{
                allContacts[key] = [each]
            }
        }
        return allContacts
    }
    
//    static func getFriendRequests(viewController: UIViewController? = nil, callback: ((Array<User>?)->Void)? = nil){
//        me(viewController){status, JSON in
//            if status == .Success && !clientData.cacheSelfFriendRequest().isEmpty{
//                var newArrFriendRequests = reduceArrJSON(clientData.cacheSelfFriendRequest(), indicator: "id")
//                removeFriendRequestByConnection(&newArrFriendRequests)
//                let friendRequests = newArrFriendRequests.map({User(dict: $0)})
//                if callback != nil { callback!(friendRequests) }
//            }else{
//                if callback != nil { callback!([]) }
//            }
//        }
//    }
    
//    static func getFriendRequesteds() -> Array<User>?{
//        if !clientData.cacheSelfFriendRequested().isEmpty{
//            var newArrFriendRequesteds = reduceArrJSON(clientData.cacheSelfFriendRequested(), indicator: "id")
//            removeFriendRequestByConnection(&newArrFriendRequesteds)
//            let friendRequests = newArrFriendRequesteds.map({User(dict: $0)})
//            return friendRequests
//        }
//        return nil
//    }
    
    static func addFriend(viewController: UIViewController? = nil, user: User, callback: (RequestStatusType -> Void)? = nil){
        makeRequestAlamofire(viewController, method: .PATCH, url: Url.addConnection(user.userId!), param: nil){ status, JSON in
            if status == .Success{
                clientData.addToConnection(user)
                if let index = clientData.getMyConnection().pending.indexOf({ $0.userId! == user.userId! }){
                    self.clientData.removePendingFriends(index)
                }
            }
            if callback != nil { callback!(status) }
        }
    }
    
    static func requestFriend(viewController: UIViewController? = nil, user: User, callback: (RequestStatusType -> Void)? = nil){
        makeRequestAlamofire(viewController, method: .PATCH, url: Url.addConnection(user.userId!), param: nil){status, JSON in
            if status == .Success{
                makeRequestAlamofire(viewController, url: Url.getUserDetail(user.userId!), param: nil){status, JSON in
                    if status == .Success{
                        clientData.addToRequestedConnection(user)
                    }
                    if callback != nil{ callback!(status) }
                }
            }
        }
    }
    
    //perlu diganti
//    static func getSuggestFriends() -> Array<Dictionary<String, AnyObject>>{
//        var listIdFriendRequested = Set(clientData.cacheSelfFriendRequested().map({ $0[keyCacheMe.id] as! Int }))
//        let listIdFriendRequest = Set(clientData.cacheSelfFriendRequest().map({ $0[keyCacheMe.id] as! Int }))
//        let listIdFriends = clientData.getMyConnection()!.map({ $0.userId! })
//        listIdFriendRequested.unionInPlace(listIdFriendRequest)
//        listIdFriendRequested.subtractInPlace(listIdFriends)
//        
//        var arrSuggestFriends = Array<Dictionary<String, AnyObject>>()
//        for each in clientData.cacheSelfFriends(){
//            let newFriends = clientData.arrayFromDict(each[keyCacheMe.friends]!)
//            for eachNew in newFriends{
//                if !clientData.getMyConnection()!.contains({ $0.userId! == eachNew[keyCacheMe.id] as! Int }){
//                    if !listIdFriendRequested.contains({ $0 == eachNew["id"] as! Int }){
//                        let key = eachNew[keyCacheMe.id] as! Int
//                        if let index = arrSuggestFriends.indexOf({ $0[keyCacheMe.id] != nil && $0[keyCacheMe.id] as! Int == key }){
//                            var lastParam = arrSuggestFriends[index]
//                            var conParam = lastParam["friends"] as! Array<Int>
//                            conParam.append(each[keyCacheMe.id] as! Int)
//                            lastParam["friends"] = conParam
//                            arrSuggestFriends[index] = lastParam
//                        }else{
//                            let param : Dictionary<String, AnyObject> = ["id" : key, "name"  : "\(eachNew[keyCacheMe.firstName]!) \(eachNew[keyCacheMe.lastName]!)",
//                                                                         "friends" : [each[keyCacheMe.id]!]]
//                            arrSuggestFriends.append(param)
//                        }
//                    }
//                }
//            }
//        }
//        arrSuggestFriends.sortInPlace({ ($0["friends"]! as! Array<Int>).count > ($1["friends"]! as! Array<Int>).count })
//        return arrSuggestFriends
//    }
    
    static func requestSearch(viewController: UIViewController? = nil, keySearch: String, callback: (([User], [Group], [Group]) -> Void)? = nil){
        Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler(){arrTask in
            for each in arrTask{
                each.cancel()
            }
        }
        makeRequestAlamofire(viewController, url: Url.search(keySearch), param: nil){status, JSON in
            guard let dataJSON = JSON as? Dictionary<String, AnyObject> where status == .Success else{
                if callback != nil { callback!([], [], []) }
                return
            }
            let arrRawGroups = dataJSON["groups"] as! Array<Dictionary<String, AnyObject>>
            let arrOrganizations = arrRawGroups.filter({ $0["type"] as! String == "organization" })
            let arrGroups = arrRawGroups.filter({ $0["type"] as! String != "organization" })
            let arrUsers = clientData.arrayFromDict(dataJSON["users"]!)
            if callback != nil { callback!(arrUsers.map({ User(dict: $0)}), arrOrganizations.map({ Group(dict: $0) }), arrGroups.map({ Group(dict: $0) })) }
        }
    }
    
    static func requestJoinGroup(viewController: UIViewController? = nil, idGroup: String, callback: ((RequestStatusType) -> Void)? = nil){
        makeRequestAlamofire(viewController, url: Url.connectGroup(idGroup, type: ConnectGroupType.join), param: nil){ status, JSON in
            print(status, JSON)
            if status == .Success{
                
            }
            if callback != nil { callback!(status) }
        }
    }
    
    static func requestUserDetail(viewController: UIViewController? = nil, idUser: Int, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.userDetail(idUser), param: nil, callback: callback)
    }
    
    static func editMe(viewController: UIViewController? = nil, name: String?, from: String?, work: String?, callback: (RequestStatusType -> Void)? = nil){
        var param = Dictionary<String, String>()
        if let name = name where name != clientData.cacheFullname(){
            var arrName = name.componentsSeparatedByString(" ")
            if !arrName.isEmpty{
                param[keyCacheMe.editFirstname] = arrName.first!
                arrName.removeFirst()
                param[keyCacheMe.editLastname] = arrName.joinWithSeparator(" ")
            }
        }
        if let from = from where !from.isEmpty && from != DEFAULT_EDIT_PROFILE_TEXT.FROM{
            param[keyCacheMe.from] = from
        }
        if let work = work where !work.isEmpty && work != DEFAULT_EDIT_PROFILE_TEXT.WORK{
            param[keyCacheMe.work] = work
        }
        if !param.isEmpty{
            makeRequestAlamofire(viewController, method: .PUT, url: Url.editMe, param: param){ status, JSON in
                if status == .Success{
                    clientData.updateMe(param)
                }
                if callback != nil{ callback!(status) }
            }
        }
    }
    
    static func editPhoto(viewController: UIViewController? = nil, photo: UIImage, callback: (RequestStatusType -> Void)? = nil){
        makeUploadAlamofire(viewController, method: .PUT, url: Url.uploadImageMe, image: photo, param: nil){ status, JSON in
            if status == .Success{
                clientData.photo = photo
            }
            if callback != nil{ callback!(status) }
        }
    }
    
    static func editInterests(viewController: UIViewController? = nil, interests: Array<String>, callback: (RequestStatusType -> Void)? = nil){
        makeRequestAlamofire(viewController, method: .PUT, url: Url.editMe, param: ["interest": interests]){ status, JSON in
            if status == .Success{
                clientData.updateMe(["interests" : interests])
            }
            if callback != nil{ callback!(status) }
        }
    }
    
    static func editGroupPhoto(viewController: UIViewController? = nil, idGroup: String, photo: UIImage, callback: (RequestStatusType -> Void)? = nil){
        makeUploadAlamofire(viewController, method: .PUT, url:Url.uploadImageGroup(idGroup: idGroup), image: photo, param: nil){ status, JSON in
            if callback != nil{ callback!(status) }
        }
    }
    
//    static func removeFriendRequestByConnection(inout arrFriendRequests: arrType){
//        for connection in clientData.getMyConnection()!{
//            if let index = arrFriendRequests.indexOf({ $0["id"] as! Int == connection.userId! }){
//                arrFriendRequests.removeAtIndex(index)
//            }
//        }
//    }
    
    static func reduceArrJSON(arr: Array<Dictionary<String, AnyObject>>, indicator: String) -> Array<Dictionary<String, AnyObject>>{
        var newArr = Array<Dictionary<String, AnyObject>>()
        for each in arr{
            if !newArr.isEmpty{
                let filtered = newArr.indexOf({ $0[indicator] as! Int == each[indicator] as! Int })
                if filtered != nil{
                    newArr[filtered!] = each
                }else{
                    newArr.append(each)
                }
            }else{
                newArr.append(each)
            }
        }
        return newArr
    }
    
    //Create Interest Group in API
    static func createGroupChat (viewController: UIViewController? = nil, name: String = "", description: String = "", userId: [Int], callback: JSONreturn? = nil) {
        createGroupe(viewController, isOrganization: false, name: name, description: description, userId: userId, callback: callback)
    }
    
    static func createOrganization (viewController: UIViewController? = nil, name: String = "", description: String = "", userId: [Int], callback: JSONreturn? = nil) {
        createGroupe(viewController, isOrganization: true, name: name, description: description, userId: userId, callback: callback)
    }
    
    static func createGroupe(viewController: UIViewController? = nil, isOrganization : Bool, name: String = "", description: String = "", userId: [Int], callback: JSONreturn? = nil){
        let param : Dictionary<String, AnyObject> =
            ["type"        : isOrganization ? "organization" : "group",
             "participants": userId,
             "name"       : name.capitalizedString,
             "description" : "\(description.capitalizedString) description"]
        makeRequestAlamofire(viewController, method: .POST, url: Url.groups, param: param) { status, JSON in
            if let rawJSON = JSON{
                if let rawData = (rawJSON as! Dictionary<String, AnyObject>)["data"]{
                    if let rawThread = (rawData as! Dictionary<String, AnyObject>)["message"]{
                        let dictThread = rawThread as! Dictionary<String, AnyObject>
                        clientData.addNewThread(dictThread)
                        clientData.addNewGroup(rawData as! Dictionary<String, AnyObject>)
                    }
                }
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func createPrivateThread(viewController: UIViewController? = nil, userId: [Int], callback: ((RequestStatusType, (index: Int, thread: Thread)?) -> Void)? = nil){
        makeRequestAlamofire(viewController, method: .POST, url: Url.messages, param: ["participants" : userId]){ status, JSON in
            if let threadDict = getDictData(JSON) where status == .Success && JSON != nil{
                let thread : (index: Int, thread: Thread)? = clientData.getThread(threadDict)
                if callback != nil { callback!(status, thread) }
            }
        }
    }
    
    static func removeThread(viewController: UIViewController? = nil, threadId: String, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, method: .DELETE, url: Url.messages, param: ["ids" : [threadId]]){ status, JSON in
            if status == .Success{
                clientData.deleteThread(threadId)
            }
        }
    }

    static func getGroupInfo(viewController: UIViewController? = nil, groupId: String, callback: ((RequestStatusType, Group?) -> Void)? = nil) {
        let url = Url.groups + "/" + groupId
        makeRequestAlamofire(viewController, url: url, param: nil){ status, dataJSON in
            guard let data = self.getDictData(dataJSON) where status == .Success else{
                if callback != nil { callback!(status, nil) }
                return
            }
            
            let index = clientData.getGroups().indexOf({ a in
                if a.id == data[keyGroupName.id] as! String{
                    return true
                }
                if a.child != nil && a.child!.contains({ $0.id == data[keyGroupName.id] as! String }){
                    return true
                }
                return false
            })
            if index != nil{
                if clientData.getGroups()[index!].id == data[keyGroupName.id] as! String{
                    clientData.getGroups()[index!].update(data)
                    if callback != nil { callback!(status, clientData.getGroups()[index!]) }
                }else if let indexChild = clientData.getGroups()[index!].child!.indexOf({ $0.id == data[keyGroupName.id] as! String }){
                    clientData.getGroups()[index!].child![indexChild].update(data)
                    if callback != nil { callback!(status, clientData.getGroups()[index!].child![indexChild]) }
                }
            }else{
                //butuh perubahan. karena setiap buat group akan men load image jika group memiliki link image
                print("sendGroupbaru. Func in Engine")
                if callback != nil { callback!(status, Group(dict: data)) }
            }
        }
    }
    
    static func getThreads (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        var lastSync : Double = 0
        if let cacheLastSync = clientData.cacheLastSyncThreads(){
            lastSync = cacheLastSync
        }
        let param = ["lastSync" : String(lastSync)]
        makeRequestAlamofire(viewController, method: .GET, url: Url.messages, param: param) { status, rawJSON in
            if let rawJSON = rawJSON where status == .Success{
                if let data = rawJSON["data"] as? Array<Dictionary<String, AnyObject>>{
                    let data = data
                    let newSync = rawJSON["lastSync"] as! Double
                    if data.isEmpty{
                        clientData.saveAllThreads([], lastSync: String(newSync))
                        clientData.setThreads([])
                    }else{
                        let newThreads = self.updateThreadsByLastSync(data, fromLastSync: newSync)
                        clientData.saveAllThreads(newThreads, lastSync: String(newSync))
                        clientData.setThreads(newThreads)
                    }
                }
            }
            if (callback != nil) { callback! (status, rawJSON); }
        }
    }
    
    static func updateThreadsByLastSync(newData: Array<Dictionary<String, AnyObject>>, fromLastSync: Double)->(Array<Dictionary<String, AnyObject>>){
        if let lastThreads = clientData.cacheThreads(){
            var threads = lastThreads
            self.updateContentThreads(&threads, newThreads: newData)
            return threads
        }else{
            return newData
        }
    }
    
    static func updateContentThreads(inout threads: Array<Dictionary<String, AnyObject>>, newThreads: Array<Dictionary<String, AnyObject>>){
        for i in 0..<newThreads.count{
            if threads.count < i+1 && newThreads.count - threads.count != 0{
                threads.append(newThreads[i])
                continue
            }
            for eachDict in newThreads[i]{
                if eachDict.0 == "messages", let message = threads[i]["messages"]{
                    var threadMessages = message as! Array<Dictionary<String, AnyObject>>
                    let newMessages = eachDict.1 as! Array<Dictionary<String, AnyObject>>
                    threadMessages += newMessages
                    threads[i].updateValue(threadMessages, forKey: "messages")
                }else if eachDict.0 == "messages"{
                    threads[i].updateValue(eachDict.1, forKey: eachDict.0)
                }else{
//                    threads[i].updateValue(eachDict.1, forKey: eachDict.0)
                }
            }
        }
    }
    
    static func replaceNewValueDict <K, V>(inout left: Dictionary<K,V>, right: Dictionary<K,V>) {
        for i in right {
            left.updateValue(i.1, forKey: i.0)
        }
    }
    
    static func getThreadChat(chatId: String) -> Dictionary<String, AnyObject>?{
        if let cacheThreads = self.clientData.cacheThreads(){
            var threadChat : Dictionary<String, AnyObject>?
            for thread in cacheThreads{
                if thread["id"] as! String == chatId{
                    threadChat = thread
                    break
                }
            }
            return threadChat
        }
        return nil
    }
    
    static func getMessagesFromThread(thread: Dictionary<String, AnyObject>)-> Array<Dictionary<String, AnyObject>>?{
        if let messages = thread["messages"]{
            return messages as? Array<Dictionary<String, AnyObject>>
        }
        return nil
    }
    
    static func generateThreadName(thread: Thread) -> String {
        if (thread.title != nil) {
            return thread.title!
        }
        let participants = thread.participants
        var chatName = "";
        for participant in participants {
            let me = clientData.cacheMe()
            let selfId = me!["id"] as! Int;
            if (participant.user?.userId != selfId) {
                if (chatName != "") { chatName += ", "; }
                chatName += String(participant);
                //                chatName += participant["username"] as! String;
            }
        }
        return chatName;
    }
    
    static func addMessage(threadId: String, message: String, callback: JSONreturn? = nil){
        makeRequestAlamofire(method: .POST, url: Url.messages + "/\(threadId)", param: ["body" : message]){ status, JSON in
            if callback != nil { callback!(status, JSON) }
        }
    }
    
    static func getNewMessages(viewController: UIViewController? = nil, indexpath: Int, lastSync: Double, callback: ((status: RequestStatusType, newMessage: [Thread.ThreadMessage]?, lastSync: Double)->Void)? = nil) {
        let param = ["lastSync" : String(lastSync)]
        makeRequestAlamofire(viewController, method: .GET, url: Url.messages, param: param) { status, rawJSON in
            if status == .Success, let rawJSON = rawJSON as? Dictionary<String, AnyObject>{
                guard let threadsData = rawJSON["data"] as? Array<Dictionary<String, AnyObject>> else{
                    if callback != nil{ callback!(status: status, newMessage: nil, lastSync: 0) }
                    return
                }
                print(indexpath)
                if let rawMessages = threadsData[indexpath]["messages"]{
                    let messages = rawMessages as! Array<Dictionary<String, AnyObject>>
                    if let result = Thread.getMessagesFromArr(messages){
                        if (callback != nil) { callback! (status: status, newMessage: result, lastSync: rawJSON["lastSync"] as! Double) }
                        return
                    }
                }else{
                    if callback != nil{ callback!(status: status, newMessage: nil, lastSync: rawJSON["lastSync"] as! Double) }
                }
            }else{
                if callback != nil{ callback!(status: status, newMessage: nil, lastSync: 0) }
            }
        }
    }
    
    static func startConversation(viewController : UIViewController, groupThread: Thread) -> (index: Int, thread: Thread)?{
        guard let threads = clientData.getMyThreads() else{
            Util.showMessageInViewController(viewController, title: "Ops", message: "Sorry, this chat is unavailable")
            return nil
        }
        if let index = threads.indexOf({ $0.id == groupThread.id }){
            return (index: index, thread: threads[index])
        }else{
            Util.showMessageInViewController(viewController, title: "", message: "Chat of this group has been deleted accidently, so the best way is just delete this group because this could make problems in future")
            return nil
        }
    }
    
    static func updateStatusEvent(status: Int, inout rowEvent: Int?, specificGroup: String? = nil, callback: JSONreturn? = nil){
        if let idGroup = specificGroup{
            if let events = clientData.getSpecificEventsByIdGroup(idGroup) where !events.isEmpty{
                if events[rowEvent!].status != status{
                    makeRequestAlamofire(method: .PUT, url: Url.events + "/\(events[rowEvent!].id)", param: ["rsvp" : status], callback: { (stateReq, _) in
                        if stateReq == .Success{
                            clientData.getSpecificEventsByIdGroup(idGroup)![rowEvent!].status = status
                            if let index = clientData.getMyEvents()!.indexOf({ $0.id == events[rowEvent!].id }){
                                clientData.getMyEvents()![index].status = status
                            }
                        }
                        rowEvent = nil
                        if callback != nil { callback!(stateReq, nil) }
                    })
                }
            }
        }else{
            if clientData.getMyEvents()![rowEvent!].status != status{
                makeRequestAlamofire(method: .PUT, url: Url.events + "/\(clientData.getMyEvents()![rowEvent!].id)", param: ["rsvp" : status], callback: { (stateReq, _) in
                    if stateReq == .Success{
                        clientData.getMyEvents()![rowEvent!].status = status
                        clientData.updateStatusSpecificEventIfAvailable(clientData.getMyEvents()![rowEvent!].id, status: status)
                    }
                    rowEvent = nil
                    if callback != nil { callback!(stateReq, nil) }
                })
            }
        }
    }
    
    static func createEvent(dict: Dictionary<String, AnyObject>, idGroup: String = "", callback: JSONreturn? = nil){
        let param = !idGroup.isEmpty ? paramForCreateEvent(dict, idGroup: idGroup) : dict
        makeRequestAlamofire(method: .POST, url: Url.events, param: param){ status, JSON in
            if status == .Success && JSON != nil{
                var dict = getDictData(JSON)
                dict!["rsvp"] = 2
                let event = Event(dict: dict!)
                event.by = User.convertFromDict(clientData.cacheMe())!
                let idGroup = (param!["reference"] as! Dictionary<String, AnyObject>)["id"] as! String
                clientData.updateSpecificEventsByIdGroup(idGroup, events: [event])
            }
            if callback != nil { callback!(status, JSON) }
        }
    }
    
    static func sendPollOption(optionName: String, pollId: String, callback: JSONreturn? = nil){
        makeRequestAlamofire(method: .POST, url: Url.poll + "/\(pollId)", param: ["option" : optionName], callback: { (status, JSON) in
            if callback != nil { callback!(status, JSON) }
        })
    }
    
    static func createPoll(dict: Dictionary<String, AnyObject>, callback: JSONreturn? = nil){
        let param = paramForCreatePoll(dict)
        makeRequestAlamofire(method: .POST, url: Url.poll, param: param) { status, JSON in
            if callback != nil { callback!(status, JSON) }
        }
    }
    
    static func sendPollToMessage(dict: Dictionary<String, AnyObject>, idThread: String, callback: JSONreturn? = nil){
        makeRequestAlamofire(method: .POST, url: Url.messages + "/\(idThread)", param: paramForSendPollToMessage(dict)){ status, JSON in
            if status == .Success{
                if callback != nil { callback!(status, JSON) }
            }
        }
    }
    
    static func paramForSendPollToMessage(paramResponse: Dictionary<String, AnyObject>)->(Dictionary<String, AnyObject>){
        var param : Dictionary<String, AnyObject> = [:]
        param["body"] = ""
        param["reference"] = ["id"  : paramResponse["id"]!,
                              "type": paramResponse["type"]!]
        return param
    }
    
    static func paramForCreateEvent(dict: Dictionary<String, AnyObject>, idGroup: String, isOrganization: Bool = false) -> (Dictionary<String, AnyObject>)?{
        guard let title = dict["title"],
              let location = dict["location"],
              let date = dict["date"],
              let time = dict["time"] else{
                return nil
        }
        guard let sTitle = title as? String,
              let sLocation = location as? String,
              let sDate = date as? String,
              let sTime = time as? String else{
                return nil
        }
        var newParam : Dictionary<String, AnyObject> = ["title"     : "\(sTitle)",
                                                        "details"   : sTitle + "'s detail",
                                                        "location"  : sLocation,
                                                        "timestamp" : "\(dateToTimestamp(sDate, time: sTime))"]
        if !isOrganization{
            newParam["reference"] = ["id"   : idGroup,
                                     "type" : "group"]
        }
        return newParam
    }
    
    static func dateToTimestamp(date: String, time: String) -> (Double){
        let sDate = date + " " + time
        let formatter : NSDateFormatter = {
            let tmpFormatter = NSDateFormatter()
            tmpFormatter.dateFormat = "EEEE, d MMMM y HH:mm"
            return tmpFormatter
        }()
        return (formatter.dateFromString(sDate))!.timeIntervalSince1970
    }
    
    static func paramForCreatePoll(dict: Dictionary<String, AnyObject>) -> (Dictionary<String, AnyObject>)?{
        guard let rawAnswers = dict["answers"],
              let rawQuestion = dict["question"] else{
            return nil
        }
        guard let answers = rawAnswers as? Array<String>,
              let question = rawQuestion as? String else{
            return nil
        }
        func createOptions(arr: Array<String>) -> (Array<Dictionary<String, String>>){
            var con : Array<Dictionary<String, String>> = []
            if !arr.isEmpty{
                for each in 0..<arr.count{
                    con.append(["value" : "opt\(each)",
                                "name"  : arr[each]])
                }
            }
            return con
        }
        let newParam : Dictionary<String, AnyObject> = ["title"    : question,
                        "question" : question,
                        "options"  : createOptions(answers)]
        return newParam
    }
  
    static func deleteThreads (viewController: UIViewController? = nil, threadIds: [String], callback: JSONreturn? = nil) {
        let param = ["ids":threadIds];
        makeRequestAlamofire(viewController, method: .DELETE, url: Url.messages, param: param) { status, JSON in
            if status == .Success{
                clientData.deleteThreads(threadIds)
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }

    
    static func register (viewController: UIViewController? = nil, username: String, firstName: String, lastName: String, email: String, password: String, passwordConfirm: String, callback: JSONreturn? = nil) {
        let param = ["username":username,
                     "firstName":firstName,
                     "lastName":lastName,
                     "email":email,
                     "password":password,
                     "passwordConfirm":passwordConfirm];
        makeRequestAlamofire(viewController, method: .POST, url: Url.register, param: param) { status, JSON in
            if (JSON != nil) {
                print (JSON);
            }
            if (status == .Success) {
                Util.showMessageInViewController(viewController, title: "Success", message: "You have successfully registered. Please allow some time for the system to process your registration. You will get notification on your email when your account has been activated. Thank you.", buttonOKTitle: "Ok") {
                    if (callback != nil) { callback! (status, JSON); }
                }
            }
            else {
                if (callback != nil) { callback! (status, JSON); }
            }
        }
    }
    
    static func createGroup (viewController: UIViewController? = nil, type: String, title: String, desc: String, userId: [Int], parentId: String? = nil, callback: JSONreturn? = nil) {
        var param = Dictionary<String, AnyObject>();
        param = ["type":type, "participants":userId, "name":title, "description":desc];
        if (parentId != nil && parentId != "") { param["parent"] = parentId!; }
        print (param);
        makeRequestAlamofire(viewController, method: .POST, url: Url.groups, param: param) { status, JSON in
            if (JSON == nil) {
                Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there was an error when creating the group");
                if (callback != nil) { callback! (status, JSON); }
            }
            else {
                let dict = getDictData(JSON);
                print (dict);
                //            clientData.addNewThread(dictData);
                if (callback != nil) { callback! (status, dict); }
            }
        }
    }
    
    static func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
    }
}