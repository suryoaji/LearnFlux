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
    var lastSelected = NSIndexPath(forRow: 0, inSection: 2)
    
    override func viewDidLoad () {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateFirstSectionTableView()
        
        if let lastVC = checkLastViewController(){
            lastSelected = lastVC
        }
    }
    
    func checkLastViewController() -> NSIndexPath?{
        if let navController = self.revealController.frontViewController as? NavController{
            return getIndexPathOf(navController.viewControllers.last!)
        }
        return nil
    }
    
    func getIndexPathOf(lastVc: UIViewController) -> NSIndexPath{
        switch lastVc {
        case is Profile:
            return NSIndexPath(forRow: 0, inSection: 1)
        case is NewHome:
            return NSIndexPath(forRow: 0, inSection: 2)
        case is InterestGroups:
            return NSIndexPath(forRow: 4, inSection: 3)
        case is Project:
            return NSIndexPath(forRow: 6, inSection: 3)
        default:
            return NSIndexPath(forRow: 0, inSection: 0)
        }
    }
    
    func updateFirstSectionTableView(){
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
        let cell = tableView.dequeueReusableCellWithIdentifier("\(indexPath.section)-\(indexPath.row)")!
        switch (indexPath.section, indexPath.row){
        case (1,0):
            let view = cell.viewWithTag(1)!
            let labelName = cell.viewWithTag(2) as! UILabel
            let labelEmail = cell.viewWithTag(3) as! UILabel
            let imageViewPhoto = cell.viewWithTag(4) as! UIImageView
            view.frame.size.width = UIScreen.mainScreen().bounds.width * 0.65 - 4.0
            imageViewPhoto.image = clientData.photo
            labelName.text = clientData.cacheFullname().capitalizedString
            labelEmail.text = clientData.cacheSelfEmail()
        default: break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        guard let navCon = revealController.frontViewController as? NavController where lastSelected != indexPath else{
            return
        }
        self.revealController.showViewController(self)
        var vc : UIViewController?
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            let profileVC = Util.getViewControllerID("Profile") as! Profile
            profileVC.initViewController(id: clientData.cacheSelfId())
            vc = profileVC
        case (3,0):
            let navVc = Util.getViewControllerID("chatTabBarController") as! chatTabBarController
            navVc.initViewController(2)
        case (3,4):
            vc = Util.getViewControllerID("InterestGroups")
        case (3,6):
            vc = Util.getViewControllerID("Project")
        case (2,0):
            vc = Util.getViewControllerID("NewHome")
        case (6,0):
            vc = Util.getViewControllerID("Login")
        default: break
        }
        if let vc = vc{
            let homeVc = Util.getViewControllerID("NewHome")
            switch vc {
            case is NewHome:
                navCon.setViewControllers([vc], animated: false)
                self.revealController.showViewController(navCon)
            case is Login:
                self.revealController.frontViewController = vc
                self.revealController.showViewController(vc)
                Engine.stopAllRequests()
            default:
                navCon.setViewControllers([homeVc, vc], animated: false)
                self.revealController.showViewController(navCon)
            }
        }
        lastSelected = indexPath
    }
    
}