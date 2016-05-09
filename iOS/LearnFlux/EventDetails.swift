//
//  EventDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/9/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class EventDetails : UITableViewController {
    
    var meta : NSMutableDictionary!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
        tableView.reloadData();
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 4: return "Your response";
        case 5: return "Available action";
        default: return "";
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 1;
        case 2: return 1;
        case 3: return 1;
        case 4: return 2;
        case 5: return 1;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let code = indexPath.code;
        print (code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        cell.setSeparatorType(CellSeparatorFull);
        
        let data = meta["data"] as! NSDictionary;

        if (code == "1-0") {
            let lbl = cell.viewWithTag(1) as! UILabel;
            lbl.text = data.stringForKey("title");
            lbl.heightToFit();
        }
        else if (code == "2-0") {
            let lbl = cell.viewWithTag(1) as! UILabel;
            lbl.text = data.stringForKey("date") + " at " + data.stringForKey("time");
            lbl.heightToFit();
        }
        else if (code == "3-0") {
            let lbl = cell.viewWithTag(1) as! UILabel;
            lbl.text = data.stringForKey("location");
            lbl.heightToFit();
        }
        
        var selection = meta["selection"];
        if (selection == nil) {
            selection = "";
        }
        
        if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                if (selection! as! String == "yes") {
                    cell.accessoryType = .Checkmark;
                }
                else {
                    cell.accessoryType = .None;
                }
            }
            else if (indexPath.row == 1) {
                if (selection! as! String == "no") {
                    cell.accessoryType = .Checkmark;
                }
                else {
                    cell.accessoryType = .None;
                }
            }
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if (indexPath.isEqualCode("4-0")) {
            meta.setValue("yes", forKey: "selection");
            tableView.reloadData();
        }
        else if (indexPath.isEqualCode("4-1")) {
            meta.setValue("no", forKey: "selection");
            tableView.reloadData();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventChat") {
            let vc = segue.destinationViewController as! ChatFlow;
            vc.senderId = "1"
            vc.senderDisplayName = "Jack Joyce"
            vc.thisChatType = "event";
            vc.thisChatMetadata = meta;
        }
    }
    
}