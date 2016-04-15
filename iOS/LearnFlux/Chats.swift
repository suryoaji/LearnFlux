//
//  Chats.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Chats : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let left:UIBarButtonItem! = UIBarButtonItem();
        left.image = UIImage(named: "hamburger-18.png");
        self.navigationItem.leftBarButtonItem = left;
        left.action = #selector(self.revealMenu);
        left.target = self;

        let right:UIBarButtonItem! = UIBarButtonItem();
        right.title = "All";
        self.navigationItem.rightBarButtonItem = right;
        right.action = #selector(self.filter);
        right.target = self;
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 6;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let code = indexPath.code;
        NSLog(code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        cell.setSeparatorType(CellSeparatorFull);
        let pp = cell.viewWithTag(10) as! UIImageView;
        pp.makeRounded();
        return cell;
    }
    
    @IBAction func filter(sender: AnyObject) {
        let alert: UIAlertController = UIAlertController(title:"Select Filter", message: "Select how do you want to filter the chats.", preferredStyle: .ActionSheet)
        let act1: UIAlertAction = UIAlertAction(title:"All", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "All";
            self.tableView.reloadData();
        })
        alert.addAction(act1)
        let act2: UIAlertAction = UIAlertAction(title:"Groups", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Groups";
            self.tableView.reloadData();
        })
        alert.addAction(act2)
        let act3: UIAlertAction = UIAlertAction(title:"Orgs", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Orgs";
            self.tableView.reloadData();
        })
        alert.addAction(act3)
        let act4: UIAlertAction = UIAlertAction(title:"Interests", style: .Default, handler: {(action: UIAlertAction) -> Void in
            self.navigationItem.rightBarButtonItem?.title = "Interests";
            self.tableView.reloadData();
        })
        alert.addAction(act4)
        let cancel: UIAlertAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
}