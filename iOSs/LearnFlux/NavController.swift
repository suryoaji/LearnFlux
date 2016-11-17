//
//  NavController.swift
//  LearnFlux
//
//  Created by ISA on 8/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    let flow = Flow.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.hidden = false
        self.navigationBar.barTintColor = LFColor.blue
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "PingFangHK-Medium", size: 18)!]
        self.navigationBar.tintColor = UIColor.whiteColor()
        if let rootViewController = self.topViewController as? NewHome{
            rootViewController.shouldPushAnimated = pushNewHomeControllerWithPushAnimated
        }
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if flow.isActive(){ flow.pushVc(viewController) }
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        if flow.isActive(){
            flow.popVc(self.viewControllers.last!)
            if flow.getViewControllers().isEmpty{ flow.clear() }
        }
        return super.popViewControllerAnimated(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var pushNewHomeControllerWithPushAnimated = true
}
