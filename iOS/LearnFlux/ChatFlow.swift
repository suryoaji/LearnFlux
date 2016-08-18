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

class ChatFlow : JSQMessagesViewController, AttachEventReturnDelegate, AttachPollReturnDelegate {
    // MARK: Properties
    enum From{
        case CreateThread
        case OpenChat
        case None
    }
    var openedBy : From!
    var rowIndexPathFromThread : Int!
    var clickedMessageIndexpath : Int?
    var chatId : String = "";
    var localChat : Array<AnyObject>! = [];
    
    let aDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    var thisChatType : String! = "chat";
    var thisChatMetadata : Dictionary<String, AnyObject>!
    
    var popupIndexRow : Int! = -1; // if -2 then it is "thisChatType" popup
    
    var messages : [Thread.ThreadMessage] = []
    var messagesSelection = [String]();
    var attachmentPanelOld : UIView!;
    @IBOutlet var attachmentPanel : UIView!;
    @IBOutlet var pulldownPanel : UIView!;
    let scrHeight = UIScreen.mainScreen().bounds.height;
    let scrWidth = UIScreen.mainScreen().bounds.width;
    
    var attachEventTv : AttachEvent!;
    @IBOutlet var pulldownPanelContent : UIView!;
    
    var isImportantMessage : Bool = false;
    var timer : NSTimer!;
    var ownMessagePendingCount: Int! = 0;
    
    var shouldFinishSendingMessage : Bool = true;
    var pendingMessageCount : Int = 0;
    
