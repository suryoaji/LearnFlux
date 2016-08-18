//
//  Thread.swift
//  LearnFlux
//
//  Created by ISA on 7/27/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class Thread: NSObject {
    typealias ThreadMessage = (message: JSQMessage, meta: Dictionary<String, AnyObject>)
    
    var id : String!
    var title : String?
    var participants : [Participant]!
    var messages: [ThreadMessage]?
    
    init(id: String, participants: [Participant]) {
        self.id = id
        self.participants = participants
    }
    
    init(dict: Dictionary<String, AnyObject>) {
        super.init()
        self.id = dict["id"] as! String
        self.participants = Participant.convertFromArr(dict["participants"]); //setPropertyParticipants(dict["participants"] as! Array<Dictionary<String, AnyObject>>)
        if let title = dict["title"]{
            self.title = title as? String
        }
        if let rawMessages = dict["messages"]{
            self.setPropertyMessages(rawMessages as! Array<Dictionary<String, AnyObject>>)
        }
    }
    
    func setPropertyTitle(title: String){
        self.title = title
    }
    
//    func setPropertyParticipants(arr: Array<Dictionary<String, AnyObject>>)-> ([Int]){
//        var conId : [Int] = []
//        for i in arr{
//            conId.append(i["id"] as! Int)
//        }
//        return conId
//    }
    
    func addMessage(message: ThreadMessage){
        if self.messages != nil{
            self.messages!.append(message)
        }else{
            self.messages = [message]
        }
    }
    
    func addMessages(messages: [ThreadMessage]){
        if self.messages != nil{
            self.messages! += messages
        }else{
            self.messages = messages
        }
    }
    
    func setPropertyMessages(messages: Array<Dictionary<String, AnyObject>>){
        var conMessages : [ThreadMessage] = []
        for eachDict in messages{
            if let message = self.setThreadMessage(eachDict){
                conMessages.append(message)
            }
        }
        self.messages = conMessages
    }
    
    func setThreadMessage(dicMessage: Dictionary<String, AnyObject>)-> (ThreadMessage)?{
        if let tSender = dicMessage["sender"], let tRawDate = dicMessage["created_at"], let tText = dicMessage["body"]{
            let senderMessage = tSender as! Dictionary<String, AnyObject>
            let senderId = String(senderMessage["id"] as! Int)
            let rawDate = tRawDate as! Double
            let date = NSDate(timeIntervalSince1970: rawDate)
            let text = tText as! String
            let message = setJSQMessage(senderId, text: text, reference: dicMessage["reference"], date: date)
            let meta = self.setMetaMessage(dicMessage["reference"], text: text)
            return (message: message, meta: meta)
        }
        return nil
    }
    
    func setJSQMessage(senderId: String,text: String, reference: AnyObject?, date: NSDate) -> (JSQMessage){
        if let rawReference = reference{
            return JSQMessage(senderId: senderId, senderDisplayName: "(need to be maintained)", date: date, text: textFromRef(rawReference as! Dictionary<String, AnyObject>))
        }
        return JSQMessage(senderId: senderId, senderDisplayName: "(need to be maintained)", date: date, text: text)
    }
    
    func setMetaMessage(reference: AnyObject?, text: String)-> (Dictionary<String, AnyObject>){
        if let rawReference = reference{
            return metaFromRef(rawReference as! Dictionary<String, AnyObject>)
        }
        return ["type":"chat", "data":text, "important": "no"]
    }
    
    func textFromRef(ref: Dictionary<String, AnyObject>) -> (String){
        let detail = ref["details"] as! String
        let title = ref["title"] as! String
        let rawDate = Util.getDateFromTimestamp(ref["timestamp"] as! Double)
        let date = rawDate.date
        let time = rawDate.time
        let location = ref["location"] as! String
        return "📅 EVENT\n\n\(detail). Tap here to interact.\n\n" +
               "\(title)\n" +
               "\(date)\n" +
               "\(time)\n" +
               "\(location)"
    }
    
    func metaFromRef(ref: Dictionary<String, AnyObject>) -> (Dictionary<String, AnyObject>){
        var dict : Dictionary<String, AnyObject> = [:]
        let type = ref["type"] as! String
        dict["location"] = ref["location"] as! String
        dict["title"] = ref["title"] as! String
        dict["duration"] = "120"
        let rawDate = Util.getDateFromTimestamp(ref["timestamp"] as! Double)
        dict["date"] = rawDate.date
        dict["time"] = rawDate.time
        return ["type": type, "data":dict, "important": "no"]
    }
    
    static func getMessagesFromArr(arr: Array<Dictionary<String, AnyObject>>)-> [ThreadMessage]?{
        var arrMessages : [ThreadMessage] = []
        for message in arr{
            if let text = message["body"], let timestamp = message["created_at"], let sender = message["sender"]{
                if let sText = text as? String, let dTimestamp = timestamp as? Double, let dSender = sender as? Dictionary<String, AnyObject>{
                    let message = JSQMessage(senderId: String(dSender["id"] as! Int), senderDisplayName: "(need to be maintained)", date: NSDate(timeIntervalSince1970: dTimestamp), text: sText)
                    let messageMeta = ["data" : sText, "important" : "no", "type" : "chat"]
                    arrMessages.append((message: message, meta: messageMeta))
                }
            }
        }
        if !arrMessages.isEmpty{
            return arrMessages
        }
        return nil
    }
}
