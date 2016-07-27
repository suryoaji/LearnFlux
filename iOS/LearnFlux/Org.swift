//
//  Org.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/15/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Org : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath);
        
        let lblMessage = cell.viewWithTag(3) as! UILabel;
        let lblEvent = cell.viewWithTag(4) as! UILabel;
        let lblActivities = cell.viewWithTag(5) as! UILabel;
        lblMessage.makeViewRounded();
        lblEvent.makeViewRounded();
        lblActivities.makeViewRounded();
        
        cell.makeViewRoundedRectWithCornerRadius(5);
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(148, 278);
        let screenSize = UIScreen.mainScreen().bounds.width;
        size.width = (screenSize / 2) - 15;
        return size;
    }

}