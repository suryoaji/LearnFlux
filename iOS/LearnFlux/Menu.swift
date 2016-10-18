//
//  Menu.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Menu : UITableViewController {
    let clientData = Engine.clientData
    
    override func viewDidLoad () {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateFirstSectionTableView), name: "photoUpdateNotification", object: self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateFirstSectionTableView(notification: NSNotification){
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .None)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 1;
        case 2: return 1;
        case 3: return 7;
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
        switch indexPath.section {
        case 1:
            return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height
        default:
            return UIScreen.mainScreen().bounds.height * 0.9 / 13.0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let code = indexPath.code;
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        if (indexPath.isEqualCode("1-0") ||
            indexPath.isEqualCode("2-0") ||
            indexPath.isEqualCode("3-5") ||
            indexPath.isEqualCode("4-0") ||
            indexPath.isEqualCode("5-0") ||
            indexPath.isEqualCode("6-0")) {
            cell.setSeparatorType(CellSeparatorFull);
        }
        else {
            cell.setSeparatorType(CellSeparatorNone);
        }
        
        if indexPath.isEqualCode("1-0"){
            let view = cell.viewWithTag(1)!
            let labelName = cell.viewWithTag(2) as! UILabel
            let labelEmail = cell.viewWithTag(3) as! UILabel
            let imageViewPhoto = cell.viewWithTag(4) as! UIImageView
            view.frame.size.width = UIScreen.mainScreen().bounds.width * 0.65 - 4.0
            imageViewPhoto.image = clientData.photo
            labelName.text = "\(clientData.cacheMe()!["first_name"]!) \(clientData.cacheMe()!["last_name"]!)"
            labelEmail.text = "\(clientData.cacheMe()!["email"]!)"
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        self.revealController.showViewController(self)
        var vc : UIViewController?
        if indexPath.isEqualCode("1-0") {
            vc = Util.getViewControllerID("Profile")
        }else if indexPath.isEqualCode("3-5"){
            vc = Util.getViewControllerID("InterestGroups")
        }
        if let vc = vc where self.revealController.frontViewController.isKindOfClass(NavController){
            let navController = self.revealController.frontViewController as! NavController
            navController.pushViewController(vc, animated: false)
            self.revealController.showViewController(navController)
        }
    }
    
}