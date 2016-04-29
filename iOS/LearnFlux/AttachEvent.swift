//
//  AttachEvent.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/25/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class AttachedEvent : NSObject {
    var title: String
    var date: String;
    var time: String;
    var duration: Int;
    var location: String
    
    init (vtitle : String, vdate : String, vtime : String, vduration : Int, vlocation : String) {
        title = vtitle;
        date = vdate;
        time = vtime;
        duration = vduration;
        location = vlocation;
        super.init();
    }
}

//func encode<AttachedEvent>(var value: AttachedEvent) -> NSData {
//    return withUnsafePointer(&value) { p in
//        NSData(bytes: p, length: sizeofValue(AttachedEvent))
//    }
//}
//
//func decode<AttachedEvent>(data: NSData) -> AttachedEvent {
//    let pointer = UnsafeMutablePointer<AttachedEvent>.alloc(sizeof(AttachedEvent.Type))
//    data.getBytes(pointer, length: sizeofValue(AttachedEvent))
//    
//    return pointer.move()
//}

protocol AttachEventReturnDelegate {
    func sendSelectedEventData (event: AttachedEvent);
}

class AttachEvent : UITableViewController {
    
    var delegate : AttachEventReturnDelegate!;
    
    var chosenDate = NSDate();
    var chosenTime = NSDate();
    var chosenTitle : String = "";
    var chosenDuration : Int = 60;
    
    var events = [AttachedEvent]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSStringFromClass(self.dynamicType));

        events.append(AttachedEvent(vtitle: "How to Stand Out in the College Admissions Process", vdate: "Tuesday, 3 May 2016", vtime: "19:30", vduration: 120, vlocation: "The Meeting Point - Behind Block 79 (Launchpad) Ayer Rajah Crescen, Tel 92471912, Singapore 139951, Singapore"));
        events.append(AttachedEvent(vtitle: "QUT Creative Industries Workshop: The 7 Attributes of a Great Designer", vdate: "Wednesday, 4 May 2016", vtime: "18:00", vduration: 90, vlocation: "AUG Singapore - 7 Maxwell Road, MND Complex Annex B, #02-100, Singapore, 069111, Singapore"));
        events.append(AttachedEvent(vtitle: "What is STEM and Why Should I Care", vdate: "Saturday, 30 April 2016", vtime: "10:00", vduration: 90, vlocation: "Dreamkids Kindergarten @ East Gate - 46 East Coast Rd #01-03, East Gate, Singapore, Singapore 428766, Singapore"));
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            case 1: return 4;
            case 2: return 3;
            default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            code = "2-0";
        }
        print (code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        cell.setSeparatorType(CellSeparatorFull);
        
        if (indexPath.section == 2) {
            let title = cell.viewWithTag(1) as! UILabel;
            let date = cell.viewWithTag(2) as! UILabel;
            let location = cell.viewWithTag(3) as! UILabel;
            let event = events[indexPath.row];
            title.text = event.title;
            date.text = event.date + ", " + event.time + "(\(event.duration))";
            location.text = event.location;
        }
        
        return cell;
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 1: return "Create new event";
        case 2: return "Or select from existing event:"
        default: return "";
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if (indexPath.section == 1) {
            switch (indexPath.row) {
            case 1: beginDateEdit(nil); break;
            case 2: beginTimeEdit(nil); break;
            default:
                break;
            }
        }
        
        if (indexPath.section == 2) {
            delegate.sendSelectedEventData(events[indexPath.row]);
            self.navigationController?.popViewControllerAnimated(true);
        }
    }
    
    @IBAction func beginDateEdit (sender: AnyObject?) {
        self.globalResignFirstResponder();
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) { (date) -> Void in
            self.chosenDate = date;
        }
    }
    
    @IBAction func beginTimeEdit (sender: AnyObject?) {
        self.globalResignFirstResponder();
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) { (date) -> Void in
            self.chosenTime = date;
        }
    }
    
    @IBAction func beginDurationEdit (sender: AnyObject?) {
        self.globalResignFirstResponder();
        
        let alert: UIAlertController = UIAlertController(title:"Select Duration", message: "How long the event will be?", preferredStyle: .ActionSheet)
        
        let act1: UIAlertAction = UIAlertAction(title:"30 mins", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 30;
            self.tableView.reloadData();
        })
        alert.addAction(act1)
        let act2: UIAlertAction = UIAlertAction(title:"1 hour", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 60;
            self.tableView.reloadData();
        })
        alert.addAction(act2)
        let act3: UIAlertAction = UIAlertAction(title:"1.5 hour", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 90;
            self.tableView.reloadData();
        })
        alert.addAction(act3)
        let act4: UIAlertAction = UIAlertAction(title:"2 hours", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 120;
            self.tableView.reloadData();
        })
        alert.addAction(act4)
        let act5: UIAlertAction = UIAlertAction(title:"3 hours", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 180;
            self.tableView.reloadData();
        })
        alert.addAction(act5)
        let act6: UIAlertAction = UIAlertAction(title:"3 hours+", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 180;
            self.tableView.reloadData();
        })
        alert.addAction(act6)
        let act7: UIAlertAction = UIAlertAction(title:"Unspecified", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.chosenDuration = 0;
            self.tableView.reloadData();
        })
        alert.addAction(act7)
        let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}