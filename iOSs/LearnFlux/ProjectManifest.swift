//
//  ProjectManifest.swift
//  LearnFlux
//
//  Created by ISA on 12/5/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class ProjectManifest: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mockUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonShowDetailTapped(sender: UIButton){
        guard let rawValue = sender.accessibilityIdentifier else{
            return
        }
        let row = Int(rawValue.componentsSeparatedByString("-")[1])!
        guard let statusComment = dummyComments[row]["shouldMore"] as? Bool else{
            return
        }
        dummyComments[row]["shouldMore"] = !statusComment
        animateShowDetailTask(!statusComment, sender: sender, shouldAnimate: true)
    }
    
    func buttonCheckTapped(sender: UIButton){
        guard let rawValue = sender.accessibilityIdentifier else{
            return
        }
        let row = Int(rawValue.componentsSeparatedByString("-")[1])!
        guard let statusCheck = dummyComments[row]["checked"] as? Bool else{
            return
        }
        dummyComments[row]["checked"] = !statusCheck
        tableView.reloadData()
    }
    
    @IBOutlet weak var containerView: UIView!
    var dummyComments : Array<Dictionary<String, AnyObject>> = [["shouldMore" : false, "checked" : false], ["shouldMore" : false, "checked" : false]]
}

// - MARK: TableView
extension ProjectManifest: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return 1
        case 1:
            return dummyComments.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell = tableView.dequeueReusableCellWithIdentifier("header")!
        case (1, let row):
            func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
                let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByCharWrapping
                label.font = font
                label.text = text
                label.sizeToFit()
                return label.frame.height
            }
            
            cell = tableView.dequeueReusableCellWithIdentifier("list")!
            if dummyComments[row]["shouldMore"] as! Bool{
                let viewDetail = cell.viewWithTag(1001)!
                let labelDetailRemark = cell.viewWithTag(3) as! UILabel
                viewDetail.height = heightForView("Buy Ingredients", font: labelDetailRemark.font, width: UIScreen.mainScreen().bounds.width / cell.width * labelDetailRemark.width) + 49
                cell.height += viewDetail.height
            }
        default:break
        }
        return cell.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell = tableView.dequeueReusableCellWithIdentifier("header")!
            let contentView = cell.viewWithTag(1)!
            contentView.layer.borderWidth = 0.6
            contentView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        case (1, let row):
            func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
                let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByCharWrapping
                label.font = font
                label.text = text
                label.sizeToFit()
                return label.frame.height
            }
            
            cell = tableView.dequeueReusableCellWithIdentifier("list")!
//            let imageView = cell.viewWithTag(1) as! UIImageView
            let buttonShowDetail = cell.viewWithTag(2) as! UIButton
            let buttonCheck = cell.viewWithTag(4) as! UIButton
            let viewLabelDetail = cell.viewWithTag(1001)!
            let labelDetailRemark = cell.viewWithTag(3) as! UILabel
            buttonShowDetail.accessibilityIdentifier = "\(indexPath.section)-\(indexPath.row)"
            buttonShowDetail.addTarget(self, action: #selector(buttonShowDetailTapped), forControlEvents: .TouchUpInside)
            animateShowDetailTask(dummyComments[row]["shouldMore"] as! Bool, sender: buttonShowDetail, shouldAnimate: false)
            
            buttonCheck.accessibilityIdentifier = "\(indexPath.section)-\(indexPath.row)"
            buttonCheck.addTarget(self, action: #selector(buttonCheckTapped), forControlEvents: .TouchUpInside)
            buttonCheck.setImage(UIImage(named: dummyComments[row]["checked"] as! Bool ? "checkbox-ticked" : "check-box-empty"), forState: .Normal)
            buttonCheck.tintColor = dummyComments[row]["checked"] as! Bool ? LFColor.green : UIColor.lightGrayColor()
            
            labelDetailRemark.text = "Buy Ingredients"
            viewLabelDetail.height = heightForView(labelDetailRemark.text!, font: labelDetailRemark.font, width: UIScreen.mainScreen().bounds.width / cell.width * labelDetailRemark.width) + 49
            
        default: break
        }
        
        return cell
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        
//    }
}

// - MARK: Mock Up
extension ProjectManifest{
    func mockUp(){
        setAccNavBar()
    }
    
    func setAccNavBar(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        layoutWithNavBar()
    }
    
    func layoutWithNavBar(){
        containerView.frame.origin.y = navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        containerView.frame.size.height = view.height - containerView.frame.origin.y
    }
    
    func rightNavigationBarButtonTapped(){
        
    }
    
    func animateShowDetailTask(showOrNot: Bool, sender: UIButton, shouldAnimate: Bool){
        let newAnchorPoint = CGPointMake(0.2, 0.5)
        let rotateTransform = CATransform3DMakeRotation(CGFloat(M_PI / 2), 0, 0, 1)
        let translateTransform = CATransform3DMakeTranslation(sender.width * 0.6 / 2, 0, 0)
        
        if shouldAnimate{
            tableView.beginUpdates()
            tableView.endUpdates()
            switch showOrNot {
            case true:
                sender.imageView?.layer.anchorPoint = newAnchorPoint
                UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                    sender.imageView?.layer.transform = rotateTransform
                    sender.layer.transform = translateTransform
                    }, completion: nil)
            case false:
                UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                    sender.layer.sublayers![0].transform = CATransform3DIdentity
                    sender.layer.transform = CATransform3DIdentity
                    }, completion: nil)
            }
        }else{
            if showOrNot{
                sender.imageView?.layer.anchorPoint = newAnchorPoint
                sender.imageView?.layer.transform = rotateTransform
                sender.layer.transform = translateTransform
            }
        }
    }
}

























