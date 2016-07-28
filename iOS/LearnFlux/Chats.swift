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
    
    //    @IBOutlet var navigationItem: UINavigationItem!;
    @IBOutlet var tv : UITableView!;
    
    var localThread : [Thread]? = Engine.clientData.getMyThreads()
    var menu : AZDropdownMenu!;
    @IBOutlet var viewMenu : UIView!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //        self.toolbarItems = self.parentViewController?.toolbarItems
        
        let menuTitle = ["Create Group Chat...", "Delete Chats...", "Delete All Chats"];
        menu = AZDropdownMenu(titles: menuTitle)
        updateThreadView();
        
        Engine.getThreads(self) { status, JSON in
            self.updateThreadView(JSON);
        }
        
        let navItem = self.parentViewController!.navigationItem;
        
        self.tabBarController?.title = "Chats";
        
        //        let left:UIBarButtonItem! = UIBarButtonItem();
        //        left.image = UIImage(named: "hamburger-18.png");
        //        navItem.leftBarButtonItem = left;
        //        left.action = #selector(self.revealMenu);
        //        left.target = self;
        
        let right:UIBarButtonItem! = UIBarButtonItem();
        right.title = "Menu";
        navItem.rightBarButtonItem = right;
        right.action = #selector(self.showMenu);
        right.target = self;
        
        self.navigationItem.rightBarButtonItem = right;
    }
    
    func updateThreadView (JSON : AnyObject? = nil) {
//        if (JSON == nil) {
//            if(Engine.clientData.defaults.valueForKey("threads") != nil) {
//                let threads = Engine.clientData.defaults.valueForKey("threads")!;
//                localThread =  threads as! Array<AnyObject>
//            }
//        }
//        else {
//            //            let data = JSON!.valueForKey("data")!;
//            self.localThread = JSON!["data"]! as! Array<AnyObject>;
//        }
        self.localThread = Engine.clientData.getMyThreads()
        self.tv.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setTabBarVisible(true, animated: true);
        
//        Engine.getThreads(self) { status, JSON in
//            self.updateThreadView(JSON);
//        }
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
        //        let threadLastUpdated = cell.viewWithTag(3) as! UILabel;
        threadLastMessage.text = "Description";
        let selectedThread = Engine.clientData.getMyThreads()![indexPath.row]
        threadName.text = Engine.generateThreadName(selectedThread);
        let pp = cell.viewWithTag(10) as! UIImageView;
        pp.makeRounded();
        return cell;
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        Util.showAlertMenu(self, title: "Menu", choices: ["Create Group Chat...", "Delete Chats...", "Delete All Chats"],
            styles: [.Default,.Destructive,.Destructive], addCancel: true) { (selected) in
                switch (selected) {
                case 0:
                    self.performSegueWithIdentifier("NewGroups", sender: self.menu);
                    break;
                case 1: break;
                case 2:
                    Util.showChoiceInViewController(self, title: "Confirmation", message: "Are you sure you want to erase all the chat threads?", buttonTitle: ["Yes", "Cancel"], buttonStyle: [UIAlertActionStyle.Destructive, UIAlertActionStyle.Cancel], callback: { selectedBtn in
                        var selectedThreads = Array<String>();
                        if (selectedBtn == 0) {
                            for thread in self.localThread! {
                                //                            if (selectedThreads.count < 1) {
                                selectedThreads.append(thread.id)
                                //                            }
                            }
                        }
//                        self.localThread = self.localThread.filter() { el in !selectedThreads.contains (el.valueForKey("id")! as! String) }
                        Engine.getThreads(self) { status, JSON in self.tv.reloadData(); }
                        Engine.deleteThreads(self, threadIds: selectedThreads) { status, JSON in
                            
                            Engine.getThreads(self) { status, JSON in self.updateThreadView(JSON); }
                        }
                    })
                default: break;
                }
        }
    }
    
//    @IBAction func showMenuOld(sender: AnyObject) {
//        if (menu.isDescendantOfView(tv) == true) {
//            menu.hideMenu()
//            self.view.bringSubviewToFront(tv);
//        } else {
//            menu.showMenuFromView(tv)
//            print (tv.frame);
//            self.view.bringSubviewToFront(viewMenu)
//        }
//        
//        menu.cellTapHandler = { [weak self] (indexPath: NSIndexPath) -> Void in
//            switch (indexPath.row) {
//            case 0:
//                self?.performSegueWithIdentifier("NewGroups", sender: self?.menu);
//                break;
//            case 1: break;
//            case 2:
//                Util.showChoiceInViewController(self, title: "Confirmation", message: "Are you sure you want to erase all the chat threads?", buttonTitle: ["Yes", "Cancel"], buttonStyle: [UIAlertActionStyle.Destructive, UIAlertActionStyle.Cancel], callback: { selectedBtn in
//                    var selectedThreads = Array<String>();
//                    if (selectedBtn == 0) {
//                        for thread in self!.localThread {
//                            let t = thread as! NSDictionary;
//                            //                            if (selectedThreads.count < 1) {
//                            selectedThreads.append(t.valueForKey("id") as! String)
//                            //                            }
//                        }
//                    }
//                    self!.localThread = self!.localThread.filter() { el in !selectedThreads.contains (el.valueForKey("id")! as! String) }
//                    Engine.getThreads(self) { status, JSON in self!.tv.reloadData(); }
//                    Engine.deleteThreads(self, threadIds: selectedThreads) { status, JSON in
//                        
//                        Engine.getThreads(self) { status, JSON in self!.updateThreadView(JSON); }
//                    }
//                })
//            default: break;
//            }
//        }
//    }
    
    @IBAction func filter(sender: AnyObject) {
        let alert: UIAlertController = UIAlertController(title:"Select Filter", message: "Select how do you want to filter the chats.", preferredStyle: .ActionSheet)
        let act1: UIAlertAction = UIAlertAction(title:"All", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "All";
            self.tv.reloadData();
        })
        alert.addAction(act1)
        let act2: UIAlertAction = UIAlertAction(title:"Groups", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Groups";
            self.tv.reloadData();
        })
        alert.addAction(act2)
        let act3: UIAlertAction = UIAlertAction(title:"Orgs", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Orgs";
            self.tv.reloadData();
        })
        alert.addAction(act3)
        let act4: UIAlertAction = UIAlertAction(title:"Interests", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Interests";
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
            
            let selectedThread = localThread![indexPath.row]
            let chatVc = segue.destinationViewController as! ChatFlow
            
            let chatId = selectedThread.valueForKey("id")! as! String
            chatVc.initChat(indexPath.row, idThread: chatId, from: ChatFlow.From.OpenChat)
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
    

}