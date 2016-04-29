//
//  ChatFlow.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import JSQMessagesViewController
//import JSMessageBubbleImage

class ChatFlow : JSQMessagesViewController, AttachEventReturnDelegate, AttachPollReturnDelegate {
    // MARK: Properties
    let aDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    var messages = [JSQMessage]()
    var messagesMeta = [NSDictionary]()
    var outgoingBubbleImageView,
    outgoingBubbleImageViewEvent,
    outgoingBubbleImageViewPoll,
    incomingBubbleImageView,
    incomingBubbleImageViewEvent,
    incomingBubbleImageViewPoll: JSQMessagesBubbleImage!
    var attachmentPanelOld : UIView!;
    @IBOutlet var attachmentPanel : UIView!;
    var avatars : NSMutableDictionary!;
    let scrHeight = UIScreen.mainScreen().bounds.height;
    let scrWidth = UIScreen.mainScreen().bounds.width;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ChatChat"
        setupBubbles()
        let img = UIImage(named: "male07.png");
        let aimg = JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter:48);
        let img2 = UIImage(named: "male01.png");
        let aimg2 = JSQMessagesAvatarImageFactory.circularAvatarImage(img2, withDiameter:48);
        let placeholder = UIImage(named: "user_male-24");
        avatars = NSMutableDictionary();
        avatars.setValue(JSQMessagesAvatarImage(avatarImage:aimg, highlightedImage: aimg, placeholderImage: placeholder), forKey: aDelegate.userId);
        avatars.setValue(JSQMessagesAvatarImage(avatarImage:aimg2, highlightedImage: aimg2, placeholderImage: placeholder), forKey: "2");
//        attachmentPanel = UIView();
        self.initAttachmentPanel();
        attachmentPanel.y = scrHeight;
        self.view.addSubview(attachmentPanel);
        
        addMessage(aDelegate.userId, text: "Hello");
        addMessage("2", text: "Ya?\nYayaya!");
        finishSendingMessage();

