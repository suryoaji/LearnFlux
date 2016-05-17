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
        
        self.addTapHandlerToAllImages(self.view);
    }
    
    func addTapHandlerToAllImages (view: UIView) {
        if let v = view as? UIImageView {
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
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

}