//
//  AttachEvent.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/25/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

protocol AttachEventReturnDelegate: class {
    func sendSelectedEventData (event: Dictionary<String, AnyObject>);
}

class AttachEvent : UITableViewController, UITextFieldDelegate {
    
    weak var delegate : AttachEventReturnDelegate!
    let flow = Flow.sharedInstance
    
    var stringDate: String!
    var chosenDate : NSDate!{
        didSet{
            checkAddOrRemoveRightBarButton()
            self.tableView.reloadData()
            let formatter : NSDateFormatter = {
                let tmpFormatter = NSDateFormatter()
                tmpFormatter.dateFormat = "EEEE, d MMMM y"
                return tmpFormatter
            }()
            self.stringDate = formatter.stringFromDate(chosenDate)
        }
    }
    
    var chosenTime : NSDate!{
        didSet{
            checkAddOrRemoveRightBarButton()
            self.tableView.reloadData()
        }
    }
    var chosenTitle : String = ""{
        didSet{
            checkAddOrRemoveRightBarButton()
        }
    }
    var chosenDuration : Int!{
        didSet{
            checkAddOrRemoveRightBarButton()
            self.tableView.reloadData()
        }
    }
    var chosenLocation : String = ""{
        didSet{
            checkAddOrRemoveRightBarButton()
        }
    }
    
    var events : Array<Dictionary<String, AnyObject>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(NSStringFromClass(self.dynamicType));
        events.append(["title": "How to Stand Out in the College Admissions Process", "date": "Tuesday, 3 May 2020", "time": "19:30", "duration": 120, "location": "The Meeting Point - Behind Block 79 (Launchpad) Ayer Rajah Crescen, Tel 92471912, Singapore 139951, Singapore"]);
        events.append(["title": "QUT Creative Industries Workshop: The 7 Attributes of a Great Designer", "date": "Wednesday, 4 May 2020", "time": "18:00", "duration": 90, "location": "AUG Singapore - 7 Maxwell Road, MND Complex Annex B, #02-100, Singapore, 069111, Singapore"]);
        events.append(["title": "What is STEM and Why Should I Care", "date": "Saturday, 30 April 2020", "time": "10:00", "duration": 90, "location": "Dreamkids Kindergarten @ East Gate - 46 East Coast Rd #01-03, East Gate, Singapore, Singapore 428766, Singapore"]);
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            case 1: return 4;
            case 2: return 3;
            default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let code = indexPath.code;
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        let height = cell.height;
        return height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            code = "2-0";
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        cell.setSeparatorType(CellSeparatorFull);
        
        switch indexPath.section {
        case 2:
            let labelTitle = cell.viewWithTag(1) as! UILabel;
            let labelDate = cell.viewWithTag(2) as! UILabel;
            let labelLocation = cell.viewWithTag(3) as! UILabel;
            let event = events[indexPath.row];
            if let date     = event["date"],
                let title    = event["title"],
                let time     = event["time"],
                let duration = event["duration"],
                let location = event["location"]{
                if let sDate = date as? String,
                    let sTitle = title as? String,
                    let sTime = time as? String,
                    let iDuration = duration as? Int,
                    let sLocation = location as? String{
                    labelTitle.text = sTitle
                    labelDate.text = sDate + ", " + sTime + "(\(iDuration))";
                    labelLocation.text = sLocation
                }
            }
            break
        case 1:
            switch indexPath.row {
            case 0:
                let textfieldEventTitle = cell.viewWithTag(1) as! UITextField
                textfieldEventTitle.text = self.chosenTitle
                textfieldEventTitle.addTarget(self, action: #selector(self.changeChosenTitle), forControlEvents: .EditingChanged)
                break
            case 1:
                let textfieldEventDate = cell.viewWithTag(1) as! UITextField
                if self.chosenDate != nil{
                    textfieldEventDate.text = Util.getDateFromTimestamp(self.chosenDate.timeIntervalSince1970).date
                }
                textfieldEventDate.userInteractionEnabled = false
                break
            case 2:
                let textfieldEventTime = cell.viewWithTag(1) as! UITextField
                let textfieldEventDuration = cell.viewWithTag(2) as! UITextField
                if self.chosenTime != nil{
                    textfieldEventTime.text = Util.getDateFromTimestamp(self.chosenTime.timeIntervalSince1970).time
                }
                if self.chosenDuration != nil{
                    textfieldEventDuration.text = String(self.chosenDuration)
                }
                textfieldEventTime.userInteractionEnabled = false
                break
            case 3:
                let textfieldEventLocation = cell.viewWithTag(1) as! UITextField
                textfieldEventLocation.text = self.chosenLocation
                textfieldEventLocation.addTarget(self, action: #selector(self.changeChosenLocation), forControlEvents: .EditingChanged)
                break
            default:
                break
            }
            break
        default:
            break
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
            case 1: beginDateEdit(nil)
            case 2: beginTimeEdit(nil)
            default:
                break;
            }
        }
        
        if (indexPath.section == 2) {
            self.sendBackParam(events[indexPath.row])
        }
    }
    
    func sendBackParam(param: Dictionary<String, AnyObject>){
        if let activeFlow = flow.activeFlow() where activeFlow == .NewEvent{
            if let param = Engine.paramForCreateEvent(param, idGroup: "", isOrganization: true){
                flow.add(dict: param)
                flow.end(andClear: true)
            }
        }else{
            delegate.sendSelectedEventData(param);
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func beginDateEdit (sender: AnyObject?) {
        self.e_globalResignFirstResponderRec(self.view)
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) { date in
            self.chosenDate = date;
        }
    }
    
    @IBAction func beginTimeEdit (sender: AnyObject?) {
        self.e_globalResignFirstResponderRec(self.view)
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) { date in
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
    
    @IBAction func rightBarButtonTapped(sender: UIBarButtonItem){
        let param : Dictionary<String, AnyObject> = ["title"    : self.chosenTitle,
                                                     "date"     : self.stringDate,
                                                     "time"     : Util.changeModelTime(self.chosenTime.timeIntervalSince1970),
                                                     "location" : self.chosenLocation,
                                                     "duration" : self.chosenDuration]
        self.sendBackParam(param)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        e_globalResignFirstResponderRec(self.view)
        return true
    }
    
    @IBAction func changeChosenTitle(sender: UITextField){
        self.chosenTitle = sender.text != nil ? sender.text! : ""
    }
    
    @IBAction func changeChosenLocation(sender: UITextField){
        self.chosenLocation = sender.text != nil ? sender.text! : ""
    }
    
    func checkAddOrRemoveRightBarButton(){
        if !self.chosenLocation.isEmpty && !self.chosenTitle.isEmpty && self.chosenDuration != nil && self.chosenTime != nil && self.chosenDate != nil{
            addRightBarButton()
        }else{
            removeRightBarButton()
        }
    }
    
    func addRightBarButton(){
        if self.navigationItem.rightBarButtonItem == nil{
            let rightBarButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(self.rightBarButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    func removeRightBarButton(){
        if self.navigationItem.rightBarButtonItem != nil{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}