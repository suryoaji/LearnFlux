//
//  JSQMessageCollectionViewCell+Action.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/14/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import JSQMessagesViewController

extension JSQMessagesCollectionViewCell {
    
    override public func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        return (action == #selector(delete(_:)) || action == #selector(copy(_:)));
    }
    
    override public func delete(sender:AnyObject?) {
        // Send Notification To Function DeleteMessageFromNotif in ChatFlow Class
        if let indexpath = getIndexpathIdentifier(){
            NSNotificationCenter.defaultCenter().postNotificationName("LFDeleteMessageNotification", object: self, userInfo: ["indexPath" : Int(indexpath)!])
        }
    }
    
    override public func copy(sender:AnyObject?) {
        super.copy(sender)
        print ("copy")
    }
    
    func setIndexpathIdentifier(rowIndexpath: Int){
        self.accessibilityIdentifier = "\(rowIndexpath)"
    }
    
    func getIndexpathIdentifier()->String?{
        return self.accessibilityIdentifier
    }
    
}

