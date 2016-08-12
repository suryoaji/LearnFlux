//
//  Participant.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 8/10/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct Participant {
    
    var user : User?;
    var role : Role?;
    
    init () { }
    
    init (user: User?, role: Role?) {
        if let s = user { self.user = s };
        if let s = role { self.role = s };
    }
    
    init (dict : AnyObject?)  {
        guard let data = Participant.convertFromDict(dict) else { return; }
        user = data.user;
        role = data.role;
    }

    static func convertFromArr (arr : AnyObject?) -> [Participant]? {
        guard let data = arr as? arrType else { return nil; }
        var result = [Participant]();
        for el in data {
            guard let p = Participant.convertFromDict(el) else { continue; }
            result.append(p);
        }
        return result;
    }
    
    static func convertFromDict (dict : AnyObject?) -> Participant? {
        guard let data = dict as? dictType else { return nil; }
        return Participant (user: User(dict: data["user"]), role: Role(dict: data["role"]));
    }
    
    mutating func set (dict : AnyObject?) -> Bool {
        guard let result = Participant.convertFromDict (dict) else { return false; }
        self = result;
        return true;
    }
    
    
}