//
//  ExJSQMessageBubbleImage.swift
//  LearnFlux
//
//  Created by ISA on 8/2/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import JSQMessagesViewController

extension JSQMessagesBubbleImage{
    
    //Normal Outgoing Color = Green
    //Event, Poll Outgoing Color  = Blue
    //Normal Incoming Color = Gray
    //Event, Poll Incoming Color = Blue
    //Important Outgoing and Incoming Color = Red
    
    enum State{
        case NormalSend
        case NormalReceived
        case Normal
        case Event
        case Poll
        case Important
    }
    
    private static func getBubbleColor(state: State) -> UIColor{
        switch state {
        case .Event, .Poll:
            return UIColor.jsq_messageBubbleBlueColor()
        case .Important:
            return UIColor.jsq_messageBubbleRedColor()
        case .NormalSend:
            return UIColor.jsq_messageBubbleGreenColor()
        default:
            return UIColor.jsq_messageBubbleLightGrayColor()
        }
    }
    
    static func outgoingByState(state: State = .NormalSend) -> JSQMessagesBubbleImage{
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(getBubbleColor(state))
    }
    
    static func incomingByState(state: State = .NormalReceived) -> JSQMessagesBubbleImage{
        return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(getBubbleColor(state))
    }
    
    static func fromMessage(threadMessage: Thread.ThreadMessage) -> JSQMessagesBubbleImage{
        let message = threadMessage.message
        let messageMeta = threadMessage.meta
        let selfId = String(Engine.clientData.cacheMe()!["id"] as! Int)
        let typeMessage : State!
        switch (messageMeta["type"]! as! String) {
        case "event":
            typeMessage = .Event
            break
        case "poll":
            typeMessage = .Poll
            break
        case "chat":
            typeMessage = messageMeta["important"]! as! String == "yes" ? .Important : .Normal
            break
        default:
            typeMessage = .Normal
            break
        }
        return message.senderId == selfId ? JSQMessagesBubbleImage.outgoingByState(typeMessage == .Normal ? .NormalSend : typeMessage) : JSQMessagesBubbleImage.incomingByState(typeMessage == .Normal ? .NormalReceived : typeMessage)
    }
}

extension JSQMessagesAvatarImage{
    static func initWithSenderId(id: String = "0") -> JSQMessagesAvatarImage{
        let img = JSQMessagesAvatarImageFactory.circularAvatarImage(UIImage(named: "male07.png"), withDiameter: 48)
        let img2 = JSQMessagesAvatarImageFactory.circularAvatarImage(UIImage(named: "male01.png"), withDiameter: 48)
        let placeholder = UIImage(named: "user_male-24")
        switch id {
        case String(Engine.clientData.cacheMe()!["id"] as! Int):
            return JSQMessagesAvatarImage(avatarImage:img, highlightedImage: img, placeholderImage: placeholder)
        default:
            return JSQMessagesAvatarImage(avatarImage:img2, highlightedImage: img2, placeholderImage: placeholder)
        }
    }
}