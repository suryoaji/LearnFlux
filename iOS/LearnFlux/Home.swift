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
    let separator: CGFloat = 65.0;
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let item:UIBarButtonItem! = UIBarButtonItem();
        item.image = UIImage(named: "menu-1.png");
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
//        let srow = CGFloat(Int(indexPath.row) / 2);
//        let scol = CGFloat(Int(indexPath.row) % 2);
//        cell.x = scol * (screenWidth + separator) / 2;
//        cell.y = srow * (screenWidth + separator) / 2;
        for view in cell.subviews {
            let a = view.description;
            NSLog("view = \(a)");
        }
        let bg = cell.viewWithTag(10) as! UIImageView;
        let layer = cell.viewWithTag(12)!;
        let icon = cell.viewWithTag(11) as! UIImageView;
        let label = cell.viewWithTag(21) as! UILabel;
        NSLog("label = \(label.text), x = \(label.x), y = \(label.y), w = \(label.width), h = \(label.height)");
        label.x = 14; label.y = 111;
        label.textAlignment = .Center;
        cell.bringSubviewToFront(label);
        if (indexPath.row == 0) {
            bg.image = UIImage(named: "mozaic_organization.png");
            icon.image = UIImage(named: "globe_white-512.png");
            layer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6);
            label.text = "Organization";
        }
        else if (indexPath.row == 1) {
            bg.image = UIImage(named: "mozaic_activities.png");
            icon.image = UIImage(named: "headphones_white-512.png");
            layer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8);
            label.text = "Activities";
        }
        else if (indexPath.row == 2) {
            bg.image = UIImage(named: "mozaic_settings.png");
            icon.image = UIImage(named: "wrench_white-512.png");
            layer.backgroundColor = UIColor.init(red: 0, green: 144/255, blue: 1, alpha: 1);
            label.text = "Settings";
        }
        else if (indexPath.row == 3) {
            bg.image = UIImage(named: "mozaic_chat.png");
            icon.image = UIImage(named: "speech_bubble_white2-512.png");
            icon.center = bg.center;
            layer.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 1);
            label.text = "Chats";
            label.x = 10; label.y = cell.height - label.height - 30;
            label.textAlignment = .Left
        }
        cell.sendSubviewToBack(bg)

        return cell;
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((screenWidth - separator) / 2, (screenWidth - separator) / 2);
    }

    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 3) {
            self.navigationController?.pushViewController(Util.getViewControllerID("Chats"), animated: true);
        }
    }
    
}