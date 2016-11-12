//
//  OrgProfile.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/17/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgProfile : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lblOriHeight : CGFloat! = 0;
    var cellOriHeight : CGFloat! = 0;
    var cellPadHeight : CGFloat! = 0;
    @IBOutlet var tv : UITableView!;
    
    let dummyDesc = "Lasalle College of The Arts, formerly LASALLE-SIA College of The Arts, is a private arts educational institute in Singapore. LASALLE College of The Arts in partnership with Goldsmiths, University of London, provides tertiary arts education.";
    let dummyAddress = "9 Winstedt Rd\nSingapore 227976";
    let dummyHours = "0800 - 1700";
    let dummyPhone = "+65 6496 5000";
    let dummyEnrollment = "2,500 (2010)";
    let dummyFounded = "1984";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        lblOriHeight = (tv.dequeueReusableCellWithIdentifier("basic")!.viewWithTag(1)! as! UILabel).height;
        cellOriHeight = tv.dequeueReusableCellWithIdentifier("basic")!.height;
//        cellPadHeight = cellOriHeight - lblOriHeight;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated);
        tv.reloadData();
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tv.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            let cell = tv.dequeueReusableCellWithIdentifier("basic")!;
            let lbl = cell.viewWithTag(1)! as! UILabel;
            lbl.text = dummyDesc;
            lbl.heightToFit();
            return lbl.height;
        case 1:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let desc = cell.viewWithTag(2)! as! UILabel;
            desc.text = dummyAddress;
            desc.heightToFit();
            return desc.height;
        case 2...6:
            return cellOriHeight;
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let cell = tv.dequeueReusableCellWithIdentifier("basic")!;
            let lbl = cell.viewWithTag(1)! as! UILabel;
            lbl.text = dummyDesc;
            lbl.heightToFit();
            return cell;
        case 1:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Address";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyAddress;
            desc.heightToFit();
            return cell;
        case 2:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Hours";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyHours;
            desc.heightToFit();
            return cell;
        case 3:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Phone";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyPhone;
            desc.heightToFit();
            return cell;
        case 4:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Total Enrollment";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyEnrollment;
            desc.heightToFit();
            return cell;
        case 5:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Founded";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyFounded;
            desc.heightToFit();
            return cell;
        case 6:
            return tv.dequeueReusableCellWithIdentifier("toolbar")!;
        default:
            return tv.dequeueReusableCellWithIdentifier("toolbar")!;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
    
    
}