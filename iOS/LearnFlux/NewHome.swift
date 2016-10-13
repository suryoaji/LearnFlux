//
//  NewHome.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/17/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import PKRevealController

class NewHome : UIViewController {
    let clientData = Engine.clientData
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "menu-1.png");
        self.navigationItem.leftBarButtonItem = item
        
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        self.addTapHandlerToAllImages(self.view);
        
        contentView.alpha = 0.3
        contentView.frame.origin.x += UIScreen.mainScreen().bounds.width
        UIView.animateWithDuration(0.23, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            self.contentView.frame.origin.x = 0
            self.contentView.alpha = 1.0
            }, completion: nil)
        
        Engine.getImageSelf(){ image in
            if let image = image{
                self.clientData.photo = image
            }
        }
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
        if img.tag == 2 {
            self.performSegueWithIdentifier("chat", sender: nil);
        }else if img.tag == 6 && Engine.clientData.getGroups() != nil{
            self.performSegueWithIdentifier("InterestGroup", sender: nil)
        }
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        let dark = UIView(frame: UIScreen.mainScreen().bounds);
        dark.backgroundColor = UIColor.clearColor();
        
        self.revealController.showViewController(self.revealController.leftViewController);
    }

}