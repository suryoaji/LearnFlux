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
    typealias EventThread = (id: String, title: String)
    typealias Participant = (user: User, rsvp: Int)
    
    var title : String!
    var id : String!
    var time : String!
    var by: User!
    var location : String!
    var details : String!
    var participants : [Participant]!
    var thread: EventThread!
    
    init(id: String, time: String, details: String, location: String) {
        self.title = ""
        self.id = id
        self.time = time
        self.by = (id: "", type: "", link: "")
        self.location = location
        self.details = details
        self.participants = []
        self.thread = (id: "", title: "")
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
    
    func updateMe(newInfo: Dictionary<String, AnyObject>){
        if let rawTitle = newInfo["title"], let rawParticipants = newInfo["participants"], let rawBy = newInfo["created_by"], let rawThread = newInfo["thread"]{
            if let sTitle = rawTitle as? String, let arrParticipants = rawParticipants as? Array<AnyObject>, dictBy = rawBy as? Dictionary<String, AnyObject>, let dictThread = rawThread as? Dictionary<String, AnyObject>{
                self.setPropertyParticipants(getParticipantsFromArr(arrParticipants))
                self.setPropertyThread(getThreadFromDict(dictThread))
                self.setPropertyBy(getByFromDict(dictBy))
                self.title = sTitle
            }
        }
    }
    
    func getByFromDict(dict: Dictionary<String, AnyObject>)->(User){
        return (id: String(dict["id"] as! Int), type: dict["type"] as! String, link: dict["link"] as! String)
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
        return (user: getUser(dict["user"] as! Dictionary<String, AnyObject>), rsvp: dict["rsvp"] as! Int)
    }
    
    func getUser(dict: Dictionary<String, AnyObject>) -> (User){
        return (id: String(dict["id"] as! Int), type: String(dict["type"]!), link: String(dict["link"]!))
    }
    
    static func convertToEvent(dict: Dictionary<String, AnyObject>) -> (Event?){
        if let id = dict["id"], let timestamp = dict["timestamp"], let details = dict["details"], let location = dict["location"]{
            if let sId = id as? String, let dTimestamp = timestamp as? Double, let sDetails = details as? String, let sLocation = location as? String{
                let date = NSDate(timeIntervalSince1970: dTimestamp)
                return Event(id: sId, time: String(date), details: sDetails, location: sLocation)
            }
        }
        return nil
    }
    
}
