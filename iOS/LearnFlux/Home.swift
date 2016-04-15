//
//  Home.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Home: UICollectionViewController {
    
    let screenWidth = UIScreen.mainScreen().bounds.width;
    let separator: CGFloat = 10.0;
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "hamburger-18.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        let screenWidth = UIScreen.mainScreen().bounds.width;
        
        self.revealController.setMinimumWidth(screenWidth * 0.8, maximumWidth: screenWidth * 0.9, forViewController: self.revealController.leftViewController)

//        var navigationArray: [UIViewController] = self.navigationController!.viewControllers
//        navigationArray.removeAtIndex(0)
//        self.navigationController!.viewControllers = navigationArray
        
//        self.navigationController.
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
//        if (self.revealController.focusedController() == self.revealController.leftViewController) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 4;
        default: return 0;
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("0-0", forIndexPath: indexPath);
        
        cell.width = (screenWidth - separator) / 2;
        cell.height = cell.width;
        let srow = CGFloat(Int(indexPath.row) / 2);
        let scol = CGFloat(Int(indexPath.row) % 2);
        cell.x = scol * (screenWidth + separator) / 2;
        cell.y = srow * (screenWidth + separator) / 2;
        for view in cell.subviews {
            let a = view.description;
            NSLog("view = \(a)");
        }
        let bg = cell.viewWithTag(10) as! UIImageView;
        let label = cell.viewWithTag(21) as! UILabel;
        NSLog("label = \(label.text), x = \(label.x), y = \(label.y), w = \(label.width), h = \(label.height)");
        cell.bringSubviewToFront(label);
        if (indexPath.row == 0) {
            bg.image = UIImage(named: "mozaic_organization.png");
            label.text = "Organization";
        }
        else if (indexPath.row == 1) {
            bg.image = UIImage(named: "mozaic_activities.png");
            label.text = "Activities";
        }
        else if (indexPath.row == 2) {
            bg.image = UIImage(named: "mozaic_settings.png");
            label.text = "Settings";
        }
        else if (indexPath.row == 3) {
            bg.image = UIImage(named: "mozaic_chat.png");
            label.text = "Chats";
        }
        cell.sendSubviewToBack(bg)

        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 3) {
            self.navigationController?.pushViewController(Util.getViewControllerID("Chats"), animated: true);
        }
    }
    
}