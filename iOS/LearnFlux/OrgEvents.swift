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
    var expDescHeight : Array<CGFloat> = [];
    
    
    @IBOutlet var tv : UITableView!;
    
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        while (attendance.count < 10) {
            attendance.append("Going");
            expanded.append(false);
            let cell = tv.dequeueReusableCellWithIdentifier("cell")!;
            let label = cell.viewWithTag(3)! as! UILabel;
            //label.text =
            expDescHeight.append(Util.labelPerfectHeight(label));
        }
        return 10;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        if expanded[indexPath.row] {
            let expandedHeight = cell.height + expDescHeight[indexPath.row] - (oriDescHeight + oriBtnHeight);
            return expandedHeight;
        }
        else {
            return cell.height;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!;
        
        let viewCal = cell.viewWithTag(20)!;
//        let lblMonth = cell.viewWithTag(21)! as! UILabel;
//        let lblDay = cell.viewWithTag(22)! as! UILabel;
//        let lblYear = cell.viewWithTag(23)! as! UILabel;
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
            lblDesc.height = Util.labelPerfectHeight(lblDesc);
            btnExpand.hidden = true;
        }
        else {
            lblDesc.height = oriDescHeight;
            btnExpand.hidden = false;
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
        let indexPath = tv.indexPathForCell(cell)!;
        expanded[indexPath.row] = true;
        tv.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
}