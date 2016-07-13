//
//  OrgActivities.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgActivities : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tv : UITableView!;
    
    var expanded : Array<Bool> = [];

    /*
    description original height: 66
    description maximum height without stretching the cell: 85
    */
    
    var oriDescHeight : CGFloat! = 66;
    var oriDescHeightMax : CGFloat! = 85;
    var oriBtnHeight : CGFloat! = 0;
    var expDescHeight : Array<CGFloat> = [];
    var oriCellHeight : CGFloat! = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oriDescHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(3) as! UILabel).height;
        oriBtnHeight = (tv.dequeueReusableCellWithIdentifier("cell")!.viewWithTag(10) as! UIButton).height;
        oriCellHeight = tv.dequeueReusableCellWithIdentifier("cell")!.height;
        
        expDescHeight = [];
        if (expanded.count == 0) {
            let cell = tv.dequeueReusableCellWithIdentifier("cell")!;
            let label = cell.viewWithTag(3)! as! UILabel;
            for i in 0...9 {
                //label.text = text[i]
                let perfectHeight = label.getPerfectHeight()
                expDescHeight.append(perfectHeight);
                if (perfectHeight < oriDescHeightMax) {
                    expanded.append(true);
                }
                else {
                    expanded.append(false);
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if expanded[indexPath.row] {
            let expandedHeight = oriCellHeight + expDescHeight[indexPath.row] - (oriDescHeight + oriBtnHeight);
            print ("Height for row \(indexPath.row): \(expandedHeight)");
            print ("oriCellHeight = \(oriCellHeight), expDescHeight = \(expDescHeight[0]), oriDescHeight = \(oriDescHeight), oriBtnHeight = \(oriBtnHeight)")
            return max(expandedHeight, oriCellHeight);
        }
        else {
            return oriCellHeight;
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
        
        let lblDesc = cell.viewWithTag(3)! as! UILabel;
        let btnExpand = cell.viewWithTag(10)! as! UIButton;
        if expanded[indexPath.row] {
            lblDesc.height = expDescHeight[indexPath.row];
//            lblDesc.heightToFit();
            print ("Description actual height: \(lblDesc.height)");
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
 
    @IBAction func expand (sender: AnyObject) {
        let btn = sender as! UIButton;
        let cell = btn.superview!.superview as! UITableViewCell;
        let lblDesc = cell.viewWithTag(3)! as! UILabel;
        let indexPath = tv.indexPathForCell(cell)!;
        // lblDesc.text = text[indexPath.row]

        expanded[indexPath.row] = true;
        expDescHeight[indexPath.row] = lblDesc.getPerfectHeight();
        tv.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        tv.reloadData();
    }

    
}