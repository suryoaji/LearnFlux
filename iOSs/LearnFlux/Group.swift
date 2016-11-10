//
//  Group.swift
//  LearnFlux
//
//  Created by ISA on 8/5/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Group{
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
    var imageString: String?
    var image: UIImage?
    
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
    
    init(dict: AnyObject?, imageHasLoaded: ((type: Int, id: String, status: Bool) -> Void)? = nil) {
        guard let data = dict as? dictType else { return; }
        if let s = data["type"] as? String { type = s; }
        if let s = data["id"] as? String { id = s; }
        if let s = data["name"] as? String { name = s; }
        if let s = data["parent"] as? dictType { let p = Group(dict: s); parent = p as Any; parentId = p.id; }
        if let s = data["description"] as? String { description = s; }
        
        if let s = data["message"] as? dictType { thread = Thread(dict: s); participants = thread?.participants; threadId = thread?.id }
        
        if let s = data["participants"] as? Array<dictType> { participants = Participant.convertFromArr(s) }
        if let s = data["child"] { child = Group.convertFromArr(s); }
        if let s = data["image"] as? String { imageString = s; loadImage(imageHasLoaded) }
    }
    
    func loadImage(callback: ((type: Int, id: String, status: Bool) -> Void)?){
        if self.imageString != nil && !self.imageString!.isEmpty{
            Engine.getImageGroup(group: self){ image in
                self.image = image
                self.imageString = nil
                if image != nil{
                    if callback != nil { callback!(type: 2, id: "\(self.id)", status: true) }
                }else{
                    if callback != nil { callback!(type: 2, id: "\(self.id)", status: false) }
                }
            }
        }
    }
    
    func update(group: Group){
        self.color = self.color == nil ? group.color : self.color
        self.description = self.description == nil ? group.description : self.description
        self.participants = group.participants
        self.child = group.child
        self.thread = group.thread
        self.threadId = group.thread?.id
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
    }
    
}
