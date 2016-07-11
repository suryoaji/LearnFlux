//
//  Engine.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/6/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import Alamofire

enum RequestStatusType {
    case InternetNotWorking
    case InvalidAccessToken
    case ServerError
    case GeneralError
    case CustomError
    case NoResponseError
    case Success
}

typealias JSONreturn = ((RequestStatusType, AnyObject?)->Void);


class Engine : NSObject {
    static var locked : Bool = false;
    
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
        return (Data.isProduction ? "" : "\nStatus code: \n\(statusCode)")
    }
    
    static func authHeaders() -> Dictionary<String, String> {
        let header : Dictionary<String, String> = [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(Data.accessToken)"
        ];
        print ("header: \(header)");
        return header;
    }
    
    static func statusMaker (statusCode : Int?, JSON : AnyObject?)->RequestStatusType {
        if (JSON != nil) {
            if (JSON!.objectForKey("error") != nil || JSON!.objectForKey("errors") != nil) {
                return .CustomError;
            }
        }

        if (statusCode == nil) {
            return .GeneralError;
        }
        else {
            switch (statusCode!) {
            case 200...299: return .Success;
            case 401: return .InvalidAccessToken;
            case 500: return .ServerError;
            default: return .GeneralError;
            }
        }
    }
    
    static func makeQueryString (param: Dictionary<String,AnyObject>)->String {
        var result = "";
        for (key, value) in param {
            if (result != "") { result += "&"; }
            result += key + "=" + (value as! String);
        }
        result = result.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!;
        if (result != "") { result = "?" + result; }
        return result;
    }
    
    static func makeToken (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
        var mparam : Dictionary<String,AnyObject> = (param != nil ? param! : [:]);
        mparam["grant_type"] = "password";
        mparam["client_id"] = Data.clientId;
        mparam["client_secret"] = Data.clientSecret;
        mparam["username"] = Data.username;
        mparam["password"] = Data.password;
        mparam["scope"] = Data.scope;
        var getparam = Dictionary<String, AnyObject>();
        var postparam = Dictionary<String, AnyObject>();
        if (method == .GET) { getparam = mparam; }
        else if (method == .POST) { postparam = mparam; }
        
        let geturl = (url + makeQueryString(getparam));
        print (geturl);
        Alamofire.request(method, geturl, parameters: postparam, headers: nil)
            .responseJSON { response in
                var res : Int? = nil;
                res = response.response?.statusCode;
                let JSON = response.result.value
                print ("JSON: \(JSON)");
                let restat = statusMaker(res, JSON: JSON);
                print ("Request: " + geturl + "\nStatus code: \(res)" + "\nStatus : \(restat)");
                if (res == nil) {
                    if (callback != nil) { callback!(restat, JSON); }
                    return;
                }
                if (restat == .CustomError) {
                    if (JSON!["error_description"] != nil) {
                        Util.showMessageInViewController(viewController, title: "Error", message: JSON!["error_description"] as! String) {
                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                        }
                    }
                    else {
                        Util.showMessageInViewController(viewController, title: "Error", message: "\(JSON!["error"])") {
                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                        }
                    }
                }
                else if (restat == .InvalidAccessToken) {
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                }
                else if (response.response?.statusCode != 200) {
                    Util.showMessageInViewController(viewController, title: "Error", message: "An error occured. Error code: \(response.response!.statusCode)")
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                    print ("AN ERROR OCCURED while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response!.statusCode)");
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                }
        }
    }
    
    static func refreshToken (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        self.makeToken(viewController, method: .GET, url: Url.token, param: nil) { status, JSON in
            if (status == .Success) {
                Data.accessToken = JSON!["access_token"]! as! String;
                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (status, JSON); } } );
            }
        }
    }
    
    static func makeRequest (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
        let mparam : Dictionary<String,AnyObject> = (param != nil ? param! : [:]);
        var getparam = Dictionary<String, AnyObject>();
        var postparam = Dictionary<String, AnyObject>();
        if (method == .GET) { getparam = mparam; }
        else if (method == .POST) { postparam = mparam; }
        
        let geturl = (url + makeQueryString(getparam));
        print (geturl);
        Alamofire.request(method, geturl, parameters: postparam, headers: authHeaders())
            .responseJSON { response in
                print("Request result ===============================")
                print(response);
                let res = response.response!.statusCode;
                let JSON = response.result.value
                let restat = statusMaker(res, JSON: JSON);
                print ("Request: " + geturl + "\nStatus code: \(res)" + "\nStatus : \(restat)");
                print ("JSON: \(JSON)");
                if (restat == .CustomError) {
                    Util.showMessageInViewController(viewController, title: "Error", message: JSON!["error_description"] as! String) {
                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                    };
                }
                else if (restat == .InvalidAccessToken) {
                    refreshToken() { status, JSON in
                        if JSON == nil {
                            Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
                                print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response?.statusCode)");
                                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                            }
                        }
                        else {
                            if (!locked) {
                                locked = true;
                                makeRequest(viewController, method: method, url: url, param: param) { status, JSON in
                                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                    locked = false;
                                }
                            }
                        }
                    }
                }
                else if (response.response?.statusCode != 200) {
                    Util.showMessageInViewController(viewController, title: "Error", message: "An error occured. Error code: \(response.response!.statusCode)")
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                    print ("AN ERROR OCCURED while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response!.statusCode)");
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                }
        }
    }
    
    static func makeRequest2  (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
        var headers : [String: String]!
        if url == Url.register {
            headers = [
                "Content-Type": "application/json",
                "cache-control": "no-cache"
            ]
        }
        else {
            headers = [
                "authorization": "Bearer \(Data.accessToken)",
                "Content-Type": "application/json",
                "cache-control": "no-cache"
            ]
        }
        
        do {
            let mparam = (param == nil ? [:] : param!);
            var getparam = Dictionary<String, AnyObject>();
            var postparam = Dictionary<String, AnyObject>();
            if (method == .GET) { getparam = mparam; }
            else if (method == .POST) { postparam = mparam; }
            
            if (method == .DELETE && url == Url.messages) { postparam = mparam; }
            
            let geturl = (url + makeQueryString(getparam));

            let postData = try NSJSONSerialization.dataWithJSONObject(postparam, options: NSJSONWritingOptions.PrettyPrinted)
//            let postData = NSData(data: getJSON(postparam).dataUsingEncoding(NSUTF8StringEncoding)!)
            let request = NSMutableURLRequest(URL: NSURL(string: geturl)!,
                                              cachePolicy: .UseProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.HTTPMethod = "\(method)";
            request.allHTTPHeaderFields = headers
            if (postparam.count > 0) {
                request.HTTPBody = postData;
            }
            
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    do {
                        let httpResponse = response as? NSHTTPURLResponse
                        var JSON : AnyObject = [:];
                        if (httpResponse?.statusCode != 204) {
                            JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:[])
                        }
                        let restat = statusMaker((httpResponse?.statusCode)!, JSON: JSON);
//                        print (JSON);
                        switch (restat) {
                        case .Success:
                            if (callback != nil) { callback! (restat, JSON); }
                            break;
                        case .CustomError:
                            if let errorDesc = JSON["error_description"]! {
                                Util.showMessageInViewController(viewController, title: "Error", message: errorDesc as! String) {
                                    if (callback != nil) { callback! (restat, JSON); }
                                }
                            }
                            else {
                                if (callback != nil) { callback! (restat, JSON); }
                            }
                            break;
                        case .InvalidAccessToken:
                            if (!locked) {
                                locked = true;
                                refreshToken() { status, JSON in
                                    if JSON == nil {
                                        Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
                                            print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(httpResponse!.statusCode)");
                                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                        }
                                    }
                                    else {
                                        makeRequest2(viewController, method: method, url: url, param: param) { status, JSON in
                                            dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                                        }
                                    }
                                }
                            }
                            locked = false;
                            break;
                        default:
                            Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later." + printErrorCode(httpResponse!.statusCode)) {
                                dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (restat, JSON); } } );
                            };
                            break;
                        }
                    } catch let error as NSError {
                        print(error)
                        Util.showMessageInViewController(viewController, title: "Error", message: "Sorry, there's an error occured while carrying out your request. Please try again later.")
                        dispatch_async(dispatch_get_main_queue(),{ if (callback != nil) { callback! (RequestStatusType.GeneralError, nil); } } );
                    }
                }
            })
            
            dataTask.resume()
        } catch let error as NSError {
            print(error)
        }

    }
        
    static func login (viewController: UIViewController? = nil, username : String, password : String, callback: JSONreturn? = nil) {
        Data.username = username;
        Data.password = password;
        refreshToken(viewController) { status, JSON in
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
    
    static func me (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        makeRequest(url: Url.me, param: nil) { status, JSON in
            if (JSON != nil) {
                print ("me: \(JSON!)");
                if (JSON!.valueForKey("data") != nil) {
                    let data = JSON!.valueForKey("data")!;
                    Data.defaults.setValue(data, forKey: "me");
                    Data.defaults.synchronize();
                }
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func createThread (viewController: UIViewController? = nil, title: String = "", userId: [Int], callback: JSONreturn? = nil) {
        let param = ["participants":userId, "title":title] as [String: AnyObject];
        print (self.getJSON(param));
        
        makeRequest2(viewController, method: .POST, url: Url.messages, param: param) { status, JSON in
            if (JSON != nil) { print (JSON!); }
            if (!Data.saveNewThreadInfo(threadJSON: JSON)) {
                Util.showMessageInViewController(viewController, title: "Failed to create new thread", message: "Sorry, there's problems on creating new thread for these participants. Please try again later.") {
                    if (callback != nil) { callback! (status, JSON); }
                }
            }
            else {
                if (callback != nil) { callback! (status, JSON); }
            }
        }
    }
    
    static func getThreads (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        makeRequest2(viewController, method: .GET, url: Url.messages, param: nil) { status, JSON in
            if (JSON != nil) {
                print ("threads: \(JSON!)");
                if (JSON!.valueForKey("data") != nil) {
                    let data = JSON!.valueForKey("data")!;
                    print ("threads data: \(data)");
                    Data.defaults.setObject(data, forKey: "threads");
                    Data.defaults.synchronize();
                }
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func generateThreadName (thread: NSDictionary) -> String {
        if (thread.valueForKey("title") != nil) {
            return thread.valueForKey("title")! as! String;
        }
        let participants = thread.valueForKey("participants")! as! Array<NSDictionary>;
        var chatName = "";
        for participant in participants {
            let me = Data.defaults.valueForKey("me")! as! NSDictionary;
            let selfId = me.valueForKey("id")! as! Int;
            let participantId = participant.valueForKey("id")! as! Int;
            if (participantId != selfId) {
                if (chatName != "") { chatName += ", "; }
                chatName += String(participant["id"] as! Int);
//                chatName += participant["username"] as! String;
            }
        }
        return chatName;
    }
    
    static func getThreadMessages (viewController: UIViewController? = nil, threadId: String, callback: JSONreturn? = nil) {
        makeRequest2(viewController, method: .GET, url: Url.messages + "/" + threadId, param: nil) { status, JSON in
            if (JSON != nil) {
//                print ("thread messages: \(JSON!)");
                if (JSON!.valueForKey("data") != nil) {
                    let data = JSON!.valueForKey("data")!;
                    let messages = data.valueForKey("messages")!;
                    Data.defaults.setObject(messages, forKey: threadId);
                    Data.defaults.synchronize();
                }
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
    static func sendThreadMessage (viewController: UIViewController? = nil, threadId: String, body: String, callback: JSONreturn? = nil) {
        let param = ["body":body];
        makeRequest2(viewController, method: .POST, url: Url.messages + "/" + threadId, param: param) { status, JSON in
            if (JSON != nil) {
                print ("thread messages: \(JSON!)");
                if (JSON!.valueForKey("data") != nil) {
                    let data = JSON!.valueForKey("data")!;
                    let messages = data.valueForKey("messages")!;
                    Data.defaults.setObject(messages, forKey: threadId);
                    Data.defaults.synchronize();
                }
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
    
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
        makeRequest2(viewController, method: .DELETE, url: Url.messages, param: param) { status, JSON in
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
        makeRequest2(viewController, method: .POST, url: Url.register, param: param) { status, JSON in
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

    
}