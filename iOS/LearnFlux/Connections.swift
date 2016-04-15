//
//  Connections.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Connections : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "hamburger-18.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = "revealMenu:";
        item.target = self;
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }

}