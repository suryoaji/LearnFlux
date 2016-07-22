//
//  NewHome.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/17/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class NewHome : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "hamburger-18.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        self.addTapHandlerToAllImages(self.view);
//        Util.showMessageInViewController(self, title: "Hello", message: "Hello, \(Data.defaults.valueForKey("me")!.valueForKey!("email")! as! String)");
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        let screenWidth = UIScreen.mainScreen().bounds.width;
        self.revealController.setMinimumWidth(screenWidth * 0.8, maximumWidth: screenWidth * 0.9, forViewController: self.revealController.leftViewController)
    }

    
    func addTapHandlerToAllImages (view: UIView) {
        if let v = view as? UIImageView {
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped))
            v.userInteractionEnabled = true
            v.addGestureRecognizer(tapGestureRecognizer)
        }
        else {
            for v in view.subviews {
                addTapHandlerToAllImages(v);
            }
        }
    }
    
    func imageTapped (sender: AnyObject) {
        let tap = sender as! UITapGestureRecognizer;
        let img = tap.view as! UIImageView;
        if (img.tag == 2) {
            self.performSegueWithIdentifier("chat", sender: nil);
        }
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        let dark = UIView(frame: UIScreen.mainScreen().bounds);
        dark.backgroundColor = UIColor.clearColor();
        
        self.revealController.showViewController(self.revealController.leftViewController);
    }


}