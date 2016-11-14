//
//  OrgDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AZDropdownMenu

@objc protocol PushDelegate {
    func pushViewController (viewController: UIViewController, animated: Bool);
}

@objc protocol RefreshDelegate {
    func refreshData (callback : (()->Void)?);
}

class OrgDetails: UIViewController, PushDelegate, RefreshDelegate {
    let clientData = Engine.clientData
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var viewMenu : UIView!;
    @IBOutlet var logo : UIView!;
    @IBOutlet weak var scrollView: UIScrollView!
    var shouldSetOffsetScrollView: Bool = true
    weak var orgEventsDelegate : OrgEventsDelegate!
    @IBOutlet weak var orgImageViewLogo: UIImageView!
    
    @IBOutlet var lblTitle : UILabel!;
    
    var orgId : String = ""
    var orgTitle : String = ""{
        didSet{
            if lblTitle != nil{ lblTitle.text = orgTitle }
        }
    }
    var isAdmin: Bool = false{
        didSet{
            if orgEventsDelegate != nil{
                orgEventsDelegate.setIsAdminOrNot(isAdmin)
            }
            if isAdmin{
                let navItem = self.navigationItem;
                
                let right:UIBarButtonItem! = UIBarButtonItem();
                right.image = UIImage(named: "menu")
                navItem.rightBarButtonItem = right;
                right.action = #selector(self.showMenu);
                right.target = self;
            }else{
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    var orgData : Group?{
        didSet{
            if let orgData = orgData where !tabs.isEmpty{
                if let profileViewController = tabs[3] as? OrgProfile{
                    profileViewController.setOrganizationInfo(orgData)
                }
                self.isAdmin = orgData.isAdmin
            }
        }
    }
    
    var menu : AZDropdownMenu!;
    
    var tabs : Array<UIViewController> = []
    var indicatorViewShown : Int = 0{
        didSet{
            if indicatorViewShown == 1{
                NSNotificationCenter.defaultCenter().postNotificationName("OrgEventsShownNotification", object: self, userInfo: nil)
            }
        }
    }
    
    func getOrgDetail() -> (Group?){
        let filteredOrg = Engine.clientData.getGroups(.Organisation).filter({ $0.id == self.orgId })
        if !filteredOrg.isEmpty{
            return filteredOrg.first!
        }
        return nil
    }
    
    var timer = NSTimer()
    func timedRefreshData(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(refreshData2), userInfo: nil, repeats: false)
    }
    
    func refreshData2(){
        Engine.getGroupInfo(self, groupId: orgId) {[weak self] status, group in
            guard let s = self else{ return }
            s.orgData = group;
            s.propagateData();
            Util.mainThread() { s.updateView (); }
            s.timedRefreshData()
        }
    }

    func refreshData(callback: (() -> Void)?) {
        Engine.getGroupInfo(self, groupId: orgId) { status, group in
            self.orgData = group;
            self.propagateData();
            Util.mainThread() { self.updateView (); }
            if (callback != nil) { callback!(); }
            self.timedRefreshData()
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
            if let tab1 = tabs[1] as? OrgEvents{
                tab1.pushDelegate = self
            }
        }
        
    }
    
    func initView (orgId : String, orgTitle : String, indexTab: Int) {
        self.orgId = orgId
        self.orgTitle = orgTitle
        self.indicatorViewShown = indexTab
    }
    
    func updateView() {
        orgTitle = "";
        guard let data = orgData else { return; }
        orgTitle = data.name
        orgImageViewLogo.image = data.image ?? UIImage(named: "company1.png")
    }
    
    func setTabsWithController(){
        tabs.append(Util.getViewControllerID("OrgGroups"))
        tabs.append(Util.getViewControllerID("OrgEvents"))
        tabs.append(Util.getViewControllerID("OrgActivities"))
        tabs.append(Util.getViewControllerID("OrgProfile"))
        
        let orgEventsViewController = tabs[1] as! OrgEvents
        orgEventsDelegate = orgEventsViewController
        orgEventsDelegate.setIdGroupOfEvents(idGroup: orgId)
        orgEventsDelegate.setParentController(ParentEventController.OrgDetail)
    }
    
    func addTabsToScrollView(){
        if shouldSetOffsetScrollView{
            self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width * CGFloat(self.tabs.count), self.scrollView.bounds.height)
            for i in 0..<tabs.count{
                tabs[i].view.frame = CGRectMake(CGFloat(i) * scrollView.bounds.width, 0, scrollView.bounds.width, scrollView.bounds.height)
                self.scrollView.addSubview(tabs[i].view)
            }
            self.shouldSetOffsetScrollView = false
        }
    }
    
    func setIndicatorPosition(){
        self.viewSelection.x = self.viewTabs.x + CGFloat(self.indicatorViewShown) * self.viewTabs.width/3
        self.viewSelection.width = self.viewTabs.width / 3
    }
    
    func createScrollView(){
        self.setTabsWithController()
        self.addTabsToScrollView()
        self.setIndicatorPosition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createScrollView()
        self.changeView(indicatorViewShown)
        
        self.orgImageViewLogo.image = clientData.getGroups().filter({ $0.id == orgId }).first!.image ?? nil
        
        refreshData() {
            self.createScrollView()
            self.propagateData();
        }
        
        let menuTitle = ["Edit Organisation...", "Create Official Group...", "Manage Official Group..."];
        menu = AZDropdownMenu(titles: menuTitle)
        self.lblTitle.text = self.orgTitle
        
        self.headerView.layer.zPosition = 2
        self.scrollView.layer.zPosition = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("OrgDetailAppearNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if timer.valid{ timer.invalidate() }
        NSNotificationCenter.defaultCenter().postNotificationName("OrgDetailDisappearNotification", object: nil)
        orgEventsDelegate.removeSpecificNotification()
    }
    
    deinit{
        orgEventsDelegate.removeAllNotification()
    }
    
    func changeView (index : Int) {
        if index == 3{
            self.scrollView.alpha = 0.0
            UIView.animateWithDuration(0.14, delay: 0, options: .CurveEaseInOut, animations: {
                self.viewSelection.alpha = 0.0
                }, completion: nil)
            UIView.animateWithDuration(0.7, delay: 0.14, options: .CurveEaseInOut, animations: {
                self.scrollView.alpha = 1.0
                }, completion: nil)
        }else{
            self.viewSelection.alpha = 1.0
        }
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
                if self.indicatorViewShown == 0{
                    self.menuCreateNewGroupTapped()
                }else if self.indicatorViewShown == 1{
                    self.menuCreateNewEventTapped()
                }else{
                    self.menuCreateNewActivityTapped()
                }
                break;
            default: break;
            }
        }
    }
    
