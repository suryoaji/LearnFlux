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
        guard let data = arr as? arrType else { return nil }
        return data.reduce([Participant](), combine: { a, b in
            if b[keyCacheMe.id] as! Int == Engine.clientData.cacheSelfId(){
                return a
            }else if a.contains({ $0.user!.userId! == b[keyCacheMe.id] as! Int }){
                return a
            }else{
                return a + [Participant(dict: b)]
            }
        })
    }
    
    static func convertFromDict (dict : AnyObject?) -> Participant? {
        guard let data = dict as? dictType else { return nil; }
        if let user = data["user"] as? dictType, let role = data["role"] as? dictType {
            return Participant (user: User(dict: user), role: Role(dict: role));
        }
        else if let user = User.convertFromDict(data) {
            return Participant (user: user, role: nil);
        }
        else {
            return nil;
        }
    }
    
    mutating func set (dict : AnyObject?) -> Bool {
        guard let result = Participant.convertFromDict (dict) else { return false; }
        self = result;
        return true;
    }
    
}