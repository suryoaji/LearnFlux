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
    case None
}

typealias dictType = Dictionary<String, AnyObject>
typealias arrType = Array<dictType>
typealias JSONreturn = ((RequestStatusType, AnyObject?)->Void)

struct LFColor{
    static let green = UIColor(red: 124/255.0, green: 191/255.0, blue: 49/255.0, alpha: 1)
}

class Engine : NSObject {
    static var clientData = Data.sharedInstance
    private static var locked : Bool = false;
    
    static func isAdminOfGroup(group: Group) -> (Bool){
        guard let participants = group.participants?.filter({ $0.user!.userId! == clientData.cacheMe()!["id"] as! Int }) where !participants.isEmpty else{
            return false
        }
        guard let role = participants.first!.role else{
            return false
        }
        if role.type.lowercaseString == "admin"{
            return true
        }
        return false
    }
    
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
    
    static func makeRequestAlamofire(viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, requestType : RequestType = .None, callback: JSONreturn? = nil) {
        let urlReq = self.createURLRequest(url, method: method, param: param)
        Alamofire.request(method, urlReq.URLString, parameters: method == .GET ? nil : param, encoding: .JSON, headers: urlReq.allHTTPHeaderFields)
            .responseJSON { response in
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
                            Util.showMessageInViewController(viewController, title: "Error", message: errorDesc as! String) {
                                if (callback != nil) { callback! (restat, json); }
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
                                        makeRequestAlamofire(viewController, method: method, url: url, param: param) { status, JSON in
                                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                        }
                                    }
                                }
                            }
                            locked = false;
                        }
                        break;
                    default:
                        print("Error")
                        print("Status Code: \(response.response!.statusCode)")
                        print("JSON: \(json)")
                        Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later." + printErrorCode((response.response?.statusCode)!)) {
                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, json); } } );
                        };
                        break;
                    }
                }
        }
    }
    
    private static func createURLRequest(string: String, method: Alamofire.Method, param: Dictionary<String,AnyObject>?) -> (NSMutableURLRequest){
        let headers = authHeaders(string)
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
        urlReq.URL = NSURL(string: newUrl)!
        urlReq.cachePolicy = .UseProtocolCachePolicy
        urlReq.timeoutInterval = 10.0
        urlReq.HTTPMethod = "\(method)"
        urlReq.allHTTPHeaderFields = headers
        return urlReq
    }
    
    private static func authHeaders(urlString: String) -> (Dictionary<String, String>){
        let headers : Dictionary<String, String> = [
            "Content-Type"  : "application/json",
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
        makeRequestAlamofire(url: Url.me, param: nil) { status, JSON in
            if (JSON != nil) {
                if (JSON!.valueForKey("data") != nil) {
                    clientData.saveMe(JSON!.valueForKey("data")!)
                }
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
                    if status == .Success{
                        if let dict = self.getDictData(JSON){
                            if let newEvent = Event.convertToEvent(dict){
                                clientData.updateSpecificEventsByIdGroup(idGroup, events: [newEvent])
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func getEvents(viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.events, param: nil){ status, dataJSON in
            if let rawJSON = dataJSON{
                let json = JSON(rawJSON).dictionaryObject
                if let data = json?["data"]{
                    let arrData = data as! Array<Dictionary<String, AnyObject>>
                    clientData.setMyEvents(arrData)
                }
            }
            if callback != nil{ callback!(status, dataJSON) }
        }
    }
    
    static func getConnection(viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.connections, param: nil){ status, dataJSON in
            if let rawJSON = dataJSON{
                let json = JSON(rawJSON).dictionaryObject
                if let data = json?["data"]{
                    let arrData = data as! Array<Dictionary<String, AnyObject>>
                    clientData.setMyConnections(arrData)
                }
            }
            if callback != nil{ callback!(status, dataJSON) }
        }
    }
    
    static func getEventDetail(viewController: UIViewController? = nil, event: Event, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, url: Url.events + "/\(event.id)", param: nil){ status, JSON in
            if status == .Success{
                if let dictJSON = JSON!["data"] as? Dictionary<String, AnyObject>{
                    event.updateMe(dictJSON)
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

    static func getGroups(viewController: UIViewController? = nil, filter: GroupType = .All, callback: ((RequestStatusType, [Group]?)->Void)? = nil) -> [Group]? {
        makeRequestAlamofire(viewController, url: Url.groups, param: nil){ status, dataJSON in
            
            if let groups = self.getArrData(dataJSON) { self.clientData.setGroups(groups); }
            if callback != nil { callback!(status, clientData.getGroups(filter)) }
        }
        return clientData.getGroups(filter);
    }
    
    //Create Interest Group in API
    static func createGroupChat (viewController: UIViewController? = nil, name: String = "", description: String = "", userId: [Int], callback: JSONreturn? = nil) {
        let param : Dictionary<String, AnyObject> =
                    ["type"        : "group",
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

    static func getGroupInfo(viewController: UIViewController? = nil, groupId: String, callback: ((RequestStatusType, Group?)->Void)? = nil) {
        let url = Url.groups + "/" + groupId;
        makeRequestAlamofire(viewController, url: url, param: nil){ status, dataJSON in
            let data = self.getDictData(dataJSON);
            if callback != nil { callback!(status, Group (dict: data)) }
        }
    }
    
    static func getThreads (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        var lastSync : Double = 0
        if let cacheLastSync = clientData.cacheLastSyncThreads(){
            lastSync = cacheLastSync
        }
        let param = ["lastSync" : String(lastSync)]
        makeRequestAlamofire(viewController, method: .GET, url: Url.messages, param: param) { status, rawJSON in
            if (rawJSON != nil) {
                if (rawJSON!.valueForKey("data") != nil) {
                    let data = rawJSON!.valueForKey("data")! as! Array<Dictionary<String, AnyObject>>
                    let newSync = rawJSON!.valueForKey("lastSync") as! Double
                    let newThreads = self.updateThreadsByLastSync(data, fromLastSync: newSync)
                    clientData.saveAllThreads(newThreads, lastSync: String(newSync))
                    clientData.setThreads(newThreads)
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
            if (rawJSON != nil) {
                if (rawJSON!.valueForKey("data") != nil) {
                    let threads = rawJSON!.valueForKey("data")! as! Array<Dictionary<String, AnyObject>>
                    if let rawMessages = threads[indexpath]["messages"]{
                        let messages = rawMessages as! Array<Dictionary<String, AnyObject>>
                        if let result = Thread.getMessagesFromArr(messages){
                            if (callback != nil) { callback! (status: status, newMessage: result, lastSync: rawJSON!["lastSync"]! as! Double) }
                            return
                        }
                    }
                }
                if (callback != nil) { callback! (status: status, newMessage: nil, lastSync: rawJSON!["lastSync"]! as! Double) }
            }
        }
    }
    
    static func updateStatusEvent(status: Int, inout rowEvent: Int?, specificGroup: String? = nil, callback: JSONreturn? = nil){
        if let idGroup = specificGroup{
            if let events = clientData.getSpecificEventsByIdGroup(idGroup) where !events.isEmpty{
                if events[rowEvent!].status != status{
                    makeRequestAlamofire(method: .PUT, url: Url.events + "/\(events[rowEvent!].id)", param: ["rsvp" : status], callback: { (stateReq, _) in
                        if stateReq == .Success{
                            clientData.getSpecificEventsByIdGroup(idGroup)![rowEvent!].status = status
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
                let event = Event.convertToEvent(dict!)
                let idGroup = (param!["reference"] as! Dictionary<String, AnyObject>)["id"] as! String
                clientData.updateSpecificEventsByIdGroup(idGroup, events: [event!])
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
}