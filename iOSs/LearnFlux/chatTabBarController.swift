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
    
    var rightBarButton : UIBarButtonItem!
    
    func initViewController(index: Int){
        self.selectedIndex = index
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.shadowOffset = CGSizeMake(0, 2)
//        self.tabBar.barTintColor = LFColor.green
        self.tabBar.tintColor = LFColor.blue
        self.view.backgroundColor = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont(name: "BanglaSangamMN", size: 10)!], forState: .Normal)
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        self.title = viewController.isKindOfClass(Chats) ? "Chats" : viewController.isKindOfClass(Org) ? "Organisations" : "Connections"
        if viewController.isKindOfClass(Chats){
            self.title = "Chats"
            self.setRightNavigationBarButton(viewController)
        }else if viewController.isKindOfClass(Org){
            self.title = "Organisations"
            self.setRightNavigationBarButton(viewController)
        }else{
            self.title = "Connections"
            self.removeRightNavigationBarButton()
        }
        let transition = CATransition()
        transition.duration = 0.14
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.view.window?.layer.addAnimation(transition, forKey: nil)
        
        
        self.animatePressedTabBarButton(self.tabBar.subviews[tabBarController.selectedIndex + 1])
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation{
            if let layer = animation.valueForKey("layer") as? CALayer{
                let view = animation.valueForKey("view") as! UIView
                view.backgroundColor = UIColor(red: 165.0/255, green: 210.0/255, blue: 113.0/255, alpha: 1.0)
                view.clipsToBounds = false
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func animatePressedTabBarButton(selectedTabBarItemView: UIView){
        selectedTabBarItemView.transform = CGAffineTransformIdentity
        UIView.animateKeyframesWithDuration(0.2, delay: 0, options: .CalculationModeLinear, animations: {
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/2, animations: {
                selectedTabBarItemView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            })
            UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
                selectedTabBarItemView.transform = CGAffineTransformIdentity
            })
            }, completion: { finished in
        })
//        let path = UIBezierPath(ovalInRect: CGRectMake(selectedTabBarItemView.bounds.width/2, selectedTabBarItemView.bounds.height/2, 0, 0))
//        let path2 = UIBezierPath(ovalInRect: CGRectMake(selectedTabBarItemView.bounds.width/2 - 100, selectedTabBarItemView.bounds.height/2 - 100, 200, 200))
//        let layer = CAShapeLayer()
//        layer.path = path.CGPath
//        layer.fillColor = UIColor.whiteColor().CGColor
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = CGSizeMake(0, 0)
//        layer.shadowRadius = 5.0
//        layer.shadowColor = UIColor.darkGrayColor().CGColor
//        layer.opacity = 0.2
//        selectedTabBarItemView.layer.addSublayer(layer)
//        selectedTabBarItemView.clipsToBounds = true
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.fromValue = path.CGPath
//        animation.toValue = path2.CGPath
//        animation.duration = 0.2
//        animation.delegate = self
//        animation.setValue(layer, forKey: "layer")
//        animation.setValue(selectedTabBarItemView, forKey: "view")
//        layer.addAnimation(animation, forKey: "1")
        
//        viewController.tabBarItem = UITabBarItem(title: "Connections", image: UIImage(named: "group-24.png")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "group-24.png"))
//        var firstViewController:UIViewController = UIViewController()
//        var customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "YOUR_IMAGE_NAME")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "YOUR_IMAGE_NAME"))
//        firstViewController.tabBarItem = customTabBarItem
    }
    
    func setRightNavigationBarButton(viewController: UIViewController){
        if let viewController = viewController as? Chats{
            let navItem = self.navigationItem
            rightBarButton = UIBarButtonItem()
            rightBarButton.image = UIImage(named: "menu")
            navItem.rightBarButtonItem = rightBarButton
            rightBarButton.action = #selector(viewController.rightNavigationBarButtonTapped)
            rightBarButton.target = viewController
        } else if let viewController = viewController as? Org{
            let navItem = self.navigationItem
            rightBarButton = UIBarButtonItem()
            rightBarButton.image = UIImage(named: "addCalendar")
            navItem.rightBarButtonItem = rightBarButton
            rightBarButton.action = #selector(viewController.rightNavigationBarButtonTapped)
            rightBarButton.target = viewController
        }
    }
    
    func removeRightNavigationBarButton(){
        self.navigationItem.rightBarButtonItem = nil
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    }
}
