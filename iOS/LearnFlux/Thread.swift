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
    var participants : [Int]!
    var messages: [ThreadMessage]?
    
    init(id: String, participants: [Int]) {
        self.id = id
        self.participants = participants
    }
    
    init(dict: Dictionary<String, AnyObject>) {
        super.init()
        self.id = dict["id"] as! String
        self.participants = setPropertyParticipants(dict["participants"] as! Array<Dictionary<String, AnyObject>>)
        if let rawMessages = dict["messages"]{
            self.setPropertyMessages(rawMessages as! Array<Dictionary<String, AnyObject>>)
        }
    }
    
    func setPropertyParticipants(arr: Array<Dictionary<String, AnyObject>>)-> ([Int]){
        var conId : [Int] = []
        for i in arr{
            conId.append(i["id"] as! Int)
        }
        return conId
    }
    
    func addMessage(message: ThreadMessage){
        self.messages?.append(message)
    }
    
    func setPropertyMessages(messages: Array<Dictionary<String, AnyObject>>){
        var conMessages : [ThreadMessage] = []
        for eachDict in messages{
            if let message = self.setMessage(eachDict){
                conMessages.append(message)
            }
        }
        self.messages = conMessages
    }
    
    func setMessage(dicMessage: Dictionary<String, AnyObject>)-> (ThreadMessage)?{
        if let tSender = dicMessage["sender"], let tRawDate = dicMessage["created_at"], let tText = dicMessage["body"]{
            let senderMessage = tSender as! Dictionary<String, AnyObject>
            let senderId = String(senderMessage["id"] as! Int)
            let rawDate = tRawDate as! Double
            let date = NSDate(timeIntervalSince1970: rawDate)
            let text = tText as! String
            let message = JSQMessage(senderId: senderId, senderDisplayName: "(need to be maintained)", date: date, text: text)
            let meta = self.setMetaMessage(dicMessage)
            return (message: message, meta: meta)
        }
        return nil
    }
    
    func setMetaMessage(dicMessage: Dictionary<String, AnyObject>)-> Dictionary<String, AnyObject>{
        let text = dicMessage["body"] as! String
        return ["type":"chat", "data":text, "important": "no"]
    }
}
