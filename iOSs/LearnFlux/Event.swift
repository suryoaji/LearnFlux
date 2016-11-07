//
//  event.swift
//  LearnFlux
//
//  Created by ISA on 7/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class Event: NSObject {
    
//    typealias User = (id: String, type: String, link: String)
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
    
    init(id: String, title: String, time: String, details: String, location: String, status: Int) {
        self.title = title
        self.id = id
        self.time = time
//        self.by = (id: "", type: "", link: "")
        self.by = User(userId: 0, type: "", link: "")
        self.location = location
        self.details = details
        self.participants = []
        self.thread = (id: "", title: "")
        self.status = status
    }
    
    convenience init(id: String, time: String, details: String, location: String, status: Int) {
        self.init(id: id, title: "", time: time, details: details, location: location, status: status)
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
    
    func setPropertyBy(by: User){
        self.by = by
    }
    
    func setPropertyLocation(string: String){
        self.location = string
    }
    
    func setPropertyDetails(string: String){
        self.details = string
    }
    
    func setPropertyParticipants(arrParticipant: [Participant]){
        self.participants = arrParticipant
    }
    
    func setPropertyThread(thread: EventThread){
        self.thread = thread
    }
    
    func setPropertyStatus(status: Int){
        self.status = status
    }
    
    func updateMe(newInfo: Dictionary<String, AnyObject>){
        guard let rawTitle        = newInfo["title"],
              let rawParticipants = newInfo["participants"],
              let rawBy           = newInfo["created_by"],
              let rawThread       = newInfo["thread"],
              let status          = newInfo["rsvp"] else{
                return
        }
        guard let sTitle          = rawTitle as? String,
              let arrParticipants = rawParticipants as? Array<AnyObject>,
              let dictBy          = rawBy as? Dictionary<String, AnyObject>,
              let dictThread      = rawThread as? Dictionary<String, AnyObject>,
              let iStatus         = status as? Int else{
                return
        }
        self.setPropertyParticipants(getParticipantsFromArr(arrParticipants))
        self.setPropertyThread(getThreadFromDict(dictThread))
        self.setPropertyBy(getByFromDict(dictBy))
        self.title = sTitle
        self.status = iStatus
    }
    
    func getByFromDict(dict: Dictionary<String, AnyObject>)->(User){
        return User(userId: dict["id"] as? Int, type: dict["type"] as? String, link: dict["link"] as? String)
    }
    
    func getThreadFromDict(dict: Dictionary<String, AnyObject>)->(EventThread){
        return (id: dict["id"] as! String, title: dict["title"] as! String)
    }
    
    func getParticipantsFromArr(arr: Array<AnyObject>)->([Participant]){
        var arrParticipant = [Participant]()
        for each in arr{
            let dictEach = each as! Dictionary<String, AnyObject>
            arrParticipant.append(getParticipant(dictEach))
        }
        return arrParticipant
    }
    
    func getParticipant(dict: Dictionary<String, AnyObject>)->(Participant){
        let user = getUser(dict["user"] as! Dictionary<String, AnyObject>)
        let rsvp = dict["rsvp"] as! Int
        if user.userId! == Engine.clientData.cacheSelfId(){
            self.setPropertyStatus(rsvp)
        }
        return (user: user, rsvp: rsvp)
    }
    
    func getUser(dict: Dictionary<String, AnyObject>) -> (User){
        return User(userId: dict["id"] as? Int, type: String(dict["type"]!), link: String(dict["link"]!))
    }
    
    static func convertToEvent(dict: Dictionary<String, AnyObject>) -> (Event?){
        guard let id = dict["id"],
              let timestamp = dict["timestamp"],
              let details = dict["details"],
              let location = dict["location"],
              let status = dict["rsvp"] else{
              return nil
        }
        guard let sId        = id as? String,
              let dTimestamp = timestamp as? Double,
              let sDetails   = details as? String,
              let sLocation  = location as? String,
              let iStatus = status as? Int else{
                return nil
        }
        let date = NSDate(timeIntervalSince1970: dTimestamp)
        let returnedEvent : Event!
        if let title = dict["title"] where (title as? String) != nil{
             returnedEvent = Event(id: sId, title: title as! String, time: String(date), details: sDetails, location: sLocation, status: iStatus)
        }else{
             returnedEvent = Event(id: sId, time: String(date), details: sDetails, location: sLocation, status: iStatus)
        }
        returnedEvent.updateMe(dict)
        
        return returnedEvent
    }
    
}
