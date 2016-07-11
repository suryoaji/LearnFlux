//
//  OrgGroup.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class OrgGroups : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var groups : Array<Dictionary<String, AnyObject>> = [];
    
    func setupDummyData () {
        groups.append(["title":"Ma Fine Arts", "description":"", "color":UIColor.init(red: 0/255, green: 190/255, blue: 143/255, alpha: 1)]);
        groups.append(["title":"Summer Classes", "description":"", "color":UIColor.init(red: 236/255, green: 105/255, blue: 140/255, alpha: 1)]);
        groups.append(["title":"Ma Fine Arts", "description":"May - July 2016", "color":UIColor.init(red: 0/255, green: 190/255, blue: 143/255, alpha: 1)]);
        groups.append(["title":"Summer Classes", "description":"May - July 2016", "color":UIColor.init(red: 236/255, green: 105/255, blue: 140/255, alpha: 1)]);
        groups.append(["title":"Ma Fine Arts", "description":"This Winter, October - December 2016", "color":UIColor.init(red: 0/255, green: 190/255, blue: 143/255, alpha: 1)]);
        groups.append(["title":"Winter Classes", "description":"This Winter, October - December 2016", "color":UIColor.init(red: 236/255, green: 105/255, blue: 140/255, alpha: 1)]);
        groups.append(["title":"Faculty of Design", "description":"", "color":UIColor.init(red: 160/255, green: 213/255, blue: 80/255, alpha: 1)]);
        groups.append(["title":"Faculty Research", "description":"", "color":UIColor.init(red: 189/255, green: 63/255, blue: 232/255, alpha: 1)]);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDummyData();
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count;
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath);
        
        let lblTitle = cell.viewWithTag(1)! as! UILabel;
        let lblDesc = cell.viewWithTag(2)! as! UILabel;
        
        let group = groups[indexPath.row];
        lblTitle.text = (group["title"]! as? String)?.uppercaseString;
        lblDesc.text = (group["description"]! as? String)?.uppercaseString;
        cell.backgroundColor = group["color"] as? UIColor;
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(150, 106);
        let screenSize = UIScreen.mainScreen().bounds.width;
        size.width = (screenSize / 2) - 15;
        return size;
    }
    
}