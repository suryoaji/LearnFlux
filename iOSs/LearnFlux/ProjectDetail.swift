//
//  ProjectDetail.swift
//  LearnFlux
//
//  Created by ISA on 11/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class ProjectDetail: UIViewController {

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

    let sectionTitle = ["", "Mission", "Goal", "Dates", "Duration"]
    @IBOutlet weak var containerView: UIView!
    @IBAction func buttonBackTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

// - MARK: Table View
extension ProjectDetail: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return sectionTitle.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell = UITableViewCell(frame: CGRectZero)
        cell.frame.size.height = 0
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            if sectionTitle[section].isEmpty{
                cell.frame.size.height = 0
            }else{
                let sectionCell = tableView.dequeueReusableCellWithIdentifier("SectionTitle")!
                cell.frame.size.height = sectionCell.height
            }
        case (let section, 1):
            switch section {
            case 0:
                let detailCell = tableView.dequeueReusableCellWithIdentifier("Detail")!
                cell.frame.size.height = detailCell.height
            case 1:
                let missionCell = tableView.dequeueReusableCellWithIdentifier("Mission")!
                cell.frame.size.height = missionCell.height
            case 2:
                let goalCell = tableView.dequeueReusableCellWithIdentifier("Goal")!
                cell.frame.size.height = goalCell.height
            case 3:
                let datesCell = tableView.dequeueReusableCellWithIdentifier("Dates")!
                cell.frame.size.height = datesCell.height
            case 4:
                let durationCell = tableView.dequeueReusableCellWithIdentifier("Duration")!
                cell.frame.size.height = durationCell.height
            default: break
            }
        default: break
        }
        return cell.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell(frame: CGRectZero)
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            let sectionCell = tableView.dequeueReusableCellWithIdentifier("SectionTitle")!
            let labelTitle = sectionCell.viewWithTag(1) as! UILabel
            labelTitle.text = sectionTitle[section]
            cell = sectionCell
        case (let section, 1):
            switch section {
            case 0:
                let detailCell = tableView.dequeueReusableCellWithIdentifier("Detail")!
                let conView = detailCell.viewWithTag(1)!
                conView.layer.borderWidth = 0.6
                conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                cell = detailCell
            case 1:
                let missionCell = tableView.dequeueReusableCellWithIdentifier("Mission")!
                cell = missionCell
            case 2:
                let goalCell = tableView.dequeueReusableCellWithIdentifier("Goal")!
                cell = goalCell
            case 3:
                let datesCell = tableView.dequeueReusableCellWithIdentifier("Dates")!
                cell = datesCell
            case 4:
                let durationCell = tableView.dequeueReusableCellWithIdentifier("Duration")!
                cell = durationCell
            default: break
            }
        default: break
        }
        return cell
    }
}

// - MARK: MockUp
extension ProjectDetail{
    func mockUp(){
        setAccNavBar()
    }
    
    func setAccNavBar(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "menu-1.png"), style: .Plain, target: self, action: #selector(revealMenu))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        layoutWithNavBar()
    }
    
    func layoutWithNavBar(){
        containerView.frame.origin.y = navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        containerView.frame.size.height = UIScreen.mainScreen().bounds.height - containerView.frame.origin.y
    }
    
    func rightNavigationBarButtonTapped(){
        
    }
    
    func revealMenu(){
        revealController.showViewController(self.revealController.leftViewController)
    }
    
}