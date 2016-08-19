//
//  navController.swift
//  LearnFlux
//
//  Created by ISA on 8/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class navController: UINavigationController {
    
    let flow = Flow.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