    var isKeyboardShown : Bool = false
    var keyboardHeight : CGFloat = 0
    var idGroup: String?
    let clientData = Engine.clientData
    var tmpRowEvent : Int? = nil
    var lastTimestampToRequestNewMessage : Double!
    @IBOutlet var participantsPanel: UIView!
    @IBOutlet weak var labelPartipicants: UILabel!
    var isShowParticipantsPanel: Bool = false{
        didSet{
            if self.isShowParticipantsPanel{ self.participantsPanel.alpha = 1 }
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                self.participantsPanel.y += self.isShowParticipantsPanel ? self.participantsPanel.bounds.size.height : -self.participantsPanel.bounds.size.height
                }, completion: { finished in
                    if !self.isShowParticipantsPanel{ self.participantsPanel.alpha = 0 }
            })
        }
    }
    
    func initChat(rowIndexPath: Int, idThread: String, from: From){
        self.rowIndexPathFromThread = rowIndexPath
        self.chatId = idThread
        self.openedBy = from
    }
    
    func updateChatView(JSON : AnyObject? = nil){
        let oldCount = localChat.count;
        
        if (JSON == nil) {
            if (Engine.clientData.defaults.valueForKey(chatId) != nil) {
                localChat = Engine.clientData.defaults.valueForKey(chatId)! as! Array<AnyObject>
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
    
    func setButtonAttachmentNImportantChatToolbar(){
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
        self.lastTimestampToRequestNewMessage = NSDate().timeIntervalSince1970
    }
    
    func setAttachmentNPulldownPanelPosition(){
        self.initAttachmentPanel();
        attachmentPanel.y = scrHeight;
        self.view.addSubview(attachmentPanel);
        pulldownPanel.removeFromSuperview();
        finishSendingMessage();
        self.collectionView.layer.zPosition = -0.01
        attachmentPanel.layer.zPosition = -0.001
    }
    
    func initRightBarButton(){
        let rightBarButton = UIBarButtonItem()
        rightBarButton.image = UIImage(named: "menu")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.action = #selector(self.showMenu)
        rightBarButton.target = self
        
    }
    
    func initTitleBarButton(){
        let buttonTitle =  UIButton(type: .Custom)
        let widthNavigationBar = self.navigationController!.navigationBar.bounds.width
        let heightNavigationBar = self.navigationController!.navigationBar.bounds.height
        buttonTitle.frame = CGRectMake(0, 0, widthNavigationBar * 3/4, heightNavigationBar) as CGRect
        buttonTitle.setTitle(self.title, forState: UIControlState.Normal)
        buttonTitle.addTarget(self, action: #selector(self.titleBarTapped), forControlEvents: UIControlEvents.TouchUpInside)
        buttonTitle.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.titleView = buttonTitle
    }
    
    @IBAction func titleBarTapped(sender: UIButton){
        self.isShowParticipantsPanel = !self.isShowParticipantsPanel
    }
    
    func initParticipantsPanel(){
        var textParticipants = ""
        let arrIdParticipants = clientData.getMyThreads()![rowIndexPathFromThread].participants
        var conArr : Array<Int>= []
        loopCheck : for i in arrIdParticipants{
            for x in conArr{
                if x == i.user?.userId{ continue loopCheck }
            }
            if i.user?.userId == clientData.cacheMe()!["id"] as? Int{
                continue loopCheck
            }
            conArr.append((i.user?.userId)!)
        }
        for i in 0..<conArr.count{
            if i != conArr.count - 1{
                textParticipants += "\(conArr[i]), "
            }else{
                textParticipants += "\(conArr[i])"
            }
        }
        self.participantsPanel.frame.size.width = self.view.frame.size.width
        self.labelPartipicants.text = textParticipants
        self.view.addSubview(self.participantsPanel)
    }
    
    func setChatRoomInfo(){
        self.title = Engine.generateThreadName(Engine.clientData.getMyThreads()![self.rowIndexPathFromThread])
        self.thisChatType = "chat"
        self.thisChatMetadata = ["title" : title!]
        if let me = Engine.clientData.cacheMe(){
            self.senderId = String(me["id"] as! Int)
        }
        self.senderDisplayName = "";
        
        initRightBarButton()
        initTitleBarButton()
        initParticipantsPanel()
    }
    
    func loadMessages(){
//        self.messages = getJSQMessages(self.chatId)
        if let messages = Engine.clientData.getMyThreads()![rowIndexPathFromThread].messages{
            self.messages = messages
        }
        self.updateChatView()
    }
    
    func callGetNewMessages(lastSync: Double? = nil){
        var userInfo : Dictionary<String, AnyObject> = [:]
        if lastSync != nil{
            userInfo["lastSync"] = lastSync
        }else{
            if let cacheLastSync = Engine.clientData.cacheLastSyncThreads(){
                userInfo["lastSync"] = cacheLastSync
            }else{
                userInfo["lastSync"] = NSDate().timeIntervalSince1970
            }
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.getNewMessages), userInfo: userInfo, repeats: false)
    }
    
    func getNewMessages(timer: NSTimer){
        Engine.getNewMessages(self, indexpath: clientData.getMyThreads()![rowIndexPathFromThread].normalIndex, lastSync: timer.userInfo!["lastSync"] as! Double){status, newMessage, lastSync in
            if let conNewMessage = newMessage{
                func filterNewMessage(con: Array<Thread.ThreadMessage>) -> Array<Thread.ThreadMessage>{
                    var message : Array<Thread.ThreadMessage> = []
                    for each in con{
                        if each.message.senderId == String(self.clientData.cacheMe()!["id"] as! Int) && each.meta["type"] as! String == "chat"{
                            continue
                        }
                        message.append(each)
                    }
                    return message
                }
                let filteredMessage = filterNewMessage(conNewMessage)
                self.messages += filteredMessage
                Engine.clientData.getMyThreads()![self.rowIndexPathFromThread].addMessages(filteredMessage)
                self.finishSendingMessageAnimated(true)
            }
            self.lastTimestampToRequestNewMessage = lastSync
            self.callGetNewMessages(self.lastTimestampToRequestNewMessage)
        }
    }
    
    func createLayoutChatRoom(){
        setButtonAttachmentNImportantChatToolbar()
        setAttachmentNPulldownPanelPosition()
        setChatRoomInfo()
        if openedBy == From.OpenChat{
            loadMessages()
        }
    }
    
    func getIdGroupOfThisThread(){
        self.idGroup = clientData.idGroupByIdThread(self.chatId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "ChatChat"
//        print ("Chat Flow =======");
//        print ("Chat ID = \(chatId)");
//        print ("Chat Participants ID: \(participantsId)");
        self.createLayoutChatRoom()
        self.getIdGroupOfThisThread()
//        let attachment = UIButton(type: .System);
//        attachment.setImage(UIImage(named: "clip-18"), forState: UIControlState.Normal);
//        self.inputToolbar.contentView.leftBarButtonItem = attachment;
//        // No avatars
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    func showMenu(){
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        callGetNewMessages(self.lastTimestampToRequestNewMessage)
        self.setObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
        self.removeAllObserver()
    }
    
    func setObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.deleteMessage), name: "LFDeleteMessageNotification", object: nil)
    }
    
    func removeAllObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification){
        self.isKeyboardShown = true
        self.keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        attachmentPanel.y = scrHeight - self.keyboardHeight
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.isKeyboardShown = false
        attachmentPanel.y = scrHeight
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
            self.title = meta["title"]! as? String;
        }
//        self.view.bringSubviewToFront(self.view.inputView!);
        setTabBarVisible(false, animated: true)
        
        let flow = Flow.sharedInstance;
        if (flow.activeFlow() == "NewThreads") {
            flow.removeFlowVc(self.navigationController!, exceptVc: [self]);
            flow.clear();
        }
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
    
//    func initAttachmentPanelOld() {
//        let container = attachmentPanel;
//        var containerHeight:CGFloat = 200;
//        container.x = 0;
//        container.y = scrHeight - 200;
//        container.height = 200 - 43;
//        container.width = scrWidth;
//        container.backgroundColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1);
//        self.view.addSubview(container);
//        
//        let spacing:CGFloat = 10;
//        
//        let btnEvent = UIButton(type: UIButtonType.System);
//        let btnPoll = UIButton(type: UIButtonType.System);
//        //        let btnPicture = UIButton();
//        //        let btnVideo = UIButton();
//        //        let btnFiles = UIButton();
//        
//        btnEvent.frame = CGRectMake(spacing, spacing, (scrWidth - spacing) / 2 - spacing, 44);
//        btnPoll.frame = CGRectMake((scrWidth + spacing) / 2, spacing, (scrWidth - spacing) / 2 - spacing, 44);
//        
//        
//        btnEvent.setTitle(" Event", forState: .Normal);
//        btnPoll.setTitle(" Poll", forState: .Normal);
//        
//        btnEvent.setImage(UIImage(named: "calendar-24"), forState: .Normal);
//        btnPoll.setImage(UIImage(named: "line_chart-24"), forState: .Normal);
//        
//        btnEvent.titleLabel!.font = UIFont(name: "System", size: 18);
//        btnPoll.titleLabel!.font = UIFont(name: "System", size: 18);
//        
//        btnEvent.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1);
//        btnPoll.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1);
//        
//        btnEvent.tag = 1;
//        btnPoll.tag = 2;
//        
//        btnEvent.addTarget(self, action: #selector (self.attachmentClick), forControlEvents: .TouchUpInside);
//        btnPoll.addTarget(self, action: #selector (self.attachmentClick), forControlEvents: .TouchUpInside);
//        
//        container.addSubview(btnEvent);
//        container.addSubview(btnPoll);
//        
//        containerHeight = spacing * 2 + btnEvent.height;
//        container.height = containerHeight;
//        container.y = scrHeight - containerHeight - 43;
//        
//        container.y = scrHeight;
//    }
    
    func isAttachmentPanelVisible () -> Bool {
//        print ("\(attachmentPanel.x), \(attachmentPanel.y), \(attachmentPanel.width), \(attachmentPanel.height)");
        if self.isKeyboardShown{
            return attachmentPanel.y < (scrHeight - self.keyboardHeight)
        }else{
            return attachmentPanel.y < scrHeight
        }
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
    
    func addMessage(id: String, text: String, date: NSDate = NSDate(), event: NSDictionary? = nil, poll: Dictionary<String, AnyObject>? = nil) {
        let message = JSQMessage(senderId: id, senderDisplayName: "", date: date, text: text)
        
        let messageMeta : Dictionary<String, AnyObject>!
        if event != nil{
            messageMeta = ["type":"event", "data":event!, "important":"no"]
        }else if poll != nil{
            messageMeta = ["type":"poll", "data":poll!, "important":"no"]
        }else{
            messageMeta = ["type":"chat", "data":text, "important": (isImportantMessage ? "yes" : "no")]
        }
        messages.append((message: message, meta: messageMeta, secret: nil))
        isImportantMessage = true;
        importantButtonTouched();
        Engine.addMessage(self.chatId, message: text){status, JSON in
            if status == .Success{
                Engine.clientData.getMyThreads()![self.rowIndexPathFromThread].addMessage((message: message, meta: messageMeta, secret: nil))
            }
        }
    }
    
    func addMessage(id: String, text: String, timeInterval: Double) {
        addMessage(id, text:text, date:NSDate(timeIntervalSince1970: timeInterval))
    }
    
    func addEventMessage(id: String, text: String, event: NSDictionary, date: NSDate = NSDate()) {
        addMessage(id, text: text, date: date, event: event)
    }
    
    func addPollMessage(id: String, text: String, poll: Dictionary<String, AnyObject>, date: NSDate = NSDate()) {
        addMessage(id, text: text, date: date, poll: poll)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        addMessage(senderId, text: text);
        ownMessagePendingCount = ownMessagePendingCount + 1;
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
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
                vc.meta = sender as! Dictionary<String, AnyObject>
            }
        }
        else if (segue.identifier == "PollDetails") {
            if let vc: PollDetails = segue.destinationViewController as? PollDetails {
                vc.meta = sender as! Dictionary<String, AnyObject>
            }
        }
    }
    
    func sendSelectedEventData(event: Dictionary<String, AnyObject>) {
        if let idGroup = self.idGroup{
            Engine.createEvent(event, idGroup: idGroup)
            setAttachmentPanelVisible(false, animated: false);
        }
    }
    
    func sendSelectedPollData(poll: Dictionary<String, AnyObject>) {
        Engine.createPoll(poll){ status, JSON in
            if status == .Success{
                if let rawJSON = JSON where ((rawJSON as? Dictionary<String, AnyObject>) != nil){
                    guard let rawJSON = JSON else{
                        return
                    }
                    guard let paramResponse = (rawJSON as! Dictionary<String, AnyObject>)["data"] else{
                        return
                    }
                    Engine.sendPollToMessage(paramResponse as! Dictionary<String, AnyObject>, idThread: self.clientData.getMyThreads()![self.rowIndexPathFromThread].id){ status, JSON in
                        
                    }
                }
            }
        }
        setAttachmentPanelVisible(false, animated: false);
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
}

