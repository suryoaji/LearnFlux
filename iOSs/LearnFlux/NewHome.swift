//
//  NewHome.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/17/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import PKRevealController

class NewHome : UIViewController {
    let clientData = Engine.clientData
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionViewMosaic: UICollectionView!
    
    @IBAction func revealMenu (sender: AnyObject) {
        let dark = UIView(frame: UIScreen.mainScreen().bounds);
        dark.backgroundColor = UIColor.clearColor();
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if shouldPushAnimated{
            animateWhenSelfPushed()
        }else{
            animate()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mockUp()
        let screenWidth = UIScreen.mainScreen().bounds.width;
        self.revealController.setMinimumWidth(screenWidth * 0.65, maximumWidth: screenWidth * 0.9, forViewController: self.revealController.leftViewController)
        
        Engine.reloadDataAPI()
    }
    
    func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        
    }
    
    var shouldPushAnimated = true
    let mosaicImages = ["mosaic-calendar.jpg", "mosaic-dashboard.jpg", "mosaic-chat.jpg", "mosaic-project.jpg", "mosaic-favorite.jpg", "mosaic-attandance.jpg", "mosaic-interestgroup.jpg", "mosaic-settings.jpg"]
}



// - MARK Mock Up
extension NewHome{
    func mockUp(){
        setAccNavBar()
    }
    
    func setAccNavBar(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "menu-1.png"), style: .Plain, target: self, action: #selector(revealMenu))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.width, 100))
        label.text = self.navigationItem.title
        label.font = UIFont(name: "Helvetica Neue Medium", size: 12.0)
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    func animateWhenSelfPushed(){
        contentView.alpha = 0.3
        contentView.frame.origin.x += UIScreen.mainScreen().bounds.width
        UIView.animateWithDuration(0.23, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            self.contentView.frame.origin.x = 0
            self.contentView.alpha = 1.0
            }, completion: nil)
    }
    
    func animate(){
        contentView.alpha = 0
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
            self.contentView.alpha = 1.0
            }, completion: nil)
    }
}

// - MARK Collection View
extension NewHome: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return mosaicImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let imageViewMosaic = cell.viewWithTag(1) as! UIImageView
        imageViewMosaic.image = UIImage(named: mosaicImages[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(collectionView.frame.width / 2 - 4, collectionView.frame.height / 4 - 24 / 4)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 2:
            performSegueWithIdentifier("chat", sender: self)
        case 3:
            performSegueWithIdentifier("Project", sender: self)
        case 6:
            performSegueWithIdentifier("InterestGroup", sender: self)
        default: break
        }
    }
}
















