//
//  GroupDetails.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/13/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

@objc protocol GroupDetailsDelegate {
    func pushViewController (viewController: UIViewController, animated: Bool)
    func presentViewController (viewController: UIViewController, animated: Bool)
}

class GroupDetails : UIViewController, GroupDetailsDelegate {
    let clientData = Engine.clientData
    weak var orgEventsDelegate : OrgEventsDelegate!{
        didSet{
            if orgEventsDelegate != nil{
                orgEventsDelegate.setIsAdminOrNot(isAdmin)
                if group != nil { orgEventsDelegate.setIdGroupOfEvents(idGroup: group!.id) }
            }
        }
    }
    
    @IBOutlet var viewSelection : UIView!;
    @IBOutlet var viewTabs : UIView!;
    @IBOutlet var logo : UIView!;
    var tabs: Array<UIViewController> = []
    var indexActiveTabs : Int = 0{
        didSet{
            if isAdmin{
                switch indexActiveTabs {
                case 0:
                    changeImageRightBarButton("edit")
                    break
                case 1:
                    changeImageRightBarButton("addCalendar")
                    break
                case 2:
                    changeImageRightBarButton("addTime.png")
                    break
                default:
                    changeImageRightBarButton("")
                    break
                }
            }
        }
    }
    
    @IBOutlet var lblTitle : UILabel!;
    @IBOutlet var viewTitle : UIView!;
    
    var strTitle = "";
    var colorTitle = UIColor.clearColor();
    var isAdmin: Bool = false{
        didSet{
            if orgEventsDelegate != nil{
                orgEventsDelegate.setIsAdminOrNot(isAdmin)
            }
        }
    }
    var group : Group?{
        didSet{
            if group != nil{
                isAdmin = checkAdmin()
                if orgEventsDelegate != nil {
                    orgEventsDelegate.setIdGroupOfEvents(idGroup: group!.id)
                }
            }
        }
    }
    
    func checkAdmin() -> (Bool){
        let admin : Bool = Engine.isAdminOfGroup(self.group!)
        if admin{
            changeImageRightBarButton("edit")
            print("this group could be edited")
        }else{
            self.navigationItem.rightBarButtonItem = nil
            print("this group could not be edited")
        }
        return admin
    }
    
    func initFromCall(groupInfo : Group) {
        group = groupInfo;
        self.strTitle = groupInfo.name!;
        self.colorTitle = groupInfo.color;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tabs.append(Util.getViewControllerID("GroupProfile"))
        tabs.append(Util.getViewControllerID("OrgEvents"))
        tabs.append(Util.getViewControllerID("OrgActivities"))
        changeView(0);
        (tabs[0] as! GroupProfile).initFromCall(group!);
        (tabs[0] as! GroupProfile).groupDetailsDelegate = self
        self.orgEventsDelegate = (tabs[1] as! OrgEvents)
        
        self.title = "Details";
        self.lblTitle.text = self.strTitle.uppercaseString;
        self.viewTitle.backgroundColor = colorTitle;
    }
    
    func changeView (index : Int) {
        (tabs[0] as! GroupProfile).view.removeFromSuperview();
        (tabs[1] as! OrgEvents).view.removeFromSuperview();
        (tabs[2] as! OrgActivities).view.removeFromSuperview();
        
        let vc = tabs[index];
        self.view.addSubview(vc.view);
        vc.view.frame = self.view.viewWithTag(50)!.frame;
        self.view.bringSubviewToFront(vc.view);
        
        UIView.animateWithDuration(0.3) {
            self.viewSelection.x = self.viewTabs.x + 70 * CGFloat(index);
            self.viewSelection.y = self.viewTabs.y + self.viewTabs.height - self.viewSelection.height;
        }
    }
    
    @IBAction func changeViewAction (sender: AnyObject) {
        let btn = sender as! UIButton;
        let idx = btn.tag - 100;
        indexActiveTabs = idx
        changeView(idx);
    }
    
    func changeImageRightBarButton(stringImage: String){
        let navItem = self.navigationItem;
        if stringImage.isEmpty{
            navItem.rightBarButtonItem = nil
        }else{
            let right = UIBarButtonItem(image: UIImage(named: stringImage), style: .Plain, target: self, action: #selector(self.rightBarButtonTapped))
            navItem.rightBarButtonItem = right
        }
    }
    
    func pushViewController(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentViewController(viewController: UIViewController, animated: Bool){
        self.presentViewController(viewController, animated: animated, completion: nil)
    }
    
    @IBAction func rightBarButtonTapped(sender: UIBarButtonItem) {
        switch indexActiveTabs {
        case 0:
            print("edit is tapped")
            break
        case 1:
            print("create event is tapped")
            break
        case 2:
            print("create activity is tapped")
            break
        default:
            break
        }
    }
}