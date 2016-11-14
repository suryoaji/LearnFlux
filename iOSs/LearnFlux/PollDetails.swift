//
//  PollDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/9/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class PollDetails : UITableViewController {
    
    var hideChoise = true
    
    var meta : Dictionary<String, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
        tableView.reloadData();
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 2: return hideChoise ? "" : "Choice"
        case 3: return "Available action";
        default: return "";
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = meta["data"] as! NSDictionary;
        let answers = data["answers"] as! [String];
        switch (section) {
        case 1: return 1;
        case 2: return answers.count;
        case 3: return 1;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            if hideChoise{
                return 0
            }else{
                code = "2-0";
            }
        }
        print (code);
        return tableView.dequeueReusableCellWithIdentifier(code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            code = "2-0";
        }
        print ("cell " + code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        cell.setSeparatorType(CellSeparatorFull);
        
        let data = meta["data"] as! NSDictionary;
        
        if (code == "1-0") {
            let lbl = cell.viewWithTag(1) as! UILabel;
            lbl.text = data.stringForKey("question");
            lbl.heightToFit();
        }
        else if (code == "2-0") {
            let answers = data["answers"] as! [String];
            let lbl = cell.viewWithTag(1) as! UILabel;
            lbl.text = answers[indexPath.row];
            lbl.heightToFit();
        }
        
        var selection = meta["selection"];
        if (selection == nil) {
            selection = "";
        }
        
        if (indexPath.section == 2) {
            if (selection! as! String == "\(indexPath.row)") {
                cell.accessoryType = .Checkmark;
            }
            else {
                cell.accessoryType = .None;
            }
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if (indexPath.section == 2) {
            meta["selection"] = "\(indexPath.row)"
            tableView.reloadData();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PollChat") {
            let vc = segue.destinationViewController as! ChatFlow;
            vc.senderId = "1"
            vc.senderDisplayName = "Jack Joyce"
            vc.thisChatType = "poll";
            vc.thisChatMetadata = meta;
        }
    }

}