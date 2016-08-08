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

typealias JSONreturn = ((RequestStatusType, AnyObject?)->Void);

class Engine : NSObject {
    static var clientData = Data.sharedInstance
    private static var locked : Bool = false;
    
    static func getJSON (param: [String: AnyObject])->String {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(param, options: NSJSONWritingOptions.PrettyPrinted)
            let dataString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!
//            print (dataString);
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
    
    static func getGroups(viewController: UIViewController? = nil, callback: JSONreturn? = nil){
        makeRequestAlamofire(viewController, method: .GET, url: Url.groups, param: nil) { status, rawJSON in
            if let rawJSON = rawJSON! as? Dictionary<String, AnyObject>{
                if let rawData = rawJSON["data"]{
                    clientData.setGroups(rawData as! Array<Dictionary<String, AnyObject>>)
                }
            }
            if (callback != nil) { callback! (status, rawJSON); }
        }
    }
    
    static func createThread (viewController: UIViewController? = nil, title: String = "", userId: [Int], callback: JSONreturn? = nil) {
        let param = ["participants":userId, "title":title] as [String: AnyObject];
        makeRequestAlamofire(viewController, method: .POST, url: Url.messages, param: param) { status, JSON in
            if let rawJSON = JSON{
                if let rawData = (rawJSON as! Dictionary<String, AnyObject>)["data"]{
                    let dictData = rawData as! Dictionary<String, AnyObject>
                    clientData.addNewThread(dictData)
                }
            }
            if (callback != nil) { callback! (status, JSON); }
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
            if (participant != selfId) {
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
            print()
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
    
//    static func sendThreadMessage (viewController: UIViewController? = nil, threadId: String, body: String, callback: JSONreturn? = nil) {
//        let param = ["body":body];
//        //        makeRequest2(viewController, method: .POST, url: Url.messages + "/" + threadId, param: param) { status, JSON in
//        makeRequestAlamofire(viewController, method: .POST, url: Url.messages + "/" + threadId, param: param) { status, JSON in
//            if (callback != nil) { callback! (status, JSON); }
//        }
//    }
    
//    static func getThreadMessages (viewController: UIViewController? = nil, threadId: String, callback: JSONreturn? = nil) {
////        makeRequest2(viewController, method: .GET, url: Url.messages + "/" + threadId, param: nil) { status, JSON in
//        makeRequestAlamofire(viewController, method: .GET, url: Url.messages + "/" + threadId, param: nil) { status, JSON in
//            if (JSON != nil) {
////                print ("thread messages: \(JSON!)");
//                if (JSON!.valueForKey("data") != nil) {
//                    let data = JSON!.valueForKey("data")!;
//                    let messages = data.valueForKey("messages")!;
//                    clientData.defaults.setObject(messages, forKey: threadId);
//                    clientData.defaults.synchronize();
//                }
//            }
//            if (callback != nil) { callback! (status, JSON); }
//        }
//    }
    
//    static func deleteThreads (viewController: UIViewController? = nil, threadIds: [String], callback: JSONreturn? = nil) {
//        var executed : Int = 0;
//        var failed : Int = 0;
//        for threadId in threadIds {
//            let param = ["id":threadId];
//            makeRequest2(viewController, method: .DELETE, url: Url.messages, param: param) { status, JSON in
//                executed += 1;
//                if (status != RequestStatusType.Success) { failed += 1; }
//                if (executed == threadIds.count) {
//                    if (failed > 0) {
//                        Util.showMessageInViewController(viewController, title: "Failed", message: "From \(executed) threads to delete, \(failed) threads failed to delete.", buttonOKTitle: "Ok", callback: {
//                            if (callback != nil) { callback! (.GeneralError, JSON); }
//                        })
//                    }
//                    else {
//                        Util.showMessageInViewController(viewController, title: "Success", message: "\(executed) threads deleted successfully.", buttonOKTitle: "Ok", callback: {
//                            if (callback != nil) { callback! (status, JSON); }
//                        })
//                    }
//                }
//            }
//        }
//    }
  
    static func deleteThreads (viewController: UIViewController? = nil, threadIds: [String], callback: JSONreturn? = nil) {
        let param = ["ids":threadIds];
//        makeRequest2(viewController, method: .DELETE, url: Url.messages, param: param) { status, JSON in
        makeRequestAlamofire(viewController, method: .DELETE, url: Url.messages, param: param) { status, JSON in
            if (JSON != nil) { print (JSON!); }
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

    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////                                                                    OLD REQUEST METHOD                                                                              /////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    static func makeRequest (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
//        let mparam : Dictionary<String,AnyObject> = (param != nil ? param! : [:]);
//        var getparam = Dictionary<String, AnyObject>();
//        var postparam = Dictionary<String, AnyObject>();
//        if (method == .GET) { getparam = mparam; }
//        else if (method == .POST) { postparam = mparam; }
//        
//        let geturl = (url + makeQueryString(getparam));
//        print (geturl);
//        Alamofire.request(method, geturl, parameters: postparam, headers: authHeaders())
//            .responseJSON { response in
//                print("Request result ===============================")
//                print(response);
//                let res = response.response!.statusCode;
//                let JSON = response.result.value
//                let restat = statusMaker(res, JSON: JSON);
//                print ("Request: " + geturl + "\nStatus code: \(res)" + "\nStatus : \(restat)");
//                print ("JSON: \(JSON)");
//                if (restat == .CustomError) {
//                    Util.showMessageInViewController(viewController, title: "Error", message: JSON!["error_description"] as! String) {
//                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                    };
//                }
//                else if (restat == .InvalidAccessToken) {
//                    refreshToken() { status, JSON in
//                        if JSON == nil {
//                            Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
//                                print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response?.statusCode)");
//                                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                            }
//                        }
//                        else {
//                            if (!locked) {
//                                locked = true;
//                                makeRequest(viewController, method: method, url: url, param: param) { status, JSON in
//                                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                                    locked = false;
//                                }
//                            }
//                        }
//                    }
//                }
//                else if (response.response?.statusCode != 200) {
//                    Util.showMessageInViewController(viewController, title: "Error", message: "An error occured. Error code: \(response.response!.statusCode)")
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                    print ("AN ERROR OCCURED while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response!.statusCode)");
//                }
//                else {
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                }
//        }
//    }
//    
//    static func makeRequest2  (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
//        var headers : [String: String] = ["Content-Type": "application/json",
//                                          "cache-control": "no-cache"]
//        if url != Url.register{
//            headers["authorization"] = "Bearer \(Data.accessToken)"
//        }
//        
//        do {
//            let mparam = (param == nil ? [:] : param!);
//            var getparam = Dictionary<String, AnyObject>();
//            var postparam = Dictionary<String, AnyObject>();
//            if (method == .GET) { getparam = mparam; }
//            else if (method == .POST) { postparam = mparam; }
//            
//            if (method == .DELETE && url == Url.messages) { postparam = mparam; }
//            
//            let geturl = (url + makeQueryString(getparam));
//            
//            let postData = try NSJSONSerialization.dataWithJSONObject(postparam, options: NSJSONWritingOptions.PrettyPrinted)
//            //            let postData = NSData(data: getJSON(postparam).dataUsingEncoding(NSUTF8StringEncoding)!)
//            let request = NSMutableURLRequest(URL: NSURL(string: geturl)!,
//                                              cachePolicy: .UseProtocolCachePolicy,
//                                              timeoutInterval: 10.0)
//            request.HTTPMethod = "\(method)";
//            request.allHTTPHeaderFields = headers
//            if (postparam.count > 0) {
//                request.HTTPBody = postData;
//            }
//            
//            let session = NSURLSession.sharedSession()
//            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                if (error != nil) {
//                    print(error)
//                } else {
//                    do {
//                        let httpResponse = response as? NSHTTPURLResponse
//                        var JSON : AnyObject = [:];
//                        if (httpResponse?.statusCode != 204) {
//                            JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
//                        }
//                        let restat = statusMaker((httpResponse?.statusCode)!, JSON: JSON);
//                        //                        print (JSON);
//                        switch (restat) {
//                        case .Success:
//                            if (callback != nil) { callback! (restat, JSON); }
//                            break;
//                        case .CustomError:
//                            if let errorDesc = JSON["error_description"]! {
//                                Util.showMessageInViewController(viewController, title: "Error", message: errorDesc as! String) {
//                                    if (callback != nil) { callback! (restat, JSON); }
//                                }
//                            }
//                            else {
//                                if (callback != nil) { callback! (restat, JSON); }
//                            }
//                            break;
//                        case .InvalidAccessToken:
//                            if (!locked) {
//                                locked = true;
//                                refreshToken() { status, JSON in
//                                    if JSON == nil {
//                                        Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
//                                            print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(httpResponse!.statusCode)");
//                                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                                        }
//                                    }
//                                    else {
//                                        makeRequest2(viewController, method: method, url: url, param: param) { status, JSON in
//                                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                                        }
//                                    }
//                                }
//                            }
//                            locked = false;
//                            break;
//                        default:
//                            Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later." + printErrorCode(httpResponse!.statusCode)) {
//                                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                            };
//                            break;
//                        }
//                    } catch let error as NSError {
//                        print(error)
//                        Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later.")
//                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (RequestStatusType.GeneralError, nil); } } );
//                    }
//                }
//            })
//            
//            dataTask.resume()
//        } catch let error as NSError {
//            print(error)
//        }
//        
//    }
//    
//    static func makeRequestRemake(viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
//        let urlReq = self.makeURLRequest(url, method: method, param: param)
//        self.requestURL(urlReq){ (data, response, error) in
//            if (error != nil) {
//                print(error)
//            } else {
//                do {
//                    let httpResponse = response as? NSHTTPURLResponse
//                    var JSON : AnyObject = [:];
//                    if (httpResponse?.statusCode != 204) {
//                        JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
//                    }
//                    let restat = statusMaker((httpResponse?.statusCode)!, JSON: JSON);
//                    //                        print (JSON);
//                    switch (restat) {
//                    case .Success:
//                        if (callback != nil) { callback! (restat, JSON); }
//                        break;
//                    case .CustomError:
//                        if let errorDesc = JSON["error_description"]! {
//                            Util.showMessageInViewController(viewController, title: "Error", message: errorDesc as! String) {
//                                if (callback != nil) { callback! (restat, JSON); }
//                            }
//                        }
//                        else {
//                            if (callback != nil) { callback! (restat, JSON); }
//                        }
//                        break;
//                    case .InvalidAccessToken:
//                        if (!locked) {
//                            locked = true;
//                            refreshToken() { status, JSON in
//                                if JSON == nil {
//                                    Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
//                                        print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(urlReq.URLString)\nWith param: \(param!)\nError code: \(httpResponse!.statusCode)");
//                                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                                    }
//                                }
//                                else {
//                                    makeRequestRemake(viewController, method: method, url: url, param: param!) { status, JSON in
//                                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                                    }
//                                }
//                            }
//                        }
//                        locked = false;
//                        break;
//                    default:
//                        Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later." + printErrorCode(httpResponse!.statusCode)) {
//                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                        };
//                        break;
//                    }
//                } catch let error as NSError {
//                    print(error)
//                    Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later.")
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (RequestStatusType.GeneralError, nil); } } );
//                }
//            }
//        }
//    }
//    
//    static func requestURL(urlRequest: NSMutableURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?)->Void){
//        let session = NSURLSession.sharedSession()
//        let dataTask = session.dataTaskWithRequest(urlRequest, completionHandler: completionHandler)
//        dataTask.resume()
//    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////                                                                    OLD MAKETOKEN METHOD                                                                            /////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    static func makeToken (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
//        var mparam : Dictionary<String,AnyObject> = (param != nil ? param! : [:])
//        mparam["grant_type"] = "password";
//        mparam["client_id"] = Data.clientId;
//        mparam["client_secret"] = Data.clientSecret;
//        mparam["username"] = Data.username;
//        mparam["password"] = Data.password;
//        mparam["scope"] = Data.scope;
//        
//        let urlReq = makeURLRequest(url, method: method, param: mparam)
//        Alamofire.request(method, urlReq.URLString, parameters: method == .GET ? nil : mparam)
//            .responseJSON { response in
//                var res : Int? = nil;
//                res = response.response?.statusCode;
//                let JSON = response.result.value
//                print ("JSON: \(JSON)");
//                let restat = statusMaker(res, JSON: JSON);
//                print ("Request: " + urlReq.URLString + "\nStatus code: \(res)" + "\nStatus : \(restat)");
//                if (res == nil) {
//                    if (callback != nil) { callback!(restat, JSON); }
//                    return;
//                }
//                if (restat == .CustomError) {
//                    if (JSON!["error_description"] != nil) {
//                        Util.showMessageInViewController(viewController, title: "Error", message: JSON!["error_description"] as! String) {
//                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                        }
//                    }
//                    else {
//                        Util.showMessageInViewController(viewController, title: "Error", message: "\(JSON!["error"])") {
//                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                        }
//                    }
//                }
//                else if (restat == .InvalidAccessToken) {
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                }
//                else if (response.response?.statusCode != 200) {
//                    Util.showMessageInViewController(viewController, title: "Error", message: "An error occured. Error code: \(response.response!.statusCode)")
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                    print ("AN ERROR OCCURED while making request for url = \(urlReq.URLString)\nWith param: \(mparam)\nError code: \(response.response!.statusCode)");
//                }
//                else {
//                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
//                }
//        }
//    }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}