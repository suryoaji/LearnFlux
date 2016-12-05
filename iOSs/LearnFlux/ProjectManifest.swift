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
    
    @IBOutlet weak var containerView: UIView!
}

// - MARK: TableView
extension ProjectManifest: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell = tableView.dequeueReusableCellWithIdentifier("header")!
        case (1, let row):
            row
            cell = tableView.dequeueReusableCellWithIdentifier("list")!
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
            row
            cell = tableView.dequeueReusableCellWithIdentifier("list")!
            
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
}

























