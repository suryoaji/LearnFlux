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
    typealias secret = (type: Bool, idType: String?, id: String)
    typealias ThreadMessage = (message: JSQMessage, meta: Dictionary<String, AnyObject>, secret: secret?)
    
    var id : String!
    var title : String?
    var messages: [ThreadMessage]?{
        didSet{
            if messages != nil{
                self.lastUpdated = messages![messages!.count-1].message.date.timeIntervalSince1970
                NSNotificationCenter.defaultCenter().postNotificationName("sortThreads", object: nil)
            }
        }
    }
    var participants : [Participant]!
    
    init(id: String, participants: [Participant]) {
        self.id = id
        self.participants = participants
    }
    var lastUpdated: Double!
    var normalIndex: Int!
    
    init(dict: Dictionary<String, AnyObject>, isNew: Bool = false, index: Int? = nil) {
        super.init()
        self.id = dict["id"] as! String
        self.participants = Participant.convertFromArr(dict["participants"]); //setPropertyParticipants(dict["participants"] as! Array<Dictionary<String, AnyObject>>)
        if let title = dict["title"]{
            self.title = title as? String
        }
        if isNew{
            self.setPropertyLastUpdated(NSDate().timeIntervalSince1970)
            self.normalIndex = Engine.clientData.getMyThreads()!.count
        }else{
            self.setPropertyLastUpdated(0)
            if index != nil{ self.normalIndex = index! }
        }
        if let rawMessages = dict["messages"]{
            self.setPropertyMessages(rawMessages as! Array<Dictionary<String, AnyObject>>)
        }
    }
    
    func setPropertyLastUpdated(timestamp: Double){
        self.lastUpdated = timestamp
    }
    
    func setPropertyLastUpdated(arrMessage: [ThreadMessage]){
        if !arrMessage.isEmpty{
            self.setPropertyLastUpdated(arrMessage[arrMessage.count-1].message.date.timeIntervalSince1970)
        }else{
            self.setPropertyLastUpdated(0)
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
        return Thread.convertDictToMessage(dicMessage)
    }
    
    static func getMessagesFromArr(arr: Array<Dictionary<String, AnyObject>>)-> [ThreadMessage]?{
        var arrMessages : [ThreadMessage] = []
        for dicMessage in arr{
            guard let message = convertDictToMessage(dicMessage) else{
                print("\nThread: getMessageFromArr, failure when converting dict to message. Dict: ")
                print(dicMessage)
                continue
            }
            arrMessages.append(message)
        }
        return !arrMessages.isEmpty ? arrMessages : nil
    }
    
    private static func convertDictToMessage(dict: Dictionary<String, AnyObject>) -> (ThreadMessage)?{
        guard let tSender  = dict["sender"] where (tSender as? Dictionary<String, AnyObject>) != nil,
            let tRawDate   = dict["created_at"] where (tRawDate as? Double) != nil,
            let tText      = dict["body"] where (tText as? String) != nil,
            let tId        = dict["id"] where (tId as? String) != nil else{
                return nil
        }
        let senderMessage = tSender as! Dictionary<String, AnyObject>
        let rawDate = tRawDate as! Double
        let message = setJSQMessage(String(senderMessage["id"] as! Int),
                                           text     : tText as! String,
                                           reference: dict["reference"],
                                           date     : NSDate(timeIntervalSince1970: rawDate))
        let meta = setMetaMessage(dict["reference"], text: tText as! String)
        let secret = setSecretMessage(tId as! String, reference: dict["reference"])
        return (message: message, meta: meta, secret: secret)
    }
    
    static func setSecretMessage(idMessage: String, reference: AnyObject?) -> secret{
        guard let reference = reference else{
            return (type: false, idType: nil, id: idMessage)
        }
        return (type: false, idType: reference["id"] as? String, id: idMessage)
    }
    
    static func setJSQMessage(senderId: String,text: String, reference: AnyObject?, date: NSDate) -> (JSQMessage){
        if let rawReference = reference{
            return JSQMessage(senderId: senderId, senderDisplayName: "(need to be maintained)", date: date, text: textFromRef(rawReference as! Dictionary<String, AnyObject>))
        }
        return JSQMessage(senderId: senderId, senderDisplayName: "(need to be maintained)", date: date, text: text)
    }
    
    static func setMetaMessage(reference: AnyObject?, text: String)-> (Dictionary<String, AnyObject>){
        if let rawReference = reference{
            return metaFromRef(rawReference as! Dictionary<String, AnyObject>)
        }
        return ["type":"chat", "data":text, "important": "no"]
    }
    
    static func textFromRef(ref: Dictionary<String, AnyObject>) -> (String){
        if (ref["type"] as! String).lowercaseString == "event"{
            let title = ref["title"] as! String
            let rawDate = Util.getDateFromTimestamp(ref["timestamp"] as! Double)
            let date = rawDate.date
            return "📅 \(date.uppercaseString) EVENT\n\nJack Joyce send \(title) invitation. Tap here to interact.\n"
        }else{
            let title = ref["title"] as! String
            return "📊 POLL\n\nJack Joyce send \(title) poll. Tap here to interact.\n"
        }
    }
    
    static func metaFromRef(ref: Dictionary<String, AnyObject>) -> (Dictionary<String, AnyObject>){
        var dict : Dictionary<String, AnyObject> = [:]
        let type = ref["type"] as! String
        if type.lowercaseString == "event"{
            setMetaForEvent(&dict, ref: ref)
        }else{
            setMetaForPoll(&dict, ref: ref)
        }
        return ["type": type, "data":dict, "important": "no"]
    }
    
    static func setMetaForEvent(inout meta: Dictionary<String, AnyObject>, ref: Dictionary<String, AnyObject>){
        meta["title"] = ref["title"] as! String
        meta["details"] = ref["details"] as! String
        meta["location"] = ref["location"] as! String
        meta["duration"] = "120"
        let rawDate = Util.getDateFromTimestamp(ref["timestamp"] as! Double)
        meta["date"] = rawDate.date
        meta["time"] = rawDate.time
    }
    
    static func setMetaForPoll(inout meta: Dictionary<String, AnyObject>, ref: Dictionary<String, AnyObject>){
        meta["title"] = ref["title"] as! String
        meta["question"] = ref["question"] as! String
        let answers = pollsAnswerFromArr(ref["options"] as! Array<Dictionary<String, AnyObject>>)
        meta["answers"] = answers
        meta["answerers"] = pollsAnswererFromArr(ref["metadata"] as! Array<Dictionary<String, AnyObject>>, answers: answers)
        meta["id"] = ref["id"] as! String
    }
    
    static func pollsAnswererFromArr(arr: Array<Dictionary<String, AnyObject>>, answers: Array<String>) -> (Dictionary<String, Int>){
        var conAnswerer : Dictionary<String, Int>= [:]
        if !arr.isEmpty{
            arrLoop : for each in arr{
                let userId = String((each["user"] as! Dictionary<String, AnyObject>)["id"] as! Int)
                for i in conAnswerer{
                    if i.0 == userId { continue arrLoop }
                }
                if let position = positionAnswer(each["name"] as! String, answers: answers){
                    conAnswerer[userId] = position
                }
            }
        }
        return conAnswerer
    }
    
    static func positionAnswer(answer: String, answers: Array<String>) -> Int?{
        for i in 0..<answers.count{
            if answers[i] == answer{
                return i
            }
        }
        return nil
    }
    
    static func pollsAnswerFromArr(arr: Array<Dictionary<String, AnyObject>>) -> (Array<String>){
        var conAnswer : Array<String> = []
        for each in arr{
            conAnswer.append(each["name"] as! String)
        }
        return conAnswer
    }
    
    static func textPollsFromArr(arr: Array<String>)->(String){
        var text = ""
        for each in 1...arr.count{
            text += "\(each). \(arr[each - 1])\n"
        }
        return text
    }
}
