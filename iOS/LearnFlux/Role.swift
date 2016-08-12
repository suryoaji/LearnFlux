//
//  Role.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/10/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct Role {
    
    var type : String!;
    var name : String!;
    
    init () { }
    
    init (type: String?, name: String?) {
        self.type = type;
        self.name = name;
    }
    
    init (dict : AnyObject?)  {
        guard let data = dict as? dictType else { return; }
        self.type = data["type"] as? String;
        self.name = data["name"] as? String;
    }
    
    static func convertFromArr (arr : AnyObject?) -> [Role]? {
        guard let data = arr as? arrType else { return nil; }
        var result = [Role]();
        for el in data {
            guard let p = Role.convertFromDict(el) else { continue; }
            result.append(p);
        }
        return result;
    }
    
    static func convertFromDict (dict : AnyObject?) -> Role? {
        guard let data = dict as? dictType else { return nil; }
        return Role (dict: data);
    }
    
    mutating func set (dict : AnyObject?) -> Bool {
        guard let result = Role.convertFromDict (dict) else { return false; }
        self = result;
        return true;
        
    }

    
}