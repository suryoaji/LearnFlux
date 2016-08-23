//
//  GroupProfile.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/14/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class GroupProfile : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var groupDetailsDelegate: GroupDetailsDelegate?
    let clientData = Engine.clientData
    var lblOriHeight : CGFloat! = 0;
    var cellOriHeight : CGFloat! = 0;
    var cellPadHeight : CGFloat! = 0;
    @IBOutlet var tv : UITableView!;
    
    let dummyDesc = "Art Consultant, Art Writer/Reviewer, Art Dealer, Art Conservator and Restorer, Art Teacher/Educator, Museum Researcher, Gallery/Museum Managers, Illustrator, Model and Prop Maker, Painter, Printmaker and more.";
    let dummyDuration = "Duration: 3 years";
    let dummyMode = "Full Time";
    let dummyDesc2 = "The study of Fine Arts is a process of continual debate and questioning; of exploring and interrogating set perspectives. This programme situates itself at the crossroads of contemporary Western and Asian cultures, acknowledging the demands of different worldviews. It unites specialised areas, from traditional disciplines to newer art forms, providing wider options of expression relevant to the global evolution of fine arts."
    
    var group : Group?
    
    @IBAction func startConversationTapped(sender: UIButton) {
        if let groupDetailsDelegate = groupDetailsDelegate{
            if let group = group where group.thread != nil{
                if let threads = clientData.getMyThreads(){
                    let thread = threads.filter( { $0.id == group.thread!.id })
                    if !thread.isEmpty{
                        let index = threads.indexOf(thread.first!)
                        let vc = Util.getViewControllerID("ChatFlow") as! ChatFlow
                        vc.initChat(index!, idThread: thread.first!.id, from: .OpenChat)
                        groupDetailsDelegate.pushViewController(vc, animated: true)
                    }else{
                        let alert = UIAlertController(title: "", message: "Chat of this group has been deleted accidently, so the best way is just delete this group because this could make problems in future", preferredStyle: .Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        groupDetailsDelegate.presentViewController(alert, animated: true)
                    }
                }
            }else{
                let alert = UIAlertController(title: "", message: "Chat of this group has been deleted accidently, so the best way is just delete this group because this could make problems in future", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                groupDetailsDelegate.presentViewController(alert, animated: true)
            }
        }
    }
    
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
    
    func initFromCall (group : Group) {
        self.group = group;
        tv.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if group == nil { return 0; }
        return 7;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let data = group else { return 0; }
        switch (indexPath.row) {
        case 0, 3:
            guard let cell = tv.dequeueReusableCellWithIdentifier("basic") else { return 0; }
            guard let lbl = cell.viewWithTag(1) as? UILabel else { return 0; }
            lbl.text = indexPath.row == 0 ? data.description : "";
            lbl.heightToFit();
            return lbl.height + 10;
        case 1...2:
            return cellOriHeight;
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let data = group else { return tv.dequeueReusableCellWithIdentifier("basic")!; }
        switch (indexPath.row) {
        case 0:
            let cell = tv.dequeueReusableCellWithIdentifier("basic")!;
            let lbl = cell.viewWithTag(1)! as! UILabel;
            lbl.text = data.description;
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
            lbl.text = "";
            lbl.heightToFit();
            return cell;
        default:
            return tv.dequeueReusableCellWithIdentifier("toolbar")!;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
}