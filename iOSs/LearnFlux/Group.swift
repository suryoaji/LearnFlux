//
//  Group.swift
//  LearnFlux
//
//  Created by ISA on 8/5/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

struct keyGroupName{
    static let type = "type"
    static let id = "id"
    static let name = "name"
    static let parent = "parent"
    static let description = "description"
    static let message = "message"
    static let participants = "participants"
    static let child = "child"
    static let image = "image"
    static let role = "access"
}

class Group{
    var type: String!
    var id: String!
    var name: String!
    var thread: Thread?
    var parent: Any?
    var parentId: String!
    var color: UIColor!;
    var participants : [Participant]?;
    var description : String?;
    var child : [Group]?;
    var imageString: String?
    var image: UIImage?
    var role: String?
    
    init(dict: AnyObject?, imageHasLoaded: ((type: Int, id: String, status: Bool) -> Void)? = nil) {
        guard let data = dict as? dictType else { type = ""; id = ""; name = ""; return }
        if let s = data[keyGroupName.type] as? String { type = s; }
        if let s = data[keyGroupName.id] as? String { id = s; }
        if let s = data[keyGroupName.name] as? String { name = s; }
        if let s = data[keyGroupName.parent] as? dictType { let p = Group(dict: s); parent = p as Any; parentId = p.id; }
        if let s = data[keyGroupName.description] as? String { description = s; }
        
        if let s = data[keyGroupName.message] as? dictType { thread = Thread(dict: s); participants = thread?.participants}
        
        if let s = data[keyGroupName.participants] as? Array<dictType> { participants = Participant.convertFromArr(s) }
        if let s = data[keyGroupName.child] { child = Group.convertFromArr(s); }
        if let s = data[keyGroupName.image] as? String { imageString = s; loadImage(imageHasLoaded) }
        if let s = data[keyGroupName.role] as? String { role = s }
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
