//
//  ChatFlow.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import CZPicker

//import JSMessageBubbleImage

class ChatFlow : JSQMessagesViewController, AttachEventReturnDelegate, AttachPollReturnDelegate, CZPickerViewDataSource, CZPickerViewDelegate {
    // MARK: Properties
    var chatId : String = "";
    var participantsId = [Dictionary<String, Int>]();
    var participants = [AnyObject]();
    var localChat : Array<AnyObject>! = [];
    
    let aDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    var thisChatType : String! = "chat";
    var thisChatMetadata : NSMutableDictionary!;
    
    var popupIndexRow : Int! = -1; // if -2 then it is "thisChatType" popup
    
    var messages = [JSQMessage]()
    var messagesMeta = [NSMutableDictionary]()
    var messagesSelection = [String]();
    var outgoingBubbleImageView,
    outgoingBubbleImageViewEvent,
    outgoingBubbleImageViewPoll,
    outgoingBubbleImageViewImportant,
    incomingBubbleImageView,
    incomingBubbleImageViewEvent,
    incomingBubbleImageViewPoll,
    incomingBubbleImageViewImportant : JSQMessagesBubbleImage!
    var attachmentPanelOld : UIView!;
    @IBOutlet var attachmentPanel : UIView!;
    @IBOutlet var pulldownPanel : UIView!;
    var avatars : NSMutableDictionary!;
    let scrHeight = UIScreen.mainScreen().bounds.height;
    let scrWidth = UIScreen.mainScreen().bounds.width;
    
    var attachEventTv : AttachEvent!;
    @IBOutlet var pulldownPanelContent : UIView!;
    
    var isImportantMessage : Bool = false;
    var timer : NSTimer!;
    var ownMessagePendingCount: Int! = 0;
    
    var shouldFinishSendingMessage : Bool = true;
    var pendingMessageCount : Int = 0;
    
