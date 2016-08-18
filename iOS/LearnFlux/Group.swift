//
//  Group.swift
//  LearnFlux
//
//  Created by ISA on 8/5/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct Group{
    var type: String!
    var id: String!
    var name: String!
    var thread: Thread?
    var tmpIdThread: String?
    
    init(type: String, id: String, name: String, idThread: String? = nil){
        self.type = type
        self.id = id
        self.name = name
        if idThread != nil{
            self.tmpIdThread = idThread
        }
    }
    
    func getIdThread() -> String?{
        return self.tmpIdThread
    }
    
    static func convertFromDict(dict: Dictionary<String, AnyObject>) -> Group?{
        guard let type         = dict["type"] where (type as? String) != nil,
              let id           = dict["id"] where (id as? String) != nil,
              let name         = dict["name"] where (name as? String) != nil else{
                print("=========Error===========")
                print("Group: convertFromDict func cannot make Object Group from Dict :")
                print(dict)
                return nil
        }
        guard let rawMessage = dict["message"] where(rawMessage as? Dictionary<String, AnyObject>) != nil else{
            return Group(type: type as! String, id: id as! String, name: name as! String)
        }
        return Group(type: type as! String, id: id as! String, name: name as! String, idThread: (rawMessage as! Dictionary<String, AnyObject>)["id"] as? String)
    }
    
}
