//
//  User.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/10/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct User {
    
    var userId : Int?;
    var type : String?;
    var link : String?;
    
    init () { }
    
    init (userId: Int?, type: String?, link: String?) {
        self.userId = userId;
        self.type = type;
        self.link = link;
    }
    
    init (dict : AnyObject?)  {
//        guard let data = User.convertFromDict(dict) else { return; }
        guard let data = dict else { return; }
        if let s = data["id"] as? Int { self.userId = s; }
        if let s = data["type"] as? String { self.type = s; }
        if let s = data["link"] as? String { self.link = s; }
    }
    
    static func convertFromArr (arr : AnyObject?) -> [User]? {
        guard let data = arr as? arrType else { return nil; }
        var result = [User]();
        for el in data {
            guard let p = User.convertFromDict(el) else { continue; }
            result.append(p);
        }
        return result;
    }
    
    static func convertFromDict (dict : AnyObject?) -> User? {
        guard let data = dict as? dictType else { return nil; }
        return User(dict: data);
    }
    
    mutating func set (dict : AnyObject?) {
        self = User.convertFromDict (dict)!;
    }
    
}