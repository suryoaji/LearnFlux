//
//  Chats.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AZDropdownMenu

class Chats : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tv : UITableView!;
    
    let clientData = Engine.clientData
    var menu : AZDropdownMenu!;
    var deleteState = false
    var conDelete : Array<Bool> = []
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet var viewMenu : UIView!;
    @IBOutlet weak var viewConfirmDelete: UIView!
    var idsThreadWillDeleted : Array<String> = []
    var image = ["group01", "group02", "group03", "group04", "group05", "male04", "female01", "male01", "female02", "male02"]
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let menuTitle = ["Create Group Chat...", "Delete Chats...", "Delete All Chats"];
        menu = AZDropdownMenu(titles: menuTitle)
        
        Engine.getThreads(self)
        
        initAnimationDeleteNeeds()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.deleteState = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.countForUpdate), name: "ThreadsUpdateNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.countForUpdate), name: "GroupsUpdateNotification", object: nil)
        self.tv.reloadData()
        setTabBarVisible(true, animated: true);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier("1-0")!.height;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let myThreads = Engine.clientData.getMyThreads(){
            return myThreads.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("1-0")!;
        cell.setSeparatorType(CellSeparatorFull);
        let threadName = cell.viewWithTag(1) as! UILabel;
        let threadLastMessage = cell.viewWithTag(2) as! UILabel;
        
        threadLastMessage.text = self.setThreadLastMessage(indexPath.row)
        
        let selectedThread = Engine.clientData.getMyThreads()![indexPath.row]
        threadName.text = Engine.generateThreadName(selectedThread);
        let pp = cell.viewWithTag(10) as! UIImageView;
        pp.image = UIImage(named: self.image[indexPath.row % 10])
        pp.makeRounded();
        let conView = cell.viewWithTag(540)
        if self.deleteState{
            conView?.frame.origin.x = 0
            let radioButton = cell.viewWithTag(4) as! UIButton
            if self.conDelete[indexPath.row]{
                conView?.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
                radioButton.setImage(UIImage(named: "circle-ticked"), forState: .Normal)
                radioButton.tintColor = UIColor(red: 142/255.0, green: 197/255.0, blue: 73/255.0, alpha: 1.0)
            }else{
                conView?.backgroundColor = UIColor.whiteColor()
                radioButton.setImage(UIImage(named: "circle"), forState: .Normal)
                radioButton.tintColor = UIColor.lightGrayColor()
            }
        }else{
            conView?.frame.origin.x = -35
        }
        if let threads = Engine.clientData.getMyThreads(){
            let labelLastUpdated = cell.viewWithTag(3) as! UILabel
            labelLastUpdated.text = self.setLabelLastUpdated(threads[indexPath.row])
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if deleteState{
            self.conDelete[indexPath.row] = !self.conDelete[indexPath.row]
            let idThread = Engine.clientData.getMyThreads()![indexPath.row].id
            if conDelete[indexPath.row]{
                fillIdsThreadsArr(idThread)
            }else{
                defillIdsThreadsArr(idThread)
            }
            self.tv.reloadData()
        }else{
            self.performSegueWithIdentifier("Open Chat", sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }
    
    func fillIdsThreadsArr(idThread: String){
        self.idsThreadWillDeleted.append(idThread)
    }
    
    func defillIdsThreadsArr(idThread: String){
        if let indexIdThread = self.idsThreadWillDeleted.indexOf(idThread){
            self.idsThreadWillDeleted.removeAtIndex(indexIdThread)
        }
    }
    
    func initAnimationDeleteNeeds(){
        self.viewDelete.layer.shadowOpacity = 0.3
        self.viewDelete.layer.shadowOffset = CGSizeMake(0, 2)
        self.viewConfirmDelete.layer.shadowOpacity = 0.3
        self.viewConfirmDelete.layer.shadowOffset = CGSizeMake(0, 2)
        self.viewTransparantConfirmDelete = UIView(frame: self.view.bounds)
        self.viewTransparantConfirmDelete.backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    func animateDeleteState(deleteState: Bool){
        if Engine.clientData.getMyThreads() != nil{
            if let indexpaths = self.tv.indexPathsForVisibleRows{
                for i in 0..<indexpaths.count{
                    let cell = self.tv.cellForRowAtIndexPath(indexpaths[i])
                    let view = cell?.viewWithTag(540)
                    UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: {
                        view?.frame.origin.x += deleteState ? 35 : -35
                        }, completion: { finished in
                            if i == indexpaths.count-1{
                                self.deleteState = deleteState
                                self.tv.reloadData()
                            }
                    })
                }
            }
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                self.tabBarController!.tabBar.frame.origin.y += deleteState ? self.tabBarController!.tabBar.frame.size.height : -self.tabBarController!.tabBar.frame.size.height
                }, completion: { finished in
                    UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                        self.viewDelete.frame.origin.y -= deleteState ? self.tabBarController!.tabBar.frame.size.height : -self.tabBarController!.tabBar.frame.size.height
                        }, completion: nil)
            })
            if deleteState{
                for _ in 0..<Engine.clientData.getMyThreads()!.count{
                    self.conDelete.append(false)
                }
            }else{
                self.conDelete = []
            }
            self.tabBarController!.navigationItem.rightBarButtonItem!.image = UIImage(named: deleteState ? "back" : "menu")
        }
    }
    
    var viewTransparantConfirmDelete: UIView!
    func animateConfirmDelete(confirm: Bool){
        self.navigationController?.navigationBar.userInteractionEnabled = confirm ? false : true
        if confirm{
            self.view.addSubview(self.viewTransparantConfirmDelete)
        }
        UIView.animateWithDuration(0.27, delay: 0, options: .CurveEaseInOut, animations: {
            self.viewTransparantConfirmDelete.backgroundColor = confirm ? UIColor(white: 0, alpha: 0.4) : UIColor(white: 0, alpha: 0.0)
            self.viewTransparantConfirmDelete.frame.size.height -= confirm ? self.viewConfirmDelete.frame.size.height : -self.viewConfirmDelete.frame.size.height
            self.navigationController?.navigationBar.alpha = confirm ? 0.4 : 1.0
            self.viewConfirmDelete.frame.origin.y -= confirm ? self.viewConfirmDelete.frame.size.height : -self.viewConfirmDelete.frame.size.height
            }, completion: { finished in
                if !confirm{
                    self.viewTransparantConfirmDelete.removeFromSuperview()
                }
        })
    }
    
    @IBAction func buttonDeleteConfirmPressed(sender: UIButton) {
        Engine.deleteThreads(threadIds: self.idsThreadWillDeleted){ status, JSON in
            if status == .Success{
                self.idsThreadWillDeleted = []
                self.animateConfirmDelete(false)
                self.animateDeleteState(false)
            }
        }
    }
    
    @IBAction func buttonCancelConfirmDeletePressed(sender: UIButton) {
        self.animateConfirmDelete(false)
    }
    
    @IBAction func buttonDeletePressed(sender: UIButton) {
        if self.deleteState && !conDelete.filter({ $0 == true }).isEmpty{
            self.animateConfirmDelete(true)
        }
    }
    
    @IBAction func rightNavigationBarButtonTapped(sender: AnyObject) {
        if self.deleteState{
            self.idsThreadWillDeleted = []
            self.animateDeleteState(false)
        }else{
            Util.showAlertMenu(self, title: "", choices: ["Create Group Chat...", "Delete Chats...", "Delete All Chats"], styles: [.Default,.Destructive,.Destructive], addCancel: true) { (selected) in
                switch (selected) {
                case 0:
                    self.performSegueWithIdentifier("NewGroups", sender: self.menu);
                    break;
                case 1:
                    self.animateDeleteState(true)
                    break;
                case 2:
                    Util.showChoiceInViewController(self, title: "Confirmation", message: "Are you sure you want to erase all the chat threads?", buttonTitle: ["Yes", "Cancel"], buttonStyle: [UIAlertActionStyle.Destructive, UIAlertActionStyle.Cancel], callback: { selectedBtn in
                        var selectedThreads = Array<String>();
                        if (selectedBtn == 0) {
                            for thread in self.clientData.getMyThreads()! {
                                //                            if (selectedThreads.count < 1) {
                                selectedThreads.append(thread.id)
                                //                            }
                            }
                        }
                        //                        self.localThread = self.localThread.filter() { el in !selectedThreads.contains (el.valueForKey("id")! as! String) }
                        Engine.getThreads(self) { status, JSON in self.tv.reloadData(); }
                        Engine.deleteThreads(self, threadIds: selectedThreads) { status, JSON in
                            
                            Engine.getThreads(self)
                        }
                    })
                default: break;
                }
            }
        }
        
    }
    
    @IBAction func filter(sender: AnyObject) {
        let alert: UIAlertController = UIAlertController(title:"Select Filter", message: "Select how do you want to filter the chats.", preferredStyle: .ActionSheet)
        let act1: UIAlertAction = UIAlertAction(title:"All", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.tabBarController!.navigationItem.rightBarButtonItem?.title = "All";
            self.tv.reloadData();
        })
        alert.addAction(act1)
        let act2: UIAlertAction = UIAlertAction(title:"Groups", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.tabBarController!.navigationItem.rightBarButtonItem?.title = "Groups";
            self.tv.reloadData();
        })
        alert.addAction(act2)
        let act3: UIAlertAction = UIAlertAction(title:"Orgs", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.tabBarController!.navigationItem.rightBarButtonItem?.title = "Orgs";
            self.tv.reloadData();
        })
        alert.addAction(act3)
        let act4: UIAlertAction = UIAlertAction(title:"Interests", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.tabBarController!.navigationItem.rightBarButtonItem?.title = "Interests";
            self.tv.reloadData();
        })
        alert.addAction(act4)
        let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "Open Chat") {
            let cell = sender as! UITableViewCell;
            let indexPath = self.tv.indexPathForCell(cell)!;
            
            let selectedThread = self.clientData.getMyThreads()![indexPath.row]
            let chatVc = segue.destinationViewController as! ChatFlow
            
            let chatId = selectedThread.valueForKey("id")! as! String
            chatVc.initChat(indexPath.row, idThread: chatId, from: ChatFlow.From.OpenChat)
        }
        else if (segue.identifier == "NewGroups") {
            let flow = Flow.sharedInstance;
            flow.begin(.NewThread)
            flow.setCallback() { result in
                guard let title = result!["title"] as? String else { print ("FLOW: title not found"); return; }
                guard let desc = result!["desc"] as? String else { print ("FLOW: desc not found"); return; }
                guard let userIds = result!["userIds"] as? [Int] else { print ("FLOW: userIds not found"); return; }
                Engine.createGroupChat(self, name: title, description: desc, userId: userIds) { status, JSON in
                    if status == .Success && JSON != nil{
                        let dataJSON = JSON!["data"] as! Dictionary<String, AnyObject>
                        let threadJSON = dataJSON["message"] as! Dictionary<String, AnyObject>
                        let chatVc = Util.getViewControllerID("ChatFlow") as! ChatFlow
                        chatVc.initChat(0, idThread: threadJSON["id"] as! String, from: ChatFlow.From.CreateThread)
                        self.navigationController?.pushViewController(chatVc, animated: true)
                    }
                }
            }
            
        }
    }
    
    func setThreadLastMessage(row: Int) -> (String){
        var threadLastMessage = ""
        if let myThreads = clientData.getMyThreads(){
            if let myGroups = clientData.getGroups(){
                let group = myGroups.filter({ $0.thread != nil && $0.thread!.id == myThreads[row].id })
                if !group.isEmpty && group.first!.description != nil{
                    threadLastMessage = group.first!.description!
                }
            }
            if myThreads[row].messages != nil && !myThreads[row].messages!.isEmpty{
                threadLastMessage = myThreads[row].messages!.last!.message.text
            }
        }
        return threadLastMessage
    }
    
    func setLabelLastUpdated(thread: Thread) -> (String){
        let dateNow = NSDate().timeIntervalSince1970
        let dateMessage = thread.lastUpdated
        let rangeDate = dateNow - dateMessage
        let minutes = Int(rangeDate / 60)
        let hours = minutes / 60
        
        if minutes <= 60{
            if minutes < 2{ return "Just now" }else{ return "\(minutes) minutes ago" }
        }else{
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let components = calendar?.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
            let formatter : NSDateFormatter = {
                let tmpFormatter = NSDateFormatter()
                tmpFormatter.dateFormat = "y M d H m s"
                return tmpFormatter
            }()
            let string = "\(components!.year) \(components!.month) \(components!.day) 0 0 0"
            let range = dateMessage - formatter.dateFromString(string)!.timeIntervalSince1970
            if range < 0{
                if range < -60*60*24{
                    return Util.getDateFromTimestamp(dateMessage).date
                }else{
                    return "Yesterday"
                }
            }else{
                return "\(hours) hours ago"
            }
        }
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
    
    func updateTableView(){
        self.tv.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
    }
    
    @IBAction func countForUpdate(){
        timer = NSTimer(timeInterval: 2, target: self, selector: #selector(updateTableView), userInfo: nil, repeats: false)
    }
}