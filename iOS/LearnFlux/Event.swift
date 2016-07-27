//
//  event.swift
//  LearnFlux
//
//  Created by ISA on 7/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    typealias User = (id: String, type: String, link: String)
    
    var type : String!
    var id : String!
    var time : String!
    var by: User!
    var location : String!
    var details : String!
    var participants : [User]!
    
    init(type: String, id: String, time: String, eventBy: User?) {
        self.type = type
        self.id = id
        self.time = time
        self.by = (id: "", type: "", link: "")
        if let n = eventBy{
            self.by = (id: n.id, type: n.type, link: n.link)
        }
        self.location = ""
        self.details = ""
        self.participants = []
    }
    
    func setPropertyBy(id: String, type: String, link: String){
        self.by = (id: id, type: type, link: link)
    }
    
    func setPropertyLocation(string: String){
        self.location = string
    }
    
    func setPropertyDetails(string: String){
        self.details = string
    }
    
    func setPropertyParticipants(arrParticipant: [User]){
        self.participants = arrParticipant
    }
    
}
