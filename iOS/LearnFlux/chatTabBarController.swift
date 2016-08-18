//
//  chatTabBarController.swift
//  LearnFlux
//
//  Created by ISA on 8/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

//this class is just for making animation for Tab Bar Controller
class chatTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.shadowOffset = CGSizeMake(0, 2)
        self.tabBar.barTintColor = LFColor.green
        self.tabBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        let transition = CATransition()
        transition.duration = 0.14
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.view.window?.layer.addAnimation(transition, forKey: nil)
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
