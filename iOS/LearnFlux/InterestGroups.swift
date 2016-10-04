//
//  InterestGroups.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class InterestGroups: UIViewController {

    @IBOutlet weak var collectionViewGroups: UICollectionView!
    @IBOutlet weak var tableViewSuggestGroups: UITableView!
    
    var groups = [["name" : "Singapore Institution of Safety Officers",
                   "logo" : "company1.png",
                   "thumb" : "1"],
                  ["name" : "Environmental Science Community",
                   "logo" : "company2.png",
                   "thumb" : "0"]]
    var suggestGroups = [["name" : "Early Childhood Education",
                          "details" : "The National Association for the Education of Young Children",
                          "members" : "370",
                          "logo" : "company3.png"],
                         ["name" : "Early Childhood Education",
                          "details" : "The National Association for the Education of Young Children",
                          "members" : "280",
                          "logo" : "company2.png"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mockUp()
    }
    
    func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lowerView: UIView!
}

// - MARK Table View
extension InterestGroups: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! IGSuggestCell
        cell.setValues(suggestGroups[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return tableView.frame.height / 2
    }
}

// - MARK Collection View
extension InterestGroups: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! IGGroupCell
        cell.setValues(groups[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(collectionView.frame.width / 2 - 2, collectionView.frame.height)
    }
}

// - MARK Mock Up
extension InterestGroups{
    func mockUp(){
        setAccNavBar()
    }
    
    func setAccNavBar(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        layoutWithNavBar()
    }
    
    func layoutWithNavBar(){
        headerView.bounds.size.height = self.navigationController!.navigationBar.bounds.height
        headerView.frame.origin.y = self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        middleView.frame.origin.y = headerView.frame.origin.y + headerView.frame.height + 8
        lowerView.frame.origin.y = middleView.frame.origin.y + middleView.frame.height + 4
        lowerView.frame.size.height = self.view.frame.height - lowerView.frame.origin.y
    }
}