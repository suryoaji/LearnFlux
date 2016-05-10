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
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        self.tabBarController?.title = "Connections";
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 3;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(indexPath.code)!;
        cell.setSeparatorType(CellSeparatorFull);
        let img = cell.viewWithTag(10) as! UIImageView;
        img.makeRounded();
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }

}