//        let attachment = UIButton(type: .System);
//        attachment.setImage(UIImage(named: "clip-18"), forState: UIControlState.Normal);
//        self.inputToolbar.contentView.leftBarButtonItem = attachment;
//        // No avatars
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        finishSendingMessage();
//        self.view.bringSubviewToFront(self.view.inputView!);
    }
    
    override func viewDidLayoutSubviews() {
        setTabBarVisible(false, animated: true)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func initAttachmentPanel() {
        let container = attachmentPanel;
        let btnEvent = container.viewWithTag(1) as! UIButton;
        let btnPoll = container.viewWithTag(2) as! UIButton
        let spacing:CGFloat = 10;
        btnEvent.frame = CGRectMake(spacing, spacing, (scrWidth - spacing) / 2 - spacing, 44);
        btnPoll.frame = CGRectMake((scrWidth + spacing) / 2, spacing, (scrWidth - spacing) / 2 - spacing, 44);
        container.height = spacing * 2 + btnEvent.height;
        container.y = scrHeight;
    }
    
    func initAttachmentPanelOld() {
        let container = attachmentPanel;
        var containerHeight:CGFloat = 200;
        container.x = 0;
        container.y = scrHeight - 200;
        container.height = 200 - 43;
        container.width = scrWidth;
        container.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1);
        self.view.addSubview(container);
        
        let spacing:CGFloat = 10;
        
        let btnEvent = UIButton(type: UIButtonType.System);
        let btnPoll = UIButton(type: UIButtonType.System);
        //        let btnPicture = UIButton();
        //        let btnVideo = UIButton();
        //        let btnFiles = UIButton();
        
        btnEvent.frame = CGRectMake(spacing, spacing, (scrWidth - spacing) / 2 - spacing, 44);
        btnPoll.frame = CGRectMake((scrWidth + spacing) / 2, spacing, (scrWidth - spacing) / 2 - spacing, 44);
        
        
        btnEvent.setTitle(" Event", forState: .Normal);
        btnPoll.setTitle(" Poll", forState: .Normal);
        
        btnEvent.setImage(UIImage(named: "calendar-24"), forState: .Normal);
        btnPoll.setImage(UIImage(named: "line_chart-24"), forState: .Normal);
        
        btnEvent.titleLabel!.font = UIFont(name: "System", size: 18);
        btnPoll.titleLabel!.font = UIFont(name: "System", size: 18);
        
        btnEvent.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1);
        btnPoll.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1);
        
        btnEvent.tag = 1;
        btnPoll.tag = 2;
        
        btnEvent.addTarget(self, action: #selector (attachmentClick), forControlEvents: .TouchUpInside);
        btnPoll.addTarget(self, action: #selector (attachmentClick), forControlEvents: .TouchUpInside);
        
        container.addSubview(btnEvent);
        container.addSubview(btnPoll);
        
        containerHeight = spacing * 2 + btnEvent.height;
        container.height = containerHeight;
        container.y = scrHeight - containerHeight - 43;
        
        container.y = scrHeight;
    }
    
    func isAttachmentPanelVisible () -> Bool {
//        print ("\(attachmentPanel.x), \(attachmentPanel.y), \(attachmentPanel.width), \(attachmentPanel.height)");
        return attachmentPanel.y < scrHeight;
    }
    
    func setAttachmentPanelVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (isAttachmentPanelVisible() == visible) { return }
        
        
        // get a frame calculation ready
        let frame = attachmentPanel.frame
        let height = frame.size.height + 43
        let offsetY = (visible ? -height : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        UIView.animateWithDuration(duration) {
            self.attachmentPanel.frame = CGRectOffset(frame, 0, offsetY)
            return
        }
        
        self.inputToolbar.contentView.inputView?.resignFirstResponder();
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.bubbleTap))
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    
    @IBAction func bubbleTap (sender: AnyObject) {
        print ("BUBBLE TAP ----------");
        let tap = sender as! UITapGestureRecognizer;
        let indexPath = self.collectionView.indexPathForCell(tap.view as! JSQMessagesCollectionViewCell)!;
        let messageMeta = messagesMeta[indexPath.row];
        let eventType = messageMeta.valueForKey("type") as! String;
        
        if (eventType == "event") {
            let event = messagesMeta[indexPath.row].valueForKey("data") as! AttachedEvent;
            
            if (messages[indexPath.row].senderId == aDelegate.userId) {
//                Util.showMessageInViewController(self, title: "You've sent this event to this group. Anyone who tap on this bubble can give response.", message: event.title, completion: nil);

                let alert: UIAlertController = UIAlertController(title: event.title, message: "Your response to this event invitation:", preferredStyle: .ActionSheet)
                
                let act1: UIAlertAction = UIAlertAction(title:"I will attend this event", style: .Default, handler: {(action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(act1)
                let act2: UIAlertAction = UIAlertAction(title:"I will not attend this event", style: .Default, handler: {(action: UIAlertAction) -> Void in

                })
                alert.addAction(act2)
                let act3: UIAlertAction = UIAlertAction(title:"View event details and chat", style: .Cancel, handler: {(action: UIAlertAction) -> Void in

                })
                alert.addAction(act3)
                let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else if (eventType == "poll") {
            let poll = messagesMeta[indexPath.row].valueForKey("data") as! NSDictionary;
            
            
            if (messages[indexPath.row].senderId == aDelegate.userId) {
                let alert: UIAlertController = UIAlertController(title: poll.stringForKey("question")!, message: "", preferredStyle: .ActionSheet)
                let answers: [String] = poll.valueForKey("answers") as! [String];
                
                for answer in answers {
                    let ans: UIAlertAction = UIAlertAction(title:answer, style: .Default, handler: {(action: UIAlertAction) -> Void in
                        
                    })
                    alert.addAction(ans)
                }
                
                let act1: UIAlertAction = UIAlertAction(title:"View poll details and chat", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(act1)

                let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                    
                })
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleGreenColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
        outgoingBubbleImageViewEvent = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        outgoingBubbleImageViewPoll = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleRedColor())
        incomingBubbleImageViewEvent = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageViewPoll = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleRedColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        let messageMeta = messagesMeta[indexPath.item];
        if message.senderId == senderId { // 2
            if ((messageMeta["type"]! as! String) == "event") {
                return outgoingBubbleImageViewEvent;
            }
            else if ((messageMeta["type"]! as! String) == "poll") {
                return outgoingBubbleImageViewPoll;
            }
            else {
                return outgoingBubbleImageView
            }
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return avatars.valueForKey(messages[indexPath.row].senderId) as! JSQMessagesAvatarImage;
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
        let messageMeta = ["type":"text", "data":text];
        messagesMeta.append(messageMeta);
    }
    
    func addEvent(id: String, text: String, event: AttachedEvent) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
        let messageMeta = ["type":"event", "data":event];
        messagesMeta.append(messageMeta);
    }
    
    func addPoll(id: String, text: String, poll: NSDictionary) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
        let messageMeta = ["type":"poll", "data":poll];
        messagesMeta.append(messageMeta);
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        //        let itemRef = messageRef.childByAutoId() // 1
//        let messageItem = [ // 2
//            "text": text,
//            "senderId": senderId
//        ]
        addMessage(senderId, text: text);
        //        itemRef.setValue(messageItem) // 3
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        //        isTyping = false
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        setAttachmentPanelVisible(!isAttachmentPanelVisible(), animated: true);
        
    }
    
    @IBAction func attachmentClick (sender: AnyObject) {
        let btn = sender as! UIButton;
        Util.showMessageInViewController(self, title: "yes", message: "\(btn.tag)", completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AttachEvent") {
            if let vc: AttachEvent = segue.destinationViewController as? AttachEvent {
                vc.delegate = self;
            }
        }
        else if (segue.identifier == "AttachPoll") {
            if let vc: AttachPoll = segue.destinationViewController as? AttachPoll {
                vc.delegate = self;
            }
        }
    }
    
    func sendSelectedEventData(event: AttachedEvent) {
        addEvent(aDelegate.userId, text: "Jack Joyce send an invitation. Tap here to interact.\n\n\(event.title)\n\(event.date), \(event.time)\n\(event.location)", event: event);
    }
    
    func sendSelectedPollData(poll: NSDictionary) {
        let answers = poll["answers"] as! NSArray;
        var answersStr = "";
        for i in 0...answers.count-1 {
            if (answersStr != "") {
                answersStr += "\n";
            }
            answersStr += "\(i + 1). \(answers[i])";
        }
        //answersStr = "Poll choice: " + answersStr;
        addPoll(aDelegate.userId, text: "Jack Joyce send a poll. Tap here to interact.\n\n\(poll["question"]!)\n\n\(answersStr)", poll: poll);
    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cell: JSQMessagesCollectionViewCell = (super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell)
//        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.bubbleTap))
//        cell.addGestureRecognizer(tap)
//        return cell
//    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
    //    private func observeMessages() {
    //        // 1
    //        let messagesQuery = messageRef.queryLimitedToLast(25)
    //        // 2
    //        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
    //            // 3
    //            let id = snapshot.value["senderId"] as! String
    //            let text = snapshot.value["text"] as! String
    //
    //            // 4
    //            self.addMessage(id, text: text)
    //
    //            // 5
    //            self.finishReceivingMessage()
    //        }
    //    }
    //
    //
    //
    //    var userIsTypingRef: Firebase! // 1
    //    private var localTyping = false // 2
    //    var isTyping: Bool {
    //        get {
    //            return localTyping
    //        }
    //        set {
    //            // 3
    //            localTyping = newValue
    //            userIsTypingRef.setValue(newValue)
    //        }
    //    }
    //    var usersTypingQuery: FQuery!
    //
    //    private func observeTyping() {
    //        //        let typingIndicatorRef = rootRef.childByAppendingPath("typingIndicator")
    //        //        userIsTypingRef = typingIndicatorRef.childByAppendingPath(senderId)
    //        //        userIsTypingRef.onDisconnectRemoveValue()
    //        let typingIndicatorRef = rootRef.childByAppendingPath("typingIndicator")
    //        userIsTypingRef = typingIndicatorRef.childByAppendingPath(senderId)
    //        userIsTypingRef.onDisconnectRemoveValue()
    //
    //        // 1
    //        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
    //
    //        // 2
    //        usersTypingQuery.observeEventType(.Value) { (data: FDataSnapshot!) in
    //
    //            // 3 You're the only typing, don't show the indicator
    //            if data.childrenCount == 1 && self.isTyping {
    //                return
    //            }
    //
    //            // 4 Are there others typing?
    //            self.showTypingIndicator = data.childrenCount > 0
    //            self.scrollToBottomAnimated(true)
    //        }
    //    }
    //    
    //    override func textViewDidChange(textView: UITextView) {
    //        super.textViewDidChange(textView)
    //        // If the text is not empty, the user is typing
    //        isTyping = textView.text != ""
    //    }
}