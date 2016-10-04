//
//  Menu.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Menu : UITableViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 1;
        case 2: return 1;
        case 3: return 8;
        case 4: return 1;
        case 5: return 1;
        case 6: return 1;
        default: return 0;
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let code = indexPath.code;
        NSLog(code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        if (indexPath.isEqualCode("1-0") ||
            indexPath.isEqualCode("2-0") ||
            indexPath.isEqualCode("3-6") ||
            indexPath.isEqualCode("4-0") ||
            indexPath.isEqualCode("5-0") ||
            indexPath.isEqualCode("6-0")) {
            cell.setSeparatorType(CellSeparatorFull);
        }
        else {
            cell.setSeparatorType(CellSeparatorNone);
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        self.revealController.showViewController(self)
        var vc : UIViewController?
        if indexPath.isEqualCode("2-0") {
            vc = Util.getViewControllerID("Profile")
        }else if indexPath.isEqualCode("3-7"){
            vc = Util.getViewControllerID("InterestGroups")
        }
        if let vc = vc where self.revealController.frontViewController.isKindOfClass(NavController){
            let navController = self.revealController.frontViewController as! NavController
            navController.pushViewController(vc, animated: false)
            self.revealController.showViewController(navController)
        }
    }
    
}