//MARK Collection View
extension ChatFlow{
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item].message
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        cell.setIndexpathIdentifier(indexPath.row)
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        return JSQMessagesBubbleImage.fromMessage(messages[indexPath.row])
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImage.initWithSenderId(messages[indexPath.row].message.senderId)
    }
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        if messages[indexPath.row].message.senderId == clientData.cacheMe()!["id"] as! Int{
//            return NSAttributedString(string: "Pengirim")
//        }else{
//            return NSAttributedString(string: "Penerima")
//        }
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
//        if messages[indexPath.row].message.senderId != clientData.cacheMe()!["id"] as! Int{
//            return 20
//        }
//        return 0
//    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        self.inputToolbar.contentView.textView.resignFirstResponder()
        let messageMeta = messages[indexPath.row].meta;
        let eventType = messageMeta["type"]! as! String;
        if (eventType == "event") {
            for each in 0..<clientData.getMyEvents()!.count{
                if clientData.getMyEvents()![each].id == messages[indexPath.row].secret!.idType!{
                    popupEvent(indexPath.row, statusEvent: clientData.getMyEvents()![each].status)
                    self.tmpRowEvent = each
                }
            }
        }
        else if (eventType == "poll") {
            popupPoll(indexPath.row);
        }
    }
    
    func deleteMessage(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let indexPath = userInfo["indexPath"]! as! Int
            print("\ndeleteMessageTriggered")
            print("Delete Cell in row indexPath : \(indexPath)")
            print(messages[indexPath].message.text)
            print(messages[indexPath].meta)
            print("======================\n")
        }
    }
}

