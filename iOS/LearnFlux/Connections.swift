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
    let connect = [
        ["name":"admin", "id":6],
        ["name":"tester", "id":7],
        ["name":"tester2", "id":8],
        ["name":"tiatiatia", "id":60]
    ];
    var actualConnect = Array<AnyObject>();
    var selectedConnect : Array<Bool> = [];
    let flow = Flow.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let item = UIBarButtonItem();
        item.image = UIImage(named: "menu-1.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        for myConnect in connect {
            if (myConnect["id"] != (Engine.clientData.defaults.valueForKey("me")!.valueForKey("id")! as! Int)) {
                actualConnect.append(myConnect);
                selectedConnect.append(false);
            }
        }
        
        self.tabBarController?.title = "Connections";
        let flow = Flow.sharedInstance;
        
        if let activeFlow = flow.activeFlow() {
            if activeFlow == .NewGroup {
                self.title = "Invite Participants"
                setupDoneButton();
            }
            else if flow.activeFlow() == .NewThread {
                self.title = "Select Participants";
                setupDoneButton()
            }
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
                let el = connect[i] as NSDictionary;
                userId.append(el.valueForKey("id")! as! Int);
            }
        }
        flow.add(dict: ["userIds":userId]);
        if let activeFlow = flow.activeFlow() where activeFlow == .NewGroup ||
                                                    activeFlow == .NewThread ||
                                                    activeFlow == .NewInterestGroup{
            flow.end(self, andClear: true)
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
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("1-0")!;
        cell.setSeparatorType(CellSeparatorFull);
        let lbl = cell.viewWithTag(1) as! UILabel;
        let row = actualConnect[indexPath.row];
        lbl.text = row.valueForKey("name") as? String;
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
        
        if (flow.activeFlow() == .NewGroup || flow.activeFlow() == .NewThread) {
            selectedConnect[indexPath.row] = !selectedConnect[indexPath.row];
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None);
            buttonDoneShouldEnable()
        }
        else {
            let row = actualConnect[indexPath.row];
            var arrUserId = Array<Int>();
            arrUserId.append((row.valueForKey("id") as? Int)!)
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
            print (JSON);
            let data = JSON["data"]!;
            vc.chatId = data["id"] as! String;
        }
    }
}