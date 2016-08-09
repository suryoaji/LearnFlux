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
    
    init(type: String, id: String, name: String, thread: Thread) {
        self.type = type
        self.id = id
        self.name = name;
        self.thread = thread;
        self.tmpIdThread = self.thread?.id;
    }
    
    func getIdThread() -> String?{
        return self.tmpIdThread
    }
}
