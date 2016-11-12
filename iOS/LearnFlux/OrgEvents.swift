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

class OrgEvents : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dropDown = DropDown()
    var activeDropDown = -1;
    var attendance : Array<String> = [];
    var expanded : Array<Bool> = [];
    
    var oriDescHeight : CGFloat! = 0;
    var oriBtnHeight : CGFloat! = 0;
    var oriCellHeight : CGFloat! = 0;
    var expDescHeight : Array<CGFloat> = [];
    var holdView = UIView()
    var events : [Event]?
    
    @IBOutlet var tv : UITableView!;
    
    func loadEvents(target: UIViewController){
        holdView = UIView(frame: target.view.bounds)
        holdView.backgroundColor = UIColor(white: 0.93, alpha: 1.0)
        target.view.addSubview(holdView)
        Engine.getEvents(target){ status, JSON in
            self.events = Engine.getMyEvents()
            self.tv.reloadData()
        }
    }
    
    func viewShown(notification: NSNotification){
        if holdView.superview != nil && self.events != nil{
            if !self.events!.isEmpty{
                self.holdView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        dropDown.dataSource = ["Going", "Interested", "Not Going"];
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)")
            self.attendance[self.activeDropDown] = item;
            self.tv.reloadData();
        }
        oriDescHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(3) as! UILabel).height;
        oriBtnHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(10) as! UIButton).height;
        oriCellHeight = tv.dequeueReusableCellWithIdentifier("cell")!.height;
        
        while (attendance.count < 10) {
            attendance.append("Going");
            expanded.append(false);
            let cell = tv.dequeueReusableCellWithIdentifier("cell")!;
            let label = cell.viewWithTag(3)! as! UILabel;
            //label.text =
            expDescHeight.append(Util.labelPerfectHeight(label));
        }
        
        self.loadEvents(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(viewShown), name: "OrgEventsShownNotification", object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events != nil ? self.events!.count : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        if expanded[indexPath.row] {
            let expandedHeight = cell.height + expDescHeight[indexPath.row] - (oriDescHeight + oriBtnHeight);
            return max(expandedHeight, oriCellHeight);
        }
        else {
            return oriCellHeight;
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
        
        if events != nil{
            let lblTitle = cell.viewWithTag(1) as! UILabel
            let lblDay = cell.viewWithTag(22) as! UILabel
            let lblMonth = cell.viewWithTag(21) as! UILabel
            let lblYear = cell.viewWithTag(23) as! UILabel
            let lblHour = cell.viewWithTag(24) as! UILabel
            lblTitle.text = "\(events![indexPath.row].type)"
            
            lblMonth.text = Util.getSmallStringMonth(Util.getElementDate(.Month, stringDate: events![indexPath.row].time)!)
            lblDay.text = "\(Util.getElementDate(.Day, stringDate: events![indexPath.row].time)!)"
            lblYear.text = "\(Util.getElementDate(.Year, stringDate: events![indexPath.row].time)!)"
            lblHour.text = "\(Util.getElementDate(.Hour, stringDate: events![indexPath.row].time)!):\(Util.getElementDate(.Minute, stringDate: events![indexPath.row].time)!)"
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
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
    
}