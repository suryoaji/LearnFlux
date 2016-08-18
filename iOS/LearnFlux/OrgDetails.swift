//
//  OrgDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AZDropdownMenu

protocol PushDelegate {
    func pushViewController (viewController: UIViewController, animated: Bool);
}

protocol RefreshDelegate {
    func refreshData (callback : (()->Void)?);
}

class OrgDetails: UIViewController, PushDelegate, RefreshDelegate {
    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var viewMenu : UIView!;
    @IBOutlet var logo : UIView!;
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var lblTitle : UILabel!;
    
    var orgId : String = "";
    var orgTitle : String = "";
    
    var orgData : Group?;
    
    var menu : AZDropdownMenu!;
    
    var tabs : Array<UIViewController> = []
    var indicatorViewShown : Int = 0{
        didSet{
            if indicatorViewShown == 1{
                NSNotificationCenter.defaultCenter().postNotificationName("OrgEventsShownNotification", object: self, userInfo: nil)
            }
        }
    }
    

    
    func refreshData(callback: (() -> Void)?) {
        Engine.getGroupInfo(self, groupId: orgId) { status, group in
//            print (group);
            self.orgData = group;
            self.propagateData();
            Util.mainThread() { self.updateView (); }
            if (callback != nil) { callback!(); }
        }
    }
    
    func propagateData () {
        if tabs.count > 0 {
            if let tab0 = tabs[0] as? OrgGroups {
                tab0.initGroup (orgId);
                tab0.pushDelegate = self;
                tab0.refreshDelegate = self;
                if let data = orgData?.child { tab0.groups = data; }
                tab0.cv.reloadData();
            }
        }
        
    }
    
    func initView (orgId : String, orgTitle : String) {
        self.orgId = orgId;
        self.orgTitle = orgTitle;
    }
    
    func updateView() {
        lblTitle.text = "";
        guard let data = orgData else { return; }
        lblTitle.text = data.name;
    }
    
    func setTabsWithController(){
        tabs.append(Util.getViewControllerID("OrgGroups"))
        tabs.append(Util.getViewControllerID("OrgEvents"))
        tabs.append(Util.getViewControllerID("OrgActivities"))
        
        changeView(0);
    }
    
    func addTabsToScrollView(){
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width * CGFloat(self.tabs.count), self.scrollView.bounds.height)
        for i in 0..<tabs.count{
            tabs[i].view.frame = CGRectMake(CGFloat(i) * scrollView.bounds.width, 0, scrollView.bounds.width, scrollView.bounds.height)
            self.scrollView.addSubview(tabs[i].view)
        }
    }
    
    func setIndicatorPosition(){
        self.viewSelection.x = self.viewTabs.x
        self.viewSelection.width = self.viewTabs.width / 3
    }
    
    func createScrollView(){
        self.setTabsWithController()
        self.addTabsToScrollView()
        self.setIndicatorPosition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData() {
            self.createScrollView()
            self.propagateData();
        }
        self.title = "Details"
        
        let menuTitle = ["Edit Organisation...", "Create Official Group...", "Manage Official Group..."];
        menu = AZDropdownMenu(titles: menuTitle)
        
        let navItem = self.navigationItem;

        let right:UIBarButtonItem! = UIBarButtonItem();
        right.title = "Menu";
        navItem.rightBarButtonItem = right;
        right.action = #selector(self.showMenu);
        right.target = self;
        
//        viewMenu.y = 66;
    }
    
    func changeView (index : Int) {
        UIView.animateWithDuration(0.14, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.scrollView.setContentOffset(CGPointMake(CGFloat(index) * self.scrollView.bounds.width, 0), animated: false)
            }, completion: { bool in
                self.indicatorViewShown = Int(self.scrollView.contentOffset.x) / Int(self.scrollView.width)
        })
    }
    
    @IBAction func changeViewAction (sender: AnyObject) {
        let btn = sender as! UIButton;
        let idx = btn.tag - 100;
        changeView(idx);
    }
    
    func pushViewController(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        let privEditOrg = true;
        let privCreateGroup = true;
        let privDeleteGroup = true;
        let privCreateEvent = true;
        let privDeleteEvent = true;
        let privCreateActivity = true;
        let privDeleteActivity = true;
        
        var choices = [String]();
        var styles = [UIAlertActionStyle?]();
        
        if privEditOrg { choices.append("Edit this organisation"); styles.append (.Default); }
        if privCreateGroup && indicatorViewShown == 0 { choices.append("Create new group"); styles.append (.Default); }
        if privDeleteGroup && indicatorViewShown == 0 { choices.append("Delete multiple groups"); styles.append (.Destructive); }
        if privCreateEvent && indicatorViewShown == 1 { choices.append("Create new event"); styles.append (.Default); }
        if privDeleteEvent && indicatorViewShown == 1 { choices.append("Delete multiple events"); styles.append (.Destructive); }
        if privCreateActivity && indicatorViewShown == 2 { choices.append("Create new activity"); styles.append (.Default); }
        if privDeleteActivity && indicatorViewShown == 2 { choices.append("Delete multiple activities"); styles.append (.Default); }

        
        Util.showAlertMenu(self, title: "Menu", choices: choices, styles: styles, addCancel: true) { (selected) in
            switch (selected) {
            case 0: break;
            case 1:
                let flow = Flow.sharedInstance;
                flow.begin("NewGroup");
                flow.add(dict: ["parentId": (self.orgData?.id)!]);
                flow.setCallback() { result in
                    guard let title = result!["title"] as? String else { print ("FLOW: title not found"); return; }
                    guard let desc = result!["desc"] as? String else { print ("FLOW: desc not found"); return; }
                    guard let userIds = result!["userIds"] as? [Int] else { print ("FLOW: userId not found"); return; }
                    let parentId = result!["parentId"] as? String;
                    Engine.createGroup(self, type:"group", title: title, desc: desc, userId: userIds, parentId:parentId) { status, JSON in
                        Util.mainThread() {
                            if status == .Success{
//                                let group = Group.convertFromDict(JSON);
                                Util.mainThread() {
                                    self.navigationController?.popToViewController(self, animated: true);
                                    Engine.getGroupInfo(groupId: (self.orgData?.id)!) { status, group in
                                        self.orgData = group;
                                        self.propagateData();
                                    }
                                }
                            }
                        }
                    }
                }
                self.navigationController?.pushViewController(Util.getViewControllerID("NewGroups"), animated: true);
                break;
            default: break;
            }
        }
    }

    
    
}

extension OrgDetails: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView){
        self.viewSelection.x = self.viewTabs.x + scrollView.contentOffset.x / scrollView.width * viewTabs.width / 3
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        self.indicatorViewShown = Int(scrollView.contentOffset.x) / Int(scrollView.width)
    }
}