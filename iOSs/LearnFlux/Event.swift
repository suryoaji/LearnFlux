//
//  event.swift
//  LearnFlux
//
//  Created by ISA on 7/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

struct keyEventName{
    static let id = "id"
    static let timestamp = "timestamp"
    static let details = "details"
    static let location = "location"
    static let status = "rsvp"
    static let title = "title"
    static let participants = "participants"
    static let by = "created_by"
    static let thread = "thread"
}

class Event {
    typealias EventThread = (id: String, title: String)
    typealias Participant = (user: User, rsvp: Int)
    struct statusEvent{
        static let going = 2
        static let notGoing = -1
        static let interested = 1
        static let none = 0
    }
    
    var title : String!
    var id : String!
    var time : String!
    var by: User!
    var location : String!
    var details : String!
    var participants : [Participant]!
    var thread: EventThread!
    var status: Int! = 0
    
    init(dict: AnyObject?){
        guard let data = dict as? Dictionary<String, AnyObject> else{
            return
        }
        if let s = data[keyEventName.id] as? String{ id = s }
        if let s = data[keyEventName.timestamp] as? Double{ time = String(NSDate(timeIntervalSince1970: s)) }
        if let s = data[keyEventName.details] as? String{ details = s }
        if let s = data[keyEventName.location] as? String{ location = s }
        if let s = data[keyEventName.status] as? Int{ status = s }
        if let s = data[keyEventName.title] as? String { title = s }else{ title = "" }
        update(data)
    }
    
    func update(newInfo: Dictionary<String, AnyObject>){
        if let s = newInfo[keyEventName.title] as? String{ title = s }
        if let s = newInfo[keyEventName.participants] as? Array<Dictionary<String, AnyObject>>{ participants = getParticipantsFromArr(s) }
        if let s = newInfo[keyEventName.by] as? Dictionary<String, AnyObject>{ by = User(dict: s) }
        if let s = newInfo[keyEventName.thread] as? Dictionary<String, AnyObject>{ thread = getThreadFromDict(s) }
        if let s = newInfo[keyEventName.status] as? Int{ status = s }
    }
    
    func selfDescription() -> (String){
        return("title: \(title)\n," +
              "id: \(id)\n," +
              "time: \(time)\n" +
              "by: \(by)\n" +
              "location: \(location)\n" +
              "detail: \(details)\n" +
              "participants: \(participants)\n" +
              "thread: \(thread)\n")
    }
    
    func getThreadFromDict(dict: Dictionary<String, AnyObject>)->(EventThread){
        return (id: dict["id"] as! String, title: dict["title"] as! String)
    }
    
    func getParticipantsFromArr(arr: Array<AnyObject>)->([Participant]){
        return arr.map({ getParticipant($0 as! Dictionary<String, AnyObject>) })
    }
    
    func getParticipant(dict: Dictionary<String, AnyObject>)->(Participant){
        let user = User(dict: dict["user"] as! Dictionary<String, AnyObject>)
        let rsvp = dict["rsvp"] as! Int
        if user.userId! == Engine.clientData.cacheSelfId(){
            status = rsvp
        }
        return (user: user, rsvp: rsvp)
    }
}
