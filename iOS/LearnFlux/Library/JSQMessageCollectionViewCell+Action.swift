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
        print ("delete")
    }
    
    override public func copy(sender:AnyObject?) {
        super.copy(sender)
        print ("copy")
    }
}

