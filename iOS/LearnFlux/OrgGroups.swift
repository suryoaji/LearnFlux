//
//  OrgGroup.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgGroups : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var cv : UICollectionView!;
    
    var pushDelegate : PushDelegate!;
    var refreshDelegate : RefreshDelegate!;
    var orgId : String! = "";
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
//        print (orgId);
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        if self.navigationController != nil{
            self.cv.frame.origin.y += self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
            self.cv.frame.size.height -= self.cv.frame.origin.y
        }
        
    }
    
    func update () {
        cv.reloadData();
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (groups == nil) { return 0; } else { return groups!.count; }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath);
        
        let lblTitle = cell.viewWithTag(1)! as! UILabel;
        let lblDesc = cell.viewWithTag(2)! as! UILabel;
        
        if let data = groups {
            var group = data[indexPath.row];
            lblTitle.text = group.name.uppercaseString;
    //        lblDesc.text = (group["description"]! as? String)?.uppercaseString;
            lblDesc.text = "";
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
                if status == .Success{
                    var newGroup = data[indexPath.row]
                    newGroup.update(group!)
                    vc.initFromCall(newGroup)
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