//
//  Connections.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Connections : UITableViewController {
    
    let connect = [
        ["name":"admin", "id":6],
        ["name":"tester", "id":7],
        ["name":"tester2", "id":8]
    ];
    
    var connect2 = Array<AnyObject>();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "hamburger-18.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        for myConnect in connect {
            if (myConnect["id"] != (Data.defaults.valueForKey("me")!.valueForKey("id")! as! Int)) {
                connect2.append(myConnect);
            }
        }
        
        self.tabBarController?.title = "Connections";
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return connect2.count;
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
        let row = connect2[indexPath.row];
        lbl.text = row.valueForKey("name") as? String;
        let img = cell.viewWithTag(10) as! UIImageView;
        img.makeRounded();
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        let row = connect2[indexPath.row];
        var arrUserId = Array<Int>();
        arrUserId.append((row.valueForKey("id") as? Int)!)
        Engine.createThread(self, userId: arrUserId) { status, JSON in
            if (JSON != nil) {
                dispatch_async(dispatch_get_main_queue()) {
    //                self.performSegueWithIdentifier("InitiateChat", sender: JSON);
                    let vc = Util.getViewControllerID("ChatFlow") as! ChatFlow;
    //                let JSON = sender as! Dictionary<String, AnyObject>
                    let data = JSON!["data"]!!;
                    print (data);
                    vc.chatId = data["id"] as! String;
                    let me = Data.defaults.valueForKey("me")!;
                    vc.senderId = String(me.valueForKey("id")!);
                    vc.senderDisplayName = "";
                    vc.participants = data["participants"] as! [Dictionary<String,AnyObject>];
                    vc.thisChatType = "chat";
                    vc.thisChatMetadata = ["title":"User ID = " + String(arrUserId[0])];
                    self.navigationController?.pushViewController(vc, animated: true);
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "InitiateChat") {
            let vc = segue.destinationViewController as! ChatFlow;
            let JSON = sender as! Dictionary<String, AnyObject>
            print (JSON);
            let data = JSON["data"]!;
            vc.chatId = data["id"] as! String;
            vc.participantsId = data["participants"] as! [Dictionary<String,Int>];
        }
    }
}