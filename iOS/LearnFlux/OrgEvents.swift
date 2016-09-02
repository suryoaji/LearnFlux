//
//  OrgEvents.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import QuartzCore
import DropDown

@objc protocol OrgEventsDelegate {
    func setIdGroupOfEvents(idGroup idGroup: String)
    func setIsAdminOrNot(isAdmin: Bool)
    func removeAllNotification()
    func removeSpecificNotification()
    func setParentController(parent: ParentEventController)
}

@objc enum ParentEventController: Int{
    case OrgDetail
    case GroupDetail
    case None
}

class OrgEvents : UIViewController, UITableViewDelegate, UITableViewDataSource, OrgEventsDelegate {
    var pushDelegate : PushDelegate!
    var groupDetailsDelegate: GroupDetailsDelegate!
    
    var parentController : ParentEventController!
    let dropDown = DropDown()
    var activeDropDown = -1;
    var attendance : Array<String> = [];
    var expanded : Array<Bool> = []
    
    var oriDescHeight : CGFloat! = 0;
    var oriBtnHeight : CGFloat! = 0;
    var oriCellHeight : CGFloat! = 0;
    var expDescHeight : Array<CGFloat> = [];
    var holdView = UIView()
    let clientData = Engine.clientData
    var isAdmin: Bool = false
    var idGroup: String = ""{
        didSet{
            if !idGroup.isEmpty{
                Engine.getSpecificEventsByIdGroup(idGroup: idGroup){ status, JSON in
                    if status == .Success{
                        if self.tv != nil{
                            self.reloadData()
                        }
                    }
                }
            }
        }
    }
    var timer: NSTimer!
    
    @IBOutlet var tv : UITableView!;
    
