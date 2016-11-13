//
//  OrgGroup.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgGroups : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var rightBarButton : UIBarButtonItem!
    let flow = Flow.sharedInstance
    let clientData = Engine.clientData
    var timer : NSTimer!
    
    @IBOutlet var cv : UICollectionView!;
    
    weak var pushDelegate : PushDelegate!;
    weak var refreshDelegate : RefreshDelegate!;
    var orgId : String! = ""
    var groups : [Group]?
    
    func randomizePastelColor () -> UIColor {
        let r = (CGFloat(arc4random_uniform(128)) + 128.0) / 255.0;
        let g = (CGFloat(arc4random_uniform(128)) + 128.0) / 255.0;
        let b = (CGFloat(arc4random_uniform(128)) + 128.0) / 255.0;
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    func initGroup (orgId : String) {
        self.orgId = orgId;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil{
            layoutWhenNavigationBarIsEnabled()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.OrgDetailDisappear), name: "OrgDetailDisappearNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.enterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.enterForeground), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    @IBAction func enterForeground(notification: NSNotification){
        if !timer.valid{
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func enterBackground(notification: NSNotification){
        if timer.valid { timer.invalidate() }
    }
    
    @IBAction func OrgDetailDisappear(notification: NSNotification){
        if timer.valid { timer.invalidate() }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil && timer.valid{
            timer.invalidate()
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func layoutWhenNavigationBarIsEnabled(){
        self.cv.frame.origin.y += self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        self.cv.frame.size.height -= self.cv.frame.origin.y
        
        rightBarButton = UIBarButtonItem()
        rightBarButton.image = UIImage(named: "menu")
        self.navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.action = #selector(self.rightNavigationBarButtonTapped)
        rightBarButton.target = self
    }
    
    @IBAction func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        Util.showAlertMenu(self, title: "Menu", choices: ["Create New Interest Group..."], styles: [.Default], addCancel: true){ selected in
            switch selected{
            case 0:
                self.performSegueWithIdentifier("NewGroups", sender: nil)
                break
            default:
                break
            }
        }
    }
    
    func update () {
        cv.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (groups == nil) { return 0; } else { return groups!.count; }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath);
        
        let lblTitle = cell.viewWithTag(1)! as! UILabel;
        let lblDesc = cell.viewWithTag(2)! as! UILabel;
        let editButton = cell.viewWithTag(3)! as! UIButton
        
        if let data = groups {
            let group = data[indexPath.row];
            lblTitle.text = group.name.uppercaseString;
            lblDesc.text = "";
            
            editButton.alpha = group.isAdmin ? 1.0 : 0.0
            
            if group.color == nil {
                let color = randomizePastelColor();
                group.color = color;
                groups![indexPath.row].color = color;
            }
            cell.backgroundColor = group.color;
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cv.deselectItemAtIndexPath(indexPath, animated: false);
        guard let data = groups else { return; }
        let vc = Util.getViewControllerID("GroupDetails") as! GroupDetails;
        vc.initFromCall(data[indexPath.row]);
        if pushDelegate == nil{
            Engine.getGroupInfo(groupId: data[indexPath.row].id){status, group in
                if let group = group where status == .Success{
                    vc.initFromCall(group)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            vc.initFromCall(data[indexPath.row]);
            pushDelegate.pushViewController(vc, animated: true);
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(150, 106);
        let screenSize = UIScreen.mainScreen().bounds.width;
        size.width = (screenSize / 2) - 15;
        return size;
    }
}