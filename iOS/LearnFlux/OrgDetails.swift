//
//  OrgDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

protocol PushDelegate {
    func pushViewController (viewController: UIViewController, animated: Bool);
}

class OrgDetails: UIViewController, PushDelegate{
    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var logo : UIView!;
    @IBOutlet weak var scrollView: UIScrollView!
    var tabs : Array<UIViewController> = []
    var indicatiorViewShown : Int = 0{
        didSet{
            if indicatiorViewShown == 1{
                NSNotificationCenter.defaultCenter().postNotificationName("OrgEventsShownNotification", object: self, userInfo: nil)
            }
        }
    }
    
    func setTabsWithController(){
        tabs.append(Util.getViewControllerID("OrgGroups"))
        tabs.append(Util.getViewControllerID("OrgEvents"))
        tabs.append(Util.getViewControllerID("OrgActivities"))
//        tabs.append(Util.getViewControllerID("OrgProfile"))
        
        (tabs[0] as! OrgGroups).pushDelegate = self;
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
        self.createScrollView()
        self.title = "Details"
        
    }
    
    func changeView (index : Int) {
        UIView.animateWithDuration(0.14, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.scrollView.setContentOffset(CGPointMake(CGFloat(index) * self.scrollView.bounds.width, 0), animated: false)
            }, completion: { bool in
                self.indicatiorViewShown = Int(self.scrollView.contentOffset.x) / Int(self.scrollView.width)
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
}

extension OrgDetails: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView){
        self.viewSelection.x = self.viewTabs.x + scrollView.contentOffset.x / scrollView.width * viewTabs.width / 3
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        self.indicatiorViewShown = Int(scrollView.contentOffset.x) / Int(scrollView.width)
    }
}