    func loadEvents(target: UIViewController){
        holdView = UIView(frame: target.view.bounds)
        holdView.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        target.view.addSubview(holdView)
        Engine.getEvents(target){ status, JSON in
            
            self.reloadData()
            if let events = self.clientData.getMyEvents(){
                var countLoaded = 0
                for eachEvent in events{
                    Engine.getEventDetail(self, event: eachEvent){ status, JSON in
                        countLoaded += 1
                        if countLoaded >= events.count{
                            self.reloadData()
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func shouldRemoveHoldView(){
        if Engine.clientData.getMyEvents() != nil && self.holdView.superview != nil{
            self.holdView.removeFromSuperview()
        }
    }
    
    func viewShown(notification: NSNotification){
        if holdView.superview != nil && Engine.clientData.getMyEvents() != nil{
            if !self.clientData.getMyEvents()!.isEmpty{
                self.holdView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpDropDownLib()
        
        oriDescHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(3) as! UILabel).height;
        oriBtnHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(10) as! UIButton).height;
        oriCellHeight = tv.dequeueReusableCellWithIdentifier("cell")!.height;
        
        self.setTableViewData()

//        self.loadEvents(self)
        shouldRemoveHoldView()
        if self.parentController == .OrgDetail{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addObservers), name: "OrgDetailAppearNotification", object: nil)
        }else if self.parentController == .GroupDetail{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addObservers), name: "GroupDetailAppearNotification", object: nil)
        }
    }
    
    func setStatusEvent(event: Event)-> (String){
        switch event.status {
        case -1:
            return dropDown.dataSource[2]
        case 1:
            return dropDown.dataSource[1]
        case 2:
            return dropDown.dataSource[0]
        default:
            return "Please Choose"
        }
    }
    
    func setUpDropDownLib(){
        dropDown.dataSource = ["Going", "Interested", "Not Going"];
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownChoosen(index, item: item)
        }
    }
    
    func dropDownChoosen(index: Int, item: String){
        self.attendance[self.activeDropDown] = item
        self.tv.reloadData()
        
        var rowEvent : Int? = activeDropDown
        if clientData.getSpecificEventsByIdGroup(self.idGroup) != nil{
            Engine.updateStatusEvent(indexToRsvp(index), rowEvent: &rowEvent, specificGroup: self.idGroup)
        }else{
            Engine.updateStatusEvent(indexToRsvp(index), rowEvent: &rowEvent)
        }
    }
    
    func indexToRsvp(index: Int) -> (Int){
        switch index {
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
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(viewShown), name: "OrgEventsShownNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(countToReloadData), name: "SpecificEventsUpdateNotification", object: nil)
        reloadData()
    }
    
    func removeAllNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func removeSpecificNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "OrgEventsShownNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "SpecificEventsUpdateNotification", object: nil)
    }
    
    func reloadData(){
        self.setTableViewData()
        self.tv.reloadData()
    }
    
    func countToReloadData(){
        timer = NSTimer(timeInterval: 2, target: self, selector: #selector(reloadData), userInfo: nil, repeats: false)
    }
    
    func setTableViewData(){
        var sEvents : [Event] = []
        if let events = clientData.getSpecificEventsByIdGroup(self.idGroup){
            sEvents = events
        }else if let events = clientData.getMyEvents(){
            sEvents = events
        }
        attendance = Array(count: sEvents.count, repeatedValue: "")
        expanded = Array(count: sEvents.count, repeatedValue: false)
        expDescHeight = Array(count: sEvents.count, repeatedValue: 0.0)
        for i in 0..<sEvents.count{
            attendance[i] = self.setStatusEvent(sEvents[i])
            let cell = tv.dequeueReusableCellWithIdentifier("cell")!;
            let label = cell.viewWithTag(3)! as! UILabel;
            expDescHeight[i] = Util.labelPerfectHeight(label)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = clientData.getSpecificEventsByIdGroup(self.idGroup)?.count{
            return count
        }else if let count = clientData.getMyEvents()?.count{
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        if indexPath.row < expanded.count && expanded[indexPath.row] {
            let expandedHeight = cell.height + expDescHeight[indexPath.row] - (oriDescHeight + oriBtnHeight);
            return max(expandedHeight, oriCellHeight);
        }
        else {
            return oriCellHeight;
        }
    }
    
    func setViewDropdownState(viewDropdown: UIView, row: Int){
        let expandImageView = viewDropdown.viewWithTag(30) as! UIImageView
        var events = getEventsShown()
        
        if isCreatorOfEvent(events[row]){
            viewDropdown.userInteractionEnabled = false
            expandImageView.alpha = 0
            viewDropdown.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        }else{
            viewDropdown.userInteractionEnabled = true
            expandImageView.alpha = 1
            viewDropdown.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func getEventsShown() -> ([Event]){
        var events : [Event] = []
        if let eventsData = clientData.getSpecificEventsByIdGroup(self.idGroup){
            events = eventsData
        }else if let eventsData = clientData.getMyEvents(){
            events = eventsData
        }
        return events
    }
    
    func isCreatorOfEvent(event: Event) -> (Bool){
        let idCreatorEvent = event.by.userId
        if idCreatorEvent == clientData.cacheMe()!["id"] as? Int{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        
        let viewCal = cell.viewWithTag(20)!;
        viewCal.layer.borderColor = UIColor.blackColor().CGColor;
        viewCal.layer.borderWidth = 1;
        
        let viewDropdown = cell.viewWithTag(101)!;
        viewDropdown.makeViewRoundedRectWithCornerRadius(5);
        viewDropdown.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor;
        viewDropdown.layer.borderWidth = 1;
        setViewDropdownState(viewDropdown, row: indexPath.row)
        
        let lblAttendance = cell.viewWithTag(4)! as! UILabel;
        lblAttendance.text = attendance[indexPath.row];

        let lblDesc = cell.viewWithTag(3)! as! UILabel;
        let btnExpand = cell.viewWithTag(10)! as! UIButton;
        if expanded[indexPath.row] {
            lblDesc.height = expDescHeight[indexPath.row];
            btnExpand.hidden = true;
        }
        else {
            lblDesc.height = oriDescHeight;
            btnExpand.hidden = false;
        }
        
        let lblTitle = cell.viewWithTag(1) as! UILabel
        let lblDay = cell.viewWithTag(22) as! UILabel
        let lblMonth = cell.viewWithTag(21) as! UILabel
        let lblYear = cell.viewWithTag(23) as! UILabel
        let lblHour = cell.viewWithTag(24) as! UILabel
        let lblLocation = cell.viewWithTag(2) as! UILabel
        let btnEdit = cell.viewWithTag(14) as! UIButton
        let btnMessage = cell.viewWithTag(11) as! UIButton
        btnMessage.addTarget(self, action: #selector(btnMessageTapped), forControlEvents: .TouchUpInside)
        
        let events = getEventsShown()
        let event = events[indexPath.row]
        lblTitle.text = "\(event.title)"
        lblMonth.text = Util.getSmallStringMonth(Util.getElementDate(.Month, stringDate: event.time)!)
        lblDay.text = "\(Util.getElementDate(.Day, stringDate: event.time)!)"
        lblYear.text = "\(Util.getElementDate(.Year, stringDate: event.time)!)"
        lblHour.text = "\(Util.getElementDate(.Hour, stringDate: event.time)!):\(Util.getElementDate(.Minute, stringDate: event.time)!)"
        lblLocation.text = event.location
        lblDesc.text = event.details
        btnMessage.enabled = false
        if event.thread != nil{
            if let indexThread = events.indexOf({ $0.id == event.thread.id }){
                btnMessage.enabled = true
                btnMessage.layer.name = "\(indexThread)"
            }
        }
        
        if self.isCreatorOfEvent(event){
            btnEdit.alpha = 1
            btnEdit.userInteractionEnabled = true
        }else{
            btnEdit.alpha = 0
            btnEdit.userInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
    @IBAction func btnMessageTapped(sender: UIButton){
        let indexThread = Int(sender.layer.name!)!
        let vc = Util.getViewControllerID("ChatFlow") as! ChatFlow
        vc.initChat(indexThread, idThread: clientData.getMyThreads()![indexThread].id, from: .OpenChat)
        if pushDelegate != nil{
            pushDelegate.pushViewController(vc, animated: true)
        }else if groupDetailsDelegate != nil{
            groupDetailsDelegate.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func dropDownGoing (sender: AnyObject) {
        let btn = sender as! UIButton;
        
        let cell = btn.superview!.superview!.superview!.superview as! UITableViewCell;
        activeDropDown = tv.indexPathForCell(cell)!.row;
        
        dropDown.anchorView = btn;
        dropDown.show()
        
    }
    
    @IBAction func expand (sender: AnyObject) {
        let btn = sender as! UIButton;
        let cell = btn.superview!.superview as! UITableViewCell;
        let lblDesc = cell.viewWithTag(3)! as! UILabel;
        let indexPath = tv.indexPathForCell(cell)!;
        // lblDesc.text = text[indexPath.row]

        expanded[indexPath.row] = true;
        expDescHeight[indexPath.row] = lblDesc.getPerfectHeight();
       tv.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func setIdGroupOfEvents(idGroup idGroup: String){
        self.idGroup = idGroup
    }
    
    func setIsAdminOrNot(isAdmin: Bool){
        self.isAdmin = isAdmin
    }
    
    func setParentController(parent: ParentEventController){
        self.parentController = parent
    }
}