    func initChat (title: String, chatType: String, chatId: String, participants: [AnyObject], chatMetadata: NSDictionary) {
        self.title = title;
        self.chatId = chatId;
        self.participants = participants;
        self.thisChatType = chatType;
        self.thisChatMetadata = chatMetadata.mutableCopy() as! NSMutableDictionary;
        let me = Data.defaults.valueForKey("me")! as! NSDictionary;
        self.senderId = String(me.valueForKey("id")!);
        self.senderDisplayName = "";
        
        Engine.getThreadMessages(self, threadId: chatId) { status, JSON in
            self.updateChatView(JSON);
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.getNewMessages), userInfo: nil, repeats: true);
    }
    
    func initChat (threadJSON JSON: AnyObject?) {
        let data = JSON?.valueForKey("data")! as! NSDictionary;
        let title = data.valueForKey("title")! as! String;
        let chatId = data.valueForKey("id")! as! String;
        let participants = data.valueForKey("participants")! as! [AnyObject];
        self.initChat(title, chatType: "text", chatId: chatId, participants: participants, chatMetadata: ["title": title])
    }
    
    func getNewMessages () {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Engine.getThreadMessages(self, threadId: chatId) { status, JSON in
            self.updateChatView(JSON);
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        }
    }
    
    func updateChatView (JSON : AnyObject? = nil){
        let oldCount = localChat.count;
        
        if (JSON == nil) {
            if (Data.defaults.valueForKey(chatId) != nil) {
                localChat = Data.defaults.valueForKey(chatId)! as! Array<AnyObject>
            }
        }
        else {
            let data = JSON!.valueForKey("data")!;
//            print (data);
            let messages = data.valueForKey("messages")!;
//            print(messages);
            if (messages.isKindOfClass(NSArray)) {
                self.localChat = messages as! Array<AnyObject>;
            }
        }
        
        var newMessageCount = 0;
        
        if localChat.count > oldCount {
            for i in oldCount..<localChat.count {
                newMessageCount += 1
                
                let curChat = localChat[i] as! NSDictionary;
                let senderWrapper = curChat.valueForKey("sender")! as! NSDictionary;
                let senderId = senderWrapper.valueForKey("id")! as! Int;
                let messageBody = curChat.valueForKey("body")! as! String;
                let timeStamp = curChat.valueForKey("created_at")! as! Double;
                
                if (String(senderId) == self.senderId) {
                    if (ownMessagePendingCount > 0) {
                        ownMessagePendingCount = ownMessagePendingCount - 1;
                    }
                    else {
                        addMessage("\(senderId)", text: messageBody, timeInterval: timeStamp);
                    }
                }
                else {
                    addMessage("\(senderId)", text: messageBody, timeInterval: timeStamp);
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                var temp = "";
                if (self.inputToolbar.contentView.textView.text != nil) {
                    temp = self.inputToolbar.contentView.textView.text;
                }
                
                if (self.shouldFinishSendingMessage) {
                    self.finishSendingMessage();
                    self.pendingMessageCount = 0;
                }
                else {
                    self.pendingMessageCount += newMessageCount;
                }
                
                self.inputToolbar.contentView.textView.text = temp;
                self.inputToolbar.toggleSendButtonEnabled();
            }
        }
        
        if (pendingMessageCount > 0) {
//            print ("Have Pending Message (\(self.pendingMessageCount))!");
        }
        
        if (pendingMessageCount > 0 && self.shouldFinishSendingMessage) {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                var temp = "";
                if (self.inputToolbar.contentView.textView.text != nil) {
                    temp = self.inputToolbar.contentView.textView.text;
                }
                
                self.finishSendingMessage();
                self.pendingMessageCount = 0;
                
                self.inputToolbar.contentView.textView.text = temp;
                self.inputToolbar.toggleSendButtonEnabled();
            }
        }

    }
    
    override func scrollViewDidScroll(aScrollView: UIScrollView) {
        let offset: CGPoint = aScrollView.contentOffset
        let bounds: CGRect = aScrollView.bounds
        let size: CGSize = aScrollView.contentSize
        let inset: UIEdgeInsets = aScrollView.contentInset
        let y: CGFloat = offset.y + bounds.size.height - inset.bottom
        let h: CGFloat = size.height
        // NSLog(@"offset: %f", offset.y);
        // NSLog(@"content.height: %f", size.height);
        // NSLog(@"bounds.height: %f", bounds.size.height);
        // NSLog(@"inset.top: %f", inset.top);
        // NSLog(@"inset.bottom: %f", inset.bottom);
        // NSLog(@"pos: %f of %f", y, h);
//        print ("pos \(round(y)) of \(round(h))");
        let reload_distance: CGFloat = 50
        if y > h - reload_distance {
            shouldFinishSendingMessage = true;
        }
        else {
            shouldFinishSendingMessage = false;
        }
//        print ("should finish sending message? \(shouldFinishSendingMessage)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "ChatChat"
        setupBubbles()
//        print ("Chat Flow =======");
//        print ("Chat ID = \(chatId)");
//        print ("Chat Participants ID: \(participantsId)");
        let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        var image = UIImage(named: "clip-18.png");
        let attachButton: UIButton = UIButton(type: .Custom)
        attachButton.setImage(image, forState: .Normal)
        attachButton.addTarget(self, action: #selector(self.attachButtonTouched), forControlEvents: .TouchUpInside)
        attachButton.frame = CGRectMake(0, 0, 25, height)
        attachButton.tag = 10;
        image = UIImage(named: "important_red-18.png");
        let importantButton: UIButton = UIButton(type: .Custom)
        importantButton.setImage(image, forState: .Normal)
        importantButton.addTarget(self, action: #selector(self.importantButtonTouched), forControlEvents: .TouchUpInside)
        importantButton.frame = CGRectMake(30, 0, 25, height)
        importantButton.tag = 11;
        self.inputToolbar.contentView.leftBarButtonItemWidth = 55
        //        self.inputToolbar.contentView.rightBarButtonItemWidth = 50
        self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(attachButton)
        self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(importantButton)
        //        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "sendButton"), forState: .Normal)
        //        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", forState: .Normal)
        self.inputToolbar.contentView.leftBarButtonItem.hidden = true
        //        self.inputToolbar.contentView.rightBarButtonItem.hidden = false;

        
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
        pulldownPanel.removeFromSuperview();

//        addMessage(aDelegate.userId, text: "Hello");
//        addMessage("2", text: "Ya?\nYayaya!");
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
    
    override func textViewDidBeginEditing(textView: UITextView) {
//        print ("yess");
        setAttachmentPanelVisible(false, animated: false);
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        finishSendingMessage();
        
        if (thisChatType != "chat") {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = pulldownPanel.bounds
            gradient.colors = [UIColor.whiteColor().CGColor, UIColor.blackColor().CGColor]
            view.layer.insertSublayer(gradient, atIndex: 0)
            
            let length = CGFloat(200);
            pulldownPanel.frame = CGRectMake((view.width - length) / 2, self.navigationController!.navigationBar.frame.size.height + 20, length, 30)
            view.addSubview(pulldownPanel);
            
//            let meta = thisChatMetadata;

            if (thisChatType == "event") {
                self.title = "Event"
            }
            else if (thisChatType == "poll"){
                self.title = "Poll";
            }
        }
        else {
            let meta = thisChatMetadata;
            self.title = meta.valueForKey("title") as? String;
        }
//        self.view.bringSubviewToFront(self.view.inputView!);
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
        
        btnEvent.addTarget(self, action: #selector (self.attachmentClick), forControlEvents: .TouchUpInside);
        btnPoll.addTarget(self, action: #selector (self.attachmentClick), forControlEvents: .TouchUpInside);
        
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
        
        if (animated) {
        
            // zero duration means no animation
            let duration:NSTimeInterval = 0.3;
            
            //  animate the tabBar
            UIView.animateWithDuration(duration) {
                self.attachmentPanel.frame = CGRectOffset(frame, 0, offsetY)
                return
            }
        }
        else {
            self.attachmentPanel.frame = CGRectOffset(frame, 0, offsetY)
        }
        
//        self.inputToolbar.contentView.textView.resignFirstResponder();
//        self.view.window?.endEditing(true);
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
//        print ("BUBBLE TAP ----------");
        let tap = sender as! UITapGestureRecognizer;
        let indexPath = self.collectionView.indexPathForCell(tap.view as! JSQMessagesCollectionViewCell)!;
        let messageMeta = messagesMeta[indexPath.row];
        let eventType = messageMeta.valueForKey("type") as! String;
        
        if (eventType == "event") {
            let event = messagesMeta[indexPath.row].valueForKey("data") as! NSDictionary;
            
            if (messages[indexPath.row].senderId == aDelegate.userId) {
//                Util.showMessageInViewController(self, title: "You've sent this event to this group. Anyone who tap on this bubble can give response.", message: event.title, completion: nil);
                
                //event.stringForKey("title"), subTitle: event.stringForKey("time") + "for \(event.stringForKey("duration")) minutes\n" + event.stringForKey("location")
//                print (event);

                popupEvent(indexPath.row)
                
//                SweetAlert().showAlert(event.stringForKey("title"), subTitle: event.stringForKey("date") + " at " + event.stringForKey("time") + "\n\n" + event.stringForKey("location"), style: AlertStyle.None, buttonTitle:"Attend", buttonColor:UIColor.init(red: 57/255, green: 123/255, blue: 233/255, alpha: 1) , secondButtonTitle:  "I can't", secondButtonColor: UIColor.init(red: 221/255, green: 107/255, blue: 85/255, alpha: 1), thirdButtonTitle:"Join talk", thirdButtonColor:UIColor.init(red: 29/255, green: 211/255, blue: 63/255, alpha: 1)) { (selectedButton) -> Void in
//                    switch (selectedButton) {
//                    case 0: SweetAlert().showAlert("Thank you!", subTitle: "We wait for your presence.", style: AlertStyle.Success); break;
//                    case 1: SweetAlert().showAlert("Response sent", subTitle: "Thank you for your response", style: AlertStyle.Success); break;
//                    case 2:
//                        delay(1) {
//                            let vc = Util.getViewControllerID("ChatFlow") as! ChatFlow;
//                            vc.thisChatType = "event";
//                            vc.thisChatMetadata = event;
//                            vc.senderId = "1"
//                            vc.senderDisplayName = "Jack Joyce"
//                            self.navigationController?.pushViewController(vc, animated: true);
//                        }
//                        break;
//                    default: break;
//                    }
//                };

//                let alert: UIAlertController = UIAlertController(title: event.stringForKey("title"), message: "Your response to this event invitation:", preferredStyle: .ActionSheet)
//                
//                let act1: UIAlertAction = UIAlertAction(title:"I will attend this event", style: .Default, handler: {(action: UIAlertAction) -> Void in
//                    
//                })
//                alert.addAction(act1)
//                let act2: UIAlertAction = UIAlertAction(title:"I will not attend this event", style: .Default, handler: {(action: UIAlertAction) -> Void in
//
//                })
//                alert.addAction(act2)
//                let act3: UIAlertAction = UIAlertAction(title:"View event details and chat", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
//
//                })
//                alert.addAction(act3)
//                let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
//                    
//                })
//                alert.addAction(cancel)
//                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else if (eventType == "poll") {
            let poll = messagesMeta[indexPath.row].valueForKey("data") as! NSDictionary;
            
            if (messages[indexPath.row].senderId == aDelegate.userId) {
                
//                print (poll);
                
                popupPoll(indexPath.row);
                

                
//                let alert: UIAlertController = UIAlertController(title: poll.stringForKey("question")!, message: "", preferredStyle: .ActionSheet)
//                let answers: [String] = poll.valueForKey("answers") as! [String];
//                
//                for answer in answers {
//                    let ans: UIAlertAction = UIAlertAction(title:answer, style: .Default, handler: {(action: UIAlertAction) -> Void in
//                        
//                    })
//                    alert.addAction(ans)
//                }
//                
//                let act1: UIAlertAction = UIAlertAction(title:"View poll details and chat", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
//                    
//                })
//                alert.addAction(act1)
//
//                let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
//                    
//                })
//                alert.addAction(cancel)
//                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getMetadataWithIndex (indexRow : Int) -> NSMutableDictionary {
        var meta : NSMutableDictionary!;
        if (indexRow == -2) {
            meta = thisChatMetadata;
        }
        else if (indexRow >= 0) {
            meta = messagesMeta[indexRow];
        }
        else {
            meta = [:];
        }
        
        return meta;
    }
    
    func popupEvent (indexRow : Int) {
        let picker = CZPickerView(headerTitle: "Will you attend this event?", cancelButtonTitle: "Event Details", confirmButtonTitle: "Ok");
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = indexRow != -2;
        picker.tapBackgroundToDismiss = false;
        picker.allowMultipleSelection = false;
        popupIndexRow = indexRow;
        picker.show();
    }
    
    func popupPoll (indexRow : Int) {
        var question : String! = "";
        let meta = getMetadataWithIndex(indexRow);
        let data = meta["data"] as! NSDictionary;
        question = data["question"] as! String;

        let picker = CZPickerView(headerTitle: question, cancelButtonTitle: "Poll Details", confirmButtonTitle: "Ok");
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = indexRow != -2;
        picker.tapBackgroundToDismiss = false;
        picker.allowMultipleSelection = false;
        popupIndexRow = indexRow;
        picker.show();
    }
    
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        let meta = getMetadataWithIndex(popupIndexRow);
        
        if (meta.stringForKey("type") == "event") {
            return 2;
        }
        else if (meta.stringForKey("type") == "poll") {
            let data = meta["data"] as! NSDictionary;
            let answers = data["answers"] as! [String];
            return answers.count;
        }
        return 0;
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        let meta = getMetadataWithIndex(popupIndexRow);
        
        if (meta.stringForKey("type") == "event") {
            var selection = meta.stringForKey("selection");
            if (selection == nil) {
                selection = "";
            }
            switch (row) {
            case 0: return (selection == "yes" ? "✔️  " : "") + "Yes, I will attend";
            case 1: return (selection == "no" ? "✔️  " : "") + "No, I will not attend";
            default: return "";
            }
        }
        else if (meta.stringForKey("type") == "poll") {
            var selection = meta.stringForKey("selection");
            if (selection == nil) {
                selection = "";
            }
            let data = meta["data"] as! NSDictionary;
            let answers = data["answers"] as! [String];
            return (selection == "\(row)" ? "✔️  " : "") + answers[row];
        }
        return "";
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        let meta = getMetadataWithIndex(popupIndexRow);
        
        if (meta.stringForKey("type") == "event") {
            switch (row) {
            case 0: meta.setValue("yes", forKey: "selection");
            case 1: meta.setValue("no", forKey: "selection");
            default: break;
            }
        }
        else if (meta.stringForKey("type") == "poll") {
            meta.setValue("\(row)", forKey: "selection");
        }
    }
    
    func czpickerViewDidClickCancelButton(pickerView: CZPickerView!) {
        let meta = getMetadataWithIndex(popupIndexRow);
        
        if (meta.stringForKey("type") == "event") {
            self.performSegueWithIdentifier("EventDetails", sender: meta);
        }
        else if (meta.stringForKey("type") == "poll") {
            self.performSegueWithIdentifier("PollDetails", sender: meta);
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
            UIColor.jsq_messageBubbleBlueColor())
        outgoingBubbleImageViewImportant = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleRedColor())
        incomingBubbleImageViewEvent = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageViewPoll = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageViewImportant = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleRedColor())
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        let messageMeta = messagesMeta[indexPath.item];
//        print ("\(indexPath.row) = " + messageMeta.stringForKey("important"));

        if message.senderId == senderId { // 2
            if ((messageMeta["type"]! as! String) == "event") {
                return outgoingBubbleImageViewEvent;
            }
            else if ((messageMeta["type"]! as! String) == "poll") {
                return outgoingBubbleImageViewPoll;
            }
            else if ((messageMeta["type"]! as! String) == "chat") {
                if (messageMeta.stringForKey("important") == "yes") {
                    return outgoingBubbleImageViewImportant;
                }
                else {
                    return outgoingBubbleImageView;
                }
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
        return avatars.valueForKey("2") as! JSQMessagesAvatarImage;
//        return avatars.valueForKey(messages[indexPath.row].senderId) as! JSQMessagesAvatarImage;
//        return nil;
    }
    
    func addMessage(id: String, text: String, timeInterval: Double) {
        addMessage(id, text:text, date:NSDate(timeIntervalSince1970: timeInterval));
    }
    
    func addMessage(id: String, text: String, date: NSDate = NSDate()) {
        let message = JSQMessage(senderId: id, senderDisplayName: "", date: date, text: text)
        messages.append(message)
        let messageMeta = ["type":"chat", "data":text, "important": (isImportantMessage ? "yes" : "no")] as NSMutableDictionary;
        messagesMeta.append(messageMeta);
        isImportantMessage = true;
        importantButtonTouched();
    }
    
    func addEvent(id: String, text: String, event: NSDictionary, timeInterval: Double) {
        addEvent(id, text:text, event:event, date:NSDate(timeIntervalSince1970: timeInterval));
    }
    
    func addEvent(id: String, text: String, event: NSDictionary, date: NSDate = NSDate()) {
        let message = JSQMessage(senderId: id, senderDisplayName: "", date: date, text: text)
        messages.append(message)
        let messageMeta = ["type":"event", "data":event, "important":"no"] as NSMutableDictionary;
        messagesMeta.append(messageMeta);
    }

    func addPoll(id: String, text: String, poll: NSDictionary, timeInterval: Double) {
        addPoll(id, text:text, poll:poll, date:NSDate(timeIntervalSince1970: timeInterval));
    }
    
    func addPoll(id: String, text: String, poll: NSDictionary, date: NSDate = NSDate()) {
        let message = JSQMessage(senderId: id, senderDisplayName: "", date:date, text: text)
        messages.append(message)
        let messageMeta = ["type":"poll", "data":poll, "important":"no"] as NSMutableDictionary;
        messagesMeta.append(messageMeta);
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        //        let itemRef = messageRef.childByAutoId() // 1
//        let messageItem = [ // 2
//            "text": text,
//            "senderId": senderId
//        ]
        Engine.sendThreadMessage(threadId: chatId, body: text);
        addMessage(senderId, text: text);
        ownMessagePendingCount = ownMessagePendingCount + 1;
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
    
    @IBAction func attachButtonTouched () {
        setAttachmentPanelVisible(!isAttachmentPanelVisible(), animated: true);
        if (isAttachmentPanelVisible()) {
            self.inputToolbar.contentView.textView.resignFirstResponder();
        }
    }
    
    @IBAction func importantButtonTouched () {
        isImportantMessage = !isImportantMessage;
        let inputToolbar = self.inputToolbar;
        let contentView = inputToolbar.contentView;
        let theBtn = contentView?.viewWithTag(11);
        if (theBtn != nil) {
            let importantButton = self.inputToolbar.contentView.viewWithTag(11) as! UIButton;
            
            if (isImportantMessage) {
                importantButton.backgroundColor = UIColor.lightGrayColor();
            }
            else {
                importantButton.backgroundColor = UIColor.clearColor();
            }
        }
    }
    
    @IBAction func attachmentClick (sender: AnyObject) {
        let btn = sender as! UIButton;
        Util.showMessageInViewController(self, title: "yes", message: "\(btn.tag)")
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
        else if (segue.identifier == "EventDetails") {
            if let vc: EventDetails = segue.destinationViewController as? EventDetails {
                vc.meta = sender as! NSMutableDictionary;
            }
        }
        else if (segue.identifier == "PollDetails") {
            if let vc: PollDetails = segue.destinationViewController as? PollDetails {
                vc.meta = sender as! NSMutableDictionary;
            }
        }
    }
    
    func sendSelectedEventData(event: NSDictionary) {
        addEvent(aDelegate.userId, text: "📅 EVENT\n\nJack Joyce send an invitation. Tap here to interact.\n\n" + event.stringForKey("title") + "\n" + event.stringForKey("date") + ", " + event.stringForKey("time") + "\n" + event.stringForKey("location"), event: event);
        setAttachmentPanelVisible(false, animated: false);
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
        addPoll(aDelegate.userId, text: "📊 POLL\n\nJack Joyce send a poll. Tap here to interact.\n\n\(poll["question"]!)\n\n\(answersStr)", poll: poll);
        setAttachmentPanelVisible(false, animated: false);
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        return (action == #selector(self.deleteMessage(_:)) || action == #selector(self.copyMessage(_:)));
    }
    
    func deleteMessage(sender:AnyObject) {
//        print ("delete")
    }
    
    func copyMessage(sender:AnyObject) {
//        print ("copy")
    }
    
    @IBAction func pulldownClick (sender: AnyObject) {
//        attachEventTv = AttachEvent();
//        attachEventTv = Util.getViewControllerID("AttachEvent") as! AttachEvent;
//        pulldownPanelContent.addSubview(attachEventTv.tableView);
//        attachEventTv.tableView.frame = pulldownPanelContent.bounds;
//        attachEventTv.tableView.reloadData();
//        pulldownPanelContent.clip
//        self.view.addSubview(pulldownPanelContent);
        
        if (thisChatType == "event") {
            popupEvent(-2);
        }
        else if (thisChatType == "poll") {
            popupPoll(-2);
        }
        
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