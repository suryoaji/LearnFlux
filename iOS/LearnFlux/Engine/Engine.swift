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
    case AccessTokenUnobtainable
    case ServerError
    case GeneralError
    case RequestError
    case NoResponseError
    case Success
}

typealias JSONreturn = ((RequestStatusType, AnyObject?)->Void);


class Engine : NSObject {
    
    static func statusMaker (statusCode : Int, JSON : AnyObject?)->RequestStatusType {
        if (JSON != nil) {
            if (JSON!.objectForKey("error") != nil) {
                return .RequestError;
            }
        }
        else { return .NoResponseError }

        switch (statusCode) {
        case 200: return .Success;
        case 400...499: return .AccessTokenUnobtainable;
        case 500: return .ServerError;
        default: return .GeneralError;
        }
    }
    
    static func makeQueryString (param: Dictionary<String,AnyObject>)->String {
        var result = "";
        for (key, value) in param {
            if (result != "") { result += "&"; }
            result += key + "=" + (value as! String);
        }
        if (result != "") { result = "?" + result; }
        return result;
    }
    
    static func makeRequest (viewController: UIViewController? = nil, method : Alamofire.Method = .GET, url: String, param: Dictionary<String,AnyObject>?, callback: JSONreturn? = nil) {
        var mparam : Dictionary<String,AnyObject> = (param != nil ? param! : [:]);
        mparam["grant_type"] = "password";
        mparam["client_id"] = Data.clientId;
        mparam["client_secret"] = Data.clientSecret;
        mparam["username"] = Data.username;
        mparam["password"] = Data.password;
        mparam["scope"] = Data.scope;
        mparam["access_token"] = Data.accessToken;
        var getparam = Dictionary<String, AnyObject>();
        var postparam = Dictionary<String, AnyObject>();
        if (method == .GET) { getparam = mparam; }
        else if (method == .POST) { postparam = mparam; }
        
        let geturl = url + makeQueryString(getparam);
        
        Alamofire.request(method, geturl, parameters: postparam, headers: nil)
            .responseJSON { response in
                let res = response.response!.statusCode;
                let JSON = response.result.value
                print ("JSON: \(JSON)");
                let restat = statusMaker(res, JSON: JSON);
                print ("Request: " + geturl + "\nStatus code: \(res)" + "\nStatus : \(restat)");
                if (restat == .RequestError) {
                    Util.showMessageInViewController(viewController, title: "Error", message: JSON!["error_description"] as! String) {
                        if (callback != nil) { callback! (restat, JSON); }
                    };
                }
                else if (restat == .AccessTokenUnobtainable) {
                    if (url.rangeOfString(Url.token) == nil) {
                        refreshToken() { status, JSON in
                            if JSON == nil {
                                Util.showMessageInViewController(viewController, title: "Error", message: "There's an error with the network. Please try again later.") {
                                    print ("CANNOT OBTAIN ACCESS TOKEN ERROR occured while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response?.statusCode)");
                                    if (callback != nil) { callback! (restat, JSON); }
                                }
                            }
                            else {
                                if (callback != nil) { callback! (restat, JSON); }
                            }
                        }
                    }
                    else if (callback != nil) { callback! (restat, JSON); }
                }
                else if (response.response?.statusCode != 200) {
                    Util.showMessageInViewController(viewController, title: "Error", message: "An error occured. Error code: \(response.response?.statusCode)")
                    if (callback != nil) { callback!(restat, nil); }
                    print ("AN ERROR OCCURED while making request for url = \(geturl)\nWith param: \(mparam)\nError code: \(response.response?.statusCode)");
                }
                else {
                    if (callback != nil) { callback! (restat, JSON); }
                }
        }
    }
    
    static func refreshToken (viewController: UIViewController? = nil, callback: JSONreturn? = nil) {
        self.makeRequest(viewController, method: .GET, url: Url.token, param: nil) { status, JSON in
            if (status == .Success) {
//                print (JSON);
                Data.accessToken = JSON!["access_token"]! as! String;
                if (callback != nil) {
                    callback! (status, JSON);
                }
            }
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
                print ("me: \(JSON)")
                Data.defaults.setValue(JSON, forKey: "me");
                Data.defaults.synchronize();
            }
            if (callback != nil) { callback! (status, JSON); }
        }
    }
}