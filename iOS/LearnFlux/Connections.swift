//
//  Connections.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Connections : UITableViewController {
    
    var buttonDone : UIBarButtonItem!
    var connect = [User(dict: ["id" : 6, "first_name" : "admin"]),
                  User(dict: ["id" : 7, "first_name" : "tester"]),
                  User(dict: ["id" : 8, "first_name" : "tester2"]),
                  User(dict: ["id" : 60, "first_name" : "tiatiatia"])]
    var actualConnect = Array<User>()
    var selectedConnect : Array<Bool> = [];
    let flow = Flow.sharedInstance
    let clientData = Engine.clientData
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let item = UIBarButtonItem();
        item.image = UIImage(named: "menu-1.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        for user in connect {
            if (user.userId! != (Engine.clientData.defaults.valueForKey("me")!.valueForKey("id")! as! Int)) {
                actualConnect.append(user)
                selectedConnect.append(false)
            }
        }
        
        self.tabBarController?.title = "Connections";
        let flow = Flow.sharedInstance;
        
        if let activeFlow = flow.activeFlow() {
            if activeFlow == .NewGroup {
                self.title = "Invite Participants"
                setupDoneButton();
            }
            else if flow.activeFlow() == .NewThread || flow.activeFlow() == .NewInterestGroup{
                self.title = "Select Participants";
                setupDoneButton()
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateConnection()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateConnection), name: "ConnectionsUpdateNotification", object: self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func updateConnection(){
        if let connection = clientData.getMyConnection(){
            self.actualConnect = connection
            self.selectedConnect = Array(count: actualConnect.count, repeatedValue: false)
            self.tableView.reloadData()
        }
    }
    
    lazy var flowDirection : String! = "";
    lazy var flowData : NSMutableDictionary! = [:];
    
    func setupDoneButton () {
        buttonDone = UIBarButtonItem()
        buttonDone.title = "Done"
        buttonDone.action = #selector(self.buttonDoneTapped)
        buttonDone.target = self
        buttonDone.enabled = false
        self.navigationItem.rightBarButtonItem = buttonDone
    }
    
    func buttonDoneTapped(sender: UIBarButtonItem) {
        var userId : Array<Int> = [];
        for i in 0..<selectedConnect.count {
            if (selectedConnect[i]) {
                let el = connect[i]
                userId.append(el.userId!);
            }
        }
        flow.add(dict: ["userIds":userId]);
        if let activeFlow = flow.activeFlow() where activeFlow == .NewGroup ||
                                                    activeFlow == .NewThread{
            flow.end(self, andClear: true)
        }else if let activeFlow = flow.activeFlow() where activeFlow == .NewInterestGroup{
            flow.end()
        }
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return actualConnect.count;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier("1-0")!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("1-0")!;
        cell.setSeparatorType(CellSeparatorFull);
        let lbl = cell.viewWithTag(1) as! UILabel;
        let user = actualConnect[indexPath.row];
        var name = "\(user.userId!)"
        if user.firstName != nil{
            name += " \(user.firstName!)"
        }
        lbl.text = name
        let img = cell.viewWithTag(10) as! UIImageView;
        img.makeRounded();
        
        if (selectedConnect[indexPath.row]) {
            cell.accessoryType = .Checkmark;
        }
        else {
            cell.accessoryType = .None;
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        let flow = Flow.sharedInstance;
        
        if (flow.activeFlow() == .NewGroup || flow.activeFlow() == .NewThread || flow.activeFlow() == .NewInterestGroup) {
            selectedConnect[indexPath.row] = !selectedConnect[indexPath.row];
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None);
            buttonDoneShouldEnable()
        }
        else {
            let user = actualConnect[indexPath.row];
            var arrUserId = Array<Int>();
            arrUserId.append(user.userId!)
            Engine.createGroupChat(self, userId: arrUserId) { status, JSON in
                if (JSON != nil) {
                    dispatch_async(dispatch_get_main_queue()) {
        //                self.performSegueWithIdentifier("InitiateChat", sender: JSON);
                        let vc = Util.getViewControllerID("ChatFlow") as! ChatFlow;
        //                let JSON = sender as! Dictionary<String, AnyObject>
                        let data = JSON!["data"]!!;
                        print (data);
                        vc.chatId = data["id"] as! String;
                        let me = Engine.clientData.defaults.valueForKey("me")!;
                        vc.senderId = String(me.valueForKey("id")!);
                        vc.senderDisplayName = "";
//                        vc.participants = Participant.convertFromArr(data["participants"])!;
                        vc.thisChatType = "chat";
                        vc.thisChatMetadata = ["title":"User ID = " + String(arrUserId[0])];
                        self.navigationController?.pushViewController(vc, animated: true);
                    }
                }
            }
        }
    }
    
    func buttonDoneShouldEnable(){
        buttonDone.enabled = !selectedConnect.isEmpty ? !selectedConnect.filter({ $0==true }).isEmpty ? true : false : false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "InitiateChat") {
            let vc = segue.destinationViewController as! ChatFlow;
            let JSON = sender as! Dictionary<String, AnyObject>
            let data = JSON["data"]!;
            vc.chatId = data["id"] as! String;
        }
    }
}