    let flow = Flow.sharedInstance;
    func menuCreateNewEventTapped(){
        flow.begin(.NewEvent)
        flow.add(dict: ["reference"    : ["id" : self.orgId,
                                          "type" : "organization"]])
        flow.setCallback { result in
            self.handleRequest(self.flow.activeFlow()!, param: result!)
        }
        self.navigationController?.pushViewController(Util.getViewControllerID("AttachEvent"), animated: true)
    }

    func menuCreateNewGroupTapped(){
        flow.begin(.NewGroup);
        flow.add(dict: ["parentId": (self.orgData?.id)!]);
        flow.setCallback() { result in
            self.handleRequest(self.flow.activeFlow()!, param: result!)
        }
        self.navigationController?.pushViewController(Util.getViewControllerID("NewGroups"), animated: true);
    }
    
    func menuCreateNewActivityTapped(){
        print("creating New Activity Tapped")
    }
    
    func handleRequest(type: FlowName, param: Dictionary<String, AnyObject>){
        if type == FlowName.NewGroup{
            handleRequestCreateGroup(param)
        }else if type == FlowName.NewEvent{
            handleRequestCreateEvent(param)
        }
    }
    
    func handleRequestCreateGroup(param: Dictionary<String, AnyObject>?){
        guard let title = param!["title"] as? String else { print ("FLOW: title not found"); return; }
        guard let desc = param!["desc"] as? String else { print ("FLOW: desc not found"); return; }
        guard let userIds = param!["userIds"] as? [Int] else { print ("FLOW: userId not found"); return; }
        let parentId = param!["parentId"] as? String;
        Engine.createGroup(self, type:"group", title: title, desc: desc, userId: userIds, parentId:parentId) { status, JSON in
            Util.mainThread() {
                if status == .Success{
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
    
    func handleRequestCreateEvent(param: Dictionary<String, AnyObject>){
        Engine.createEvent(param)
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