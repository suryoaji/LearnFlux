//
//  GroupDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/13/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class GroupDetails : UIViewController {
    
    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var logo : UIView!;
    let tabs = NSMutableArray();
    
    @IBOutlet var lblTitle : UILabel!;
    @IBOutlet var viewTitle : UIView!;
    
    var strTitle = "";
    var colorTitle = UIColor.clearColor();
    
    var group : Group?;
    
    
    func initFromCall(groupInfo : Group) {
        group = groupInfo;
        self.strTitle = groupInfo.name!;
        self.colorTitle = groupInfo.color;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        tabs.addObject(Util.getViewControllerID("OrgGroups"))
//        tabs.addObject(Util.getViewControllerID("OrgEvents"))
//        tabs.addObject(Util.getViewControllerID("OrgActivities"))
        tabs.addObject(Util.getViewControllerID("GroupProfile"))
        tabs.addObject(Util.getViewControllerID("OrgEvents"))
        tabs.addObject(Util.getViewControllerID("OrgActivities"))
        
        changeView(0);
        (tabs[0] as! GroupProfile).initFromCall(group!);
        
        self.title = "Details";
        self.lblTitle.text = self.strTitle.uppercaseString;
        self.viewTitle.backgroundColor = colorTitle;
    }
    
    func changeView (index : Int) {
//        (tabs[0] as! OrgGroups).view.removeFromSuperview();
//        (tabs[1] as! OrgEvents).view.removeFromSuperview();
//        (tabs[2] as! OrgActivities).view.removeFromSuperview();
        (tabs[0] as! GroupProfile).view.removeFromSuperview();
        (tabs[1] as! OrgEvents).view.removeFromSuperview();
        (tabs[2] as! OrgActivities).view.removeFromSuperview();
        
        let vc = tabs[index];
        self.view.addSubview(vc.view);
        vc.view.frame = self.view.viewWithTag(50)!.frame;
        print (vc.view.frame);
        self.view.bringSubviewToFront(vc.view);
        
        UIView.animateWithDuration(0.3) {
            self.viewSelection.x = self.viewTabs.x + 70 * CGFloat(index);
            self.viewSelection.y = self.viewTabs.y + self.viewTabs.height - self.viewSelection.height;
        }
    }
    
    @IBAction func changeViewAction (sender: AnyObject) {
        let btn = sender as! UIButton;
        let idx = btn.tag - 100;
        changeView(idx);
    }
}