//MARK CZPicker
extension ChatFlow : CZPickerViewDataSource, CZPickerViewDelegate{
    func popupEvent (indexRow : Int, statusEvent: Int? = nil) {
        let picker = CZPickerView(headerTitle: headerAlertEvent(messages[indexRow].meta), cancelButtonTitle: "Event Details", confirmButtonTitle: "Ok");
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = indexRow != -2;
        picker.tapBackgroundToDismiss = false;
        picker.allowMultipleSelection = false;
        popupIndexRow = indexRow;
        if let status = statusEvent where status != 0{
            picker.setSelectedRows(selectEventRow(status))
        }
        picker.show();
    }
    
    func popupPoll (indexRow : Int) {
        let meta = messages[indexRow].meta
        if hasPolling(answerers: (meta["data"] as! Dictionary<String, AnyObject>)["answerers"] as! Dictionary<String, Int>){
            return
        }
        let data = meta["data"] as! Dictionary<String, AnyObject>
        let question = data["question"] as! String
        
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
        let meta = messages[popupIndexRow].meta
        
        if (meta["type"]! as! String == "event") {
            return 3;
        }
        else if (meta["type"]! as! String == "poll") {
            let data = meta["data"] as! Dictionary<String, AnyObject>
            let answers = data["answers"] as! Array<String>
            return answers.count
        }
        return 0;
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        let meta = messages[popupIndexRow].meta
        
        if (meta["type"]! as! String == "event") {
            var selection = meta["selection"]
            if (selection == nil) {
                selection = "";
            }
            switch (row) {
            case 0: return (selection as! String == "yes" ? "✔️  " : "") + "Yes, I will attend";
            case 1: return "Oh, I Am Interested"
            case 2: return (selection as! String == "no" ? "✔️  " : "") + "No, I will not attend";
            default: return "";
            }
        }
        else if (meta["type"]! as! String == "poll") {
            var selection = meta["selection"]
            if (selection == nil) {
                selection = "";
            }
            let data = meta["data"] as! Dictionary<String, AnyObject>
            let answers = data["answers"] as! Array<String>
            return (selection as! String == "\(row)" ? "✔️  " : "") + answers[row];
        }
        return "";
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        var meta = messages[popupIndexRow].meta
        if meta["type"] as! String == "event" {
            Engine.updateStatusEvent(rsvpByRow(row), rowEvent: &self.tmpRowEvent)
        }
        else if meta["type"]! as! String == "poll" {
            let pollMetaData = meta["data"] as! Dictionary<String, AnyObject>
            let indexRow : Int = popupIndexRow
            Engine.sendPollOption((pollMetaData["answers"] as! Array<String>)[row], pollId: pollMetaData["id"] as! String){ status, _ in
                if status == .Success{
                    let newData = self.updateAnswererPoll(pollMetaData["answerers"] as? Dictionary<String, Int>, newValue: (id: String(self.clientData.cacheMe()!["id"] as! Int), value : row))
                    let newMeta = self.makeNewMeta(meta, newValue: ["answerers" : newData])
                    self.messages[indexRow].meta = newMeta
                    self.clientData.getMyThreads()![self.rowIndexPathFromThread].messages![indexRow].meta = newMeta
                }
            }
        }
    }
    
