//
//  OrgDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgDetails : UIViewController {

    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var logo : UIView!;
    let tabs = NSMutableArray();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tabs.addObject(Util.getViewControllerID("OrgGroups"))
        tabs.addObject(Util.getViewControllerID("OrgEvents"))
        tabs.addObject(Util.getViewControllerID("OrgActivities"))
        tabs.addObject(Util.getViewControllerID("OrgProfile"))
        changeView(0);
    }
    
    func changeView (index : Int) {
        (tabs[0] as! OrgGroups).view.removeFromSuperview();
        (tabs[1] as! OrgEvents).view.removeFromSuperview();
        (tabs[2] as! OrgActivities).view.removeFromSuperview();
        (tabs[3] as! OrgProfile).view.removeFromSuperview();

        let vc = tabs[index];
        self.view.addSubview(vc.view);
        vc.view.frame = self.view.viewWithTag(50)!.frame;
        print (vc.view.frame);
        self.view.bringSubviewToFront(vc.view);
        
        UIView.animateWithDuration(0.3) {
            if (index == 3) {
                self.viewSelection.x = self.logo.x;
                self.viewSelection.y = self.logo.y + self.logo.height;
            }
            else {
                self.viewSelection.x = self.viewTabs.x + 70 * CGFloat(index);
                self.viewSelection.y = self.viewTabs.y + self.viewTabs.height - self.viewSelection.height;
            }
        }
    }
    
    @IBAction func changeViewAction (sender: AnyObject) {
        let btn = sender as! UIButton;
        let idx = btn.tag - 100;
        changeView(idx);
    }
}