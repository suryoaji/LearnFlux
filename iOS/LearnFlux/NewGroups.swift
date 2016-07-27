//
//  NewGroups.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/28/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AMPopTip

class NewGroups : UIViewController {
    
    @IBOutlet var imgGroup : UIImageView!;
    @IBOutlet var viewImage : UIView!;
    @IBOutlet var tfTitle : UITextField!;
    @IBOutlet var lblCount : UILabel!;
    
    var popTip = AMPopTip();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let right:UIBarButtonItem! = UIBarButtonItem();
        right.title = "Next";
        right.action = #selector(self.next);
        right.target = self;
        self.navigationItem.rightBarButtonItem = right;
        
        viewImage.makeViewRounded();
        
    }
    
    @IBAction func titleChanged (sender: AnyObject) {
        let remaining = 25 - tfTitle.text!.characters.count;
        lblCount.text = "\(remaining)";
        if (remaining < 0) {
            lblCount.textColor = UIColor(red: 1, green: 136/255, blue: 81/255, alpha: 1);
        }
        else {
            lblCount.textColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1);
        }
    }
    
    @IBAction func next (sender: AnyObject) {
        let remaining = 25 - tfTitle.text!.characters.count;
        if (remaining < 0) {
            self.popTip.showText("The Group's subject is too long.", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfTitle.frame);
        }
        else {
//            self.performSegueWithIdentifier("SelectParticipants", sender: self);
            let connections = Util.getViewControllerID("Connections") as! Connections;
            connections.inFlow("NewGroups", flowData: ["title":tfTitle.text!]);
            self.navigationController?.pushViewController(connections, animated: true);
        }
    }
}