    func makeNewMeta(oldMeta: Dictionary<String, AnyObject>, newValue: Dictionary<String, AnyObject>)-> Dictionary<String, AnyObject>{
        var newMeta = oldMeta
        var data = newMeta["data"] as! Dictionary<String, AnyObject>
        for each in newValue{
            data[each.0] = each.1
        }
        newMeta["data"] = data
        return newMeta
    }
    
    func updateAnswererPoll(answerers: Dictionary<String, Int>?, newValue: (id: String, value: Int)) -> (Dictionary<String, Int>){
        var value : Dictionary<String, Int> = [:]
        if let answerers = answerers{
            for each in answerers{
                if each.0 == String(clientData.cacheMe()!["id"] as! Int){ return answerers }
            }
            value = answerers
        }
        value[newValue.id] = newValue.value
        return value
    }
    
    func czpickerViewDidClickCancelButton(pickerView: CZPickerView!) {
        let meta = messages[popupIndexRow].meta
        
        if (meta["type"]! as! String == "event") {
            self.performSegueWithIdentifier("EventDetails", sender: meta);
        }
        else if (meta["type"]! as! String == "poll") {
            self.performSegueWithIdentifier("PollDetails", sender: meta);
        }
    }
    
    func headerAlertPoll(meta: Dictionary<String, AnyObject>) -> (String){
        print(meta)
        return ""
    }
    
    func headerAlertEvent(meta: Dictionary<String, AnyObject>) -> (String){
        guard let data = meta["data"] as? Dictionary<String, AnyObject> else{
            return "Will you attend this Event?"
        }
        let title = data["title"] as! String
        let location = data["location"] as! String
        return "\(title) at \(location)"
    }
    
    func rsvpByRow(selectedRow: Int) -> (Int){
        switch selectedRow {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return -1
        default:
            return 0
        }
    }
    
    func selectEventRow(status: Int) -> ([Int]){
        switch status {
        case -1:
            return [2]
        case 1:
            return [1]
        case 2:
            return [0]
        default:
            return [0]
        }
    }
    
    func hasPolling(answerers answerers: Dictionary<String, Int>) -> (Bool){
        for each in answerers{
            if String(clientData.cacheMe()!["id"] as! Int) == each.0{
                return true
            }
        }
        return false
    }
}