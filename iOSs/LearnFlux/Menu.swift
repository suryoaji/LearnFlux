//
//  NewMenu.swift
//  LearnFlux
//
//  Created by ISA on 12/9/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum MenuList{
    case ProfileMenu
    case HomeMenu
    case ToolsMenu(indexPath: NSIndexPath)
    
    init(lastVc: UIViewController){
        switch lastVc {
        case is InterestGroups:
            self = .ToolsMenu(indexPath: NSIndexPath(forRow: 5, inSection: 0))
        case is Project:
            self = .ToolsMenu(indexPath: NSIndexPath(forRow: 6, inSection: 0))
        case is Profile:
            self = .ProfileMenu
        case is NewHome:
            self = .HomeMenu
        default:
            self = .HomeMenu
        }
    }
    
    var rawValue : Int {
        switch self {
        case .HomeMenu:
            return 0
        case .ProfileMenu:
            return 1
        case .ToolsMenu(indexPath: let indexPath):
            let section = indexPath.section + 1
            let row = indexPath.row
            return Int("\(section)\(row)")!
        }
    }
    
    var viewController: UIViewController?{
        switch self {
        case .HomeMenu:
            return Util.getViewControllerID("NewHome")
        case .ProfileMenu:
            let profileVC = Util.getViewControllerID("Profile") as! Profile
            profileVC.initViewController(id: Engine.clientData.cacheSelfId())
            return profileVC
        case .ToolsMenu(indexPath: let indexPath):
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                let navVc = Util.getViewControllerID("chatTabBarController") as! chatTabBarController
                navVc.initViewController(2)
                return navVc
            case (0,5):
                return Util.getViewControllerID("InterestGroups")
            case (0,6):
                return Util.getViewControllerID("Project")
            case (1,2):
                return Util.getViewControllerID("Login")
            default: return nil
            }
        }
    }
}

class Menu: UIViewController {
    let clientData = Engine.clientData
    var lastMenu : MenuList = .HomeMenu
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setViewData()
        if let lastVC = checkLastViewController(){
            lastMenu = lastVC
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonProfileTapped(sender: UIButton) {
        setShowRevealControllerWhenButtonTapped(.ProfileMenu)
    }
    
    @IBAction func buttonHomeTapped(sender: UIButton) {
        setShowRevealControllerWhenButtonTapped(.HomeMenu)
    }

}

// - MARK: Table View
extension Menu: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 9
        case 1:
            return 3
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height
        default:
            return UIScreen.mainScreen().bounds.height * 0.9 / 13.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("\(indexPath.section)-\(indexPath.row)")!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        setShowRevealControllerWhenButtonTapped(.ToolsMenu(indexPath: indexPath))
    }
}

// - MARK: Helper
extension Menu{
    func setViewData(){
        imageViewPhoto.image = clientData.photo
        labelFullName.text = clientData.cacheFullname().capitalizedString
        labelEmail.text = clientData.cacheSelfEmail()
    }
    
    func checkLastViewController() -> MenuList?{
        if let navController = self.revealController.frontViewController as? NavController{
            return MenuList(lastVc: navController.viewControllers.last!)
        }
        return nil
    }
    
    func setShowRevealControllerWhenButtonTapped(menu: MenuList){
        guard let navCon = revealController.frontViewController as? NavController where lastMenu.rawValue != menu.rawValue else{
            return
        }
        revealController.showViewController(self)
        let vc = menu.viewController
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
//        lastMenu = menu
    }
}























