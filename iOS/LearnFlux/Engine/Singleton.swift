//
//  Singleton.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import Alamofire

class Data : NSObject {
    static let defaults = NSUserDefaults.standardUserDefaults();

    static let clientId = "57453e293a603f8c168b4567_5gj7ywf0ocsoosw0sc8sgsgk8gckkc80o8co8gg00o08g88c4o";
    static let clientSecret = "2hwdia2smbk00sko0wokowcwokswc0k448gsk0okwswcsgcw0g";
    static let scope = "internal";
    
    static var username = "admin";
    static var password = "admin";
    
    static var accessToken : String! = "";
    
}