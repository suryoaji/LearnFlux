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
    var parent: Any?
    var parentId: String!
    var threadId: String?
    var color: UIColor!;
    var participants : [Participant]?;
    var description : String?;
    var child : [Group]?;
    
    init(type: String, id: String, name: String, threadId: String? = nil, parentId: String! = ""){
        self.type = type
        self.id = id
        self.name = name
        self.parentId = parentId
        if threadId != nil{
            self.threadId = threadId
        }
    }
    
    init(type: String, id: String, name: String, thread: Thread, parent: AnyObject? = nil) {
        self.type = type
        self.id = id
        self.name = name;
        self.parent = parent;
        if let p = parent as? Group {
            self.parentId = p.id;
        }
        self.thread = thread;
        self.threadId = self.thread?.id;
    }
    
    init(dict: AnyObject?) {
        guard let data = dict as? dictType else { return; }
        print (data);
        if let s = data["type"] as? String { type = s; }
        if let s = data["id"] as? String { id = s; }
        if let s = data["name"] as? String { name = s; }
        if let s = data["parent"] as? dictType { let p = Group(dict: s); parent = p as Any; parentId = p.id; }
        if let s = data["description"] as? String { description = s; }
        
        if let s = data["message"] as? dictType { thread = Thread(dict: s); participants = thread?.participants; }
        
        if let s = data["participants"] as? String { participants = Participant.convertFromArr(s); }
        if let s = data["child"] { child = Group.convertFromArr(s); }
    }
    
    func getIdThread() -> String?{
        return self.threadId
    }
    
    static func convertFromArr(dict: AnyObject?) -> [Group]? {
        guard let data = dict as? arrType else { return nil; }
        var result = [Group]();
        for el in data {
            guard let group = Group.convertFromDict(el) else { continue; }
            result.append(group);
        }
        return result;
    }
    
    static func convertFromDict(dict: AnyObject?) -> Group?{
        guard let data = dict as? dictType else { return nil; }
        return Group(dict: data);
//        guard let type       = data["type"] where (type as? String) != nil,
//            let id           = data["id"] where (id as? String) != nil,
//            let name         = data["name"] where (name as? String) != nil else{
//                print("=========Error===========")
//                print("Group: convertFromDict func cannot make Object Group from Dict :")
//                print(data)
//                return nil
//        }
//        guard let rawMessage = data["message"] where(rawMessage as? Dictionary<String, AnyObject>) != nil else{
//            return Group(type: type as! String, id: id as! String, name: name as! String)
//        }
//        return Group(type: type as! String, id: id as! String, name: name as! String, threadId: (rawMessage as! Dictionary<String, AnyObject>)["id"] as? String)
    }
    
    mutating func set (dict: AnyObject?) {
        guard let data = dict as? dictType else { return; }
        guard let result = Group.convertFromDict (data) else { return; }
        self = result;
    }
    
}
