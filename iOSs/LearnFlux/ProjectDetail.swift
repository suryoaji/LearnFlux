//
//  ProjectDetail.swift
//  LearnFlux
//
//  Created by ISA on 11/21/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum ProjectDetailType{
    case Detail
    case Edit
}

class ProjectDetail: UIViewController {
    var type : ProjectDetailType = .Detail
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var tableViewEdit: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewByType()
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
    @IBOutlet weak var editView: UIView!
}

// - MARK: Table View
extension ProjectDetail: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        switch tableView {
        case tableViewDetail:
            return numberOfSectionTableViewDetail()
        case tableViewEdit:
            return numberOfSectionTableViewEdit()
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch tableView {
        case tableViewDetail:
            return numberOfRowTableViewDetail(section)
        case tableViewEdit:
            return numberOfRowTableViewEdit(section)
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        switch tableView {
        case tableViewDetail:
            return heightForRowTableViewDetail(indexPath)
        case tableViewEdit:
            return heightForRowTableViewEdit(indexPath)
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        switch tableView {
        case tableViewDetail:
            return cellForRowTableViewDetail(indexPath)
        case tableViewEdit:
            return cellForRowTableViewEdit(indexPath)
        default: return UITableViewCell()
        }
    }
    
    func numberOfSectionTableViewDetail() -> Int{
        return sectionTitle.count
    }
    
    func numberOfRowTableViewDetail(section: Int) -> Int{
        return 2
    }
    
    func heightForRowTableViewDetail(indexPath: NSIndexPath) -> CGFloat{
        func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByCharWrapping
            label.font = font
            label.text = text
            label.sizeToFit()
            return label.frame.height
        }
        
        let cell = UITableViewCell(frame: CGRectZero)
        cell.frame.size.height = 0
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            if sectionTitle[section].isEmpty{
                cell.frame.size.height = 0
            }else{
                let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
                cell.frame.size.height = sectionCell.height
            }
        case (let section, 1):
            switch section {
            case 0:
                let detailCell = tableViewDetail.dequeueReusableCellWithIdentifier("Detail")!
                let labelDetail = detailCell.viewWithTag(2) as! UILabel
                detailCell.frame.size.height = heightForView(labelDetail.text!, font: labelDetail.font, width: UIScreen.mainScreen().bounds.width / detailCell.width * labelDetail.width) + detailCell.height - labelDetail.height
                cell.frame.size.height = detailCell.height
            case 1:
                let missionCell = tableViewDetail.dequeueReusableCellWithIdentifier("Mission")!
                let labelMission = missionCell.viewWithTag(1) as! UILabel
                missionCell.frame.size.height = heightForView(labelMission.text!, font: labelMission.font, width: UIScreen.mainScreen().bounds.width / missionCell.width * labelMission.width) + 10
                cell.frame.size.height = missionCell.height
            case 2:
                let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                let labelGoal = goalCell.viewWithTag(1) as! UILabel
                goalCell.frame.size.height = heightForView(labelGoal.text!, font: labelGoal.font, width: UIScreen.mainScreen().bounds.width / goalCell.width * labelGoal.width) + 10
                cell.frame.size.height = goalCell.height
            case 3:
                let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                cell.frame.size.height = datesCell.height
            case 4:
                let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                cell.frame.size.height = durationCell.height
            default: break
            }
        default: break
        }
        return cell.height
    }
    
    func cellForRowTableViewDetail(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell(frame: CGRectZero)
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
            let labelTitle = sectionCell.viewWithTag(1) as! UILabel
            labelTitle.text = sectionTitle[section]
            cell = sectionCell
        case (let section, 1):
            switch section {
            case 0:
                let detailCell = tableViewDetail.dequeueReusableCellWithIdentifier("Detail")!
                let conView = detailCell.viewWithTag(1)!
                let editButton = detailCell.viewWithTag(3) as! UIButton
                conView.layer.borderWidth = 0.6
                conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                editButton.addTarget(self, action: #selector(editButtonTapped), forControlEvents: .TouchUpInside)
                cell = detailCell
            case 1:
                let missionCell = tableViewDetail.dequeueReusableCellWithIdentifier("Mission")!
                cell = missionCell
            case 2:
                let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                cell = goalCell
            case 3:
                let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                cell = datesCell
            case 4:
                let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                cell = durationCell
            default: break
            }
        default: break
        }
        return cell
    }
    
    func numberOfSectionTableViewEdit() -> Int{
        return 5
    }
    
    func numberOfRowTableViewEdit(section: Int) -> Int{
        return 1
    }
    
    func heightForRowTableViewEdit(indexPath: NSIndexPath) -> CGFloat{
        let cell = cellForRowTableViewEdit(indexPath)
        return cell.height
    }
    
    func cellForRowTableViewEdit(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            switch section {
            case 0:
                let cell1 = tableViewEdit.dequeueReusableCellWithIdentifier("1")!
                let containerView = cell1.viewWithTag(1)!
                containerView.layer.borderWidth = 0.6
                containerView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                
                cell = cell1
            case 1:
                let cell2 = tableViewEdit.dequeueReusableCellWithIdentifier("2")!
                
                cell = cell2
            case 2:
                let cell3 = tableViewEdit.dequeueReusableCellWithIdentifier("3")!
                
                cell = cell3
            case 3:
                let cell4 = tableViewEdit.dequeueReusableCellWithIdentifier("4")!
                
                cell = cell4
            case 4:
                let cell5 = tableViewEdit.dequeueReusableCellWithIdentifier("5")!
                
                cell = cell5
            default: break
            }
        default:
            break
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
        setBarButtonNavController()
        layoutWithNavBar()
    }
    
    func layoutWithNavBar(){
        containerView.frame.origin.y = navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        containerView.frame.size.height = UIScreen.mainScreen().bounds.height - containerView.frame.origin.y
        editView.frame.origin.y = containerView.frame.origin.y
        editView.frame.size.height = containerView.height
    }
    
    func rightNavigationBarButtonTapped(){
        
    }
    
    func revealMenu(){
        revealController.showViewController(self.revealController.leftViewController)
    }
    
    func showView(type: ProjectDetailType){
        self.type = type
        showViewByType()
        setBarButtonNavController()
    }
    
    func showViewByType(){
        switch type {
        case .Detail:
            containerView.hidden = false
            editView.hidden = true
        case .Edit:
            containerView.hidden = true
            editView.hidden = false
        }
    }
    
    func editButtonTapped(sender: UIButton){
        showView(.Edit)
    }
    
    func backEditTapped(sender: UIBarButtonItem){
        showView(.Detail)
    }
    
    func setBarButtonNavController(){
        switch type {
        case .Edit:
            let leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(backEditTapped))
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(rightNavigationBarButtonTapped))
            navigationItem.leftBarButtonItem = leftBarButton
            navigationItem.rightBarButtonItem = rightBarButton
        case .Detail:
            let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.leftBarButtonItem = nil
        }
    }
    
}
















