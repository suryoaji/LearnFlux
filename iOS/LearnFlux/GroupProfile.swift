//
//  GroupProfile.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/14/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class GroupProfile : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lblOriHeight : CGFloat! = 0;
    var cellOriHeight : CGFloat! = 0;
    var cellPadHeight : CGFloat! = 0;
    @IBOutlet var tv : UITableView!;
    
    let dummyDesc = "Art Consultant, Art Writer/Reviewer, Art Dealer, Art Conservator and Restorer, Art Teacher/Educator, Museum Researcher, Gallery/Museum Managers, Illustrator, Model and Prop Maker, Painter, Printmaker and more.";
    let dummyDuration = "Duration: 3 years";
    let dummyMode = "Full Time";
    let dummyDesc2 = "The study of Fine Arts is a process of continual debate and questioning; of exploring and interrogating set perspectives. This programme situates itself at the crossroads of contemporary Western and Asian cultures, acknowledging the demands of different worldviews. It unites specialised areas, from traditional disciplines to newer art forms, providing wider options of expression relevant to the global evolution of fine arts."
    
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
        case 0, 3:
            let cell = tv.dequeueReusableCellWithIdentifier("basic")!;
            let lbl = cell.viewWithTag(1)! as! UILabel;
            lbl.text = indexPath.row == 0 ? dummyDesc : dummyDesc2;
            lbl.heightToFit();
            return lbl.height;
        case 1...2:
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
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Course Duration";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyDuration;
            desc.heightToFit();
            return cell;
        case 2:
            let cell = tv.dequeueReusableCellWithIdentifier("rightdetail")!;
            let title = cell.viewWithTag(1)! as! UILabel; title.text = "Mode";
            let desc = cell.viewWithTag(2)! as! UILabel; desc.text = dummyMode;
            desc.heightToFit();
            return cell;
        case 3:
            let cell = tv.dequeueReusableCellWithIdentifier("basic")!;
            let lbl = cell.viewWithTag(1)! as! UILabel;
            lbl.text = dummyDesc2;
            lbl.heightToFit();
            return cell;
        default:
            return tv.dequeueReusableCellWithIdentifier("toolbar")!;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
    
    
}