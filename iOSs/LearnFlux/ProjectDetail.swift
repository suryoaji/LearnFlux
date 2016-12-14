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
    case Edit(from: editFrom)
    case Task(type: taskType)
    enum editFrom{
        case createNew
        case editDetail
    }
    enum taskType{
        case join
        case invate
        case approving
        case accepting
        case detail
    }
    func getSectionTitle() -> Array<String>{
        switch self {
        case .Detail:
            return ["", "Mission", "Goal", "Dates", "Duration"]
        case .Task(type: let type):
            switch type {
            case .detail:
                return ["", "", "Task", "Dates", "Duration", "Remarks", "Team Members"]
            default:
                return ["", "Task", "Dates", "Duration", "Remarks"]
            }
        default: return []
        }
    }
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
    
    @IBAction func buttonActionTapped(sender: UIButton) {
        switch type {
        case .Task(type: let type):
            if type == .invate{
                performSegueWithIdentifier("ConnectionSegue", sender: self)
            }
        default: break
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var buttonActionTask: UIButton!
    @IBOutlet weak var buttonAcceptActionTask: UIButton!
    @IBOutlet weak var viewActionTasks: UIView!
}

// - MARK: PrepareForSegue
extension ProjectDetail{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let connectionVC = segue.destinationViewController as? Connections{
            connectionVC
            let flow = Flow.sharedInstance
            flow.begin(FlowName.NewProject)
        }
    }
}

// - MARK: Table View
extension ProjectDetail: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        switch tableView {
        case tableViewDetail:
            return type.getSectionTitle().count
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
            switch type {
            case .Detail:
                return heightForRowTableViewDetail(indexPath)
            case .Task(type: let type):
                switch type {
                case .detail:
                    return heightForRowTableViewTaskDetail(indexPath)
                default:
                    return heightForRowTableViewTask(indexPath)
                }
            default: return 0
            }
        case tableViewEdit:
            return heightForRowTableViewEdit(indexPath)
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        switch tableView {
        case tableViewDetail:
            switch type {
            case .Detail:
                return cellForRowTableViewDetail(indexPath)
            case .Task(type: let type):
                switch type {
                case .detail:
                    return cellForRowTableViewTaskDetail(indexPath)
                default:
                    return cellForRowTableViewTask(indexPath)
                }
            default: return UITableViewCell()
            }
        case tableViewEdit:
            return cellForRowTableViewEdit(indexPath)
        default: return UITableViewCell()
        }
    }
    
    func numberOfRowTableViewDetail(section: Int) -> Int{
        switch type {
        case .Task(type: let type):
            switch type {
            case .detail:
                return section == 6 ? 4 + 2 : 2
            case .accepting:
                return section == 0 ? 3 : 2
            default:
                return 2
            }
        default:
            return 2
        }
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
            if type.getSectionTitle()[section].isEmpty{
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
            labelTitle.text = type.getSectionTitle()[section]
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
    
    func heightForRowTableViewTask(indexPath: NSIndexPath) -> CGFloat{
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
            if type.getSectionTitle()[section].isEmpty{
                cell.frame.size.height = 0
            }else{
                let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
                cell.frame.size.height = sectionCell.height
            }
            break
        case (0, let row):
            switch type {
            case .Task(type: let type):
                switch type {
                case .accepting:
                    if row == 1{
                        let titleCell = tableViewDetail.dequeueReusableCellWithIdentifier("Title")!
                        cell.height = titleCell.height
                    }else if row == 2{
                        let ownerCell = tableViewDetail.dequeueReusableCellWithIdentifier("Owner")!
                        cell.height = ownerCell.height
                    }
                default:
                    let detailCell = tableViewDetail.dequeueReusableCellWithIdentifier("Detail")!
                    let labelDetail = detailCell.viewWithTag(2) as! UILabel
                    detailCell.frame.size.height = heightForView(labelDetail.text!, font: labelDetail.font, width: UIScreen.mainScreen().bounds.width / detailCell.width * labelDetail.width) + detailCell.height - labelDetail.height
                    cell.frame.size.height = detailCell.height
                }
            default: break
            }
        case (let section, 1):
            switch section {
            case 1:
                let taskCell = tableViewDetail.dequeueReusableCellWithIdentifier("Task")!
                let labelTask = taskCell.viewWithTag(1) as! UILabel
                taskCell.frame.size.height = heightForView(labelTask.text!, font: labelTask.font, width: UIScreen.mainScreen().bounds.width / taskCell.width * labelTask.width) + 20
                cell.frame.size.height = taskCell.height
            case 2:
                let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                cell.frame.size.height = datesCell.height
            case 3:
                let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                cell.frame.size.height = durationCell.height
            case 4:
                let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                let labelGoal = goalCell.viewWithTag(1) as! UILabel
                goalCell.frame.size.height = heightForView(labelGoal.text!, font: labelGoal.font, width: UIScreen.mainScreen().bounds.width / goalCell.width * labelGoal.width) + 10
                cell.frame.size.height = goalCell.height
            default: break
            }
        default: break
        }
        return cell.height
    }
    
    func cellForRowTableViewTask(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell(frame: CGRectZero)
        switch (indexPath.section, indexPath.row) {
        case (let section, 0):
            let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
            let labelTitle = sectionCell.viewWithTag(1) as! UILabel
            labelTitle.text = type.getSectionTitle()[section]
            cell = sectionCell
            break
        case (0, let row):
            switch type {
            case .Task(type: let type):
                if type == .accepting{
                    if row == 1{
                        let titleCell = tableViewDetail.dequeueReusableCellWithIdentifier("Title")!
                        let conView = titleCell.viewWithTag(1)!
                        conView.layer.borderWidth = 0.6
                        conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                        cell = titleCell
                    }else if row == 2{
                        let ownerCell = tableViewDetail.dequeueReusableCellWithIdentifier("Owner")!
                        let conView = ownerCell.viewWithTag(1)!
                        conView.layer.borderWidth = 0.6
                        conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                        cell = ownerCell
                    }
                }else{
                    let detailCell = tableViewDetail.dequeueReusableCellWithIdentifier("Detail")!
                    let conView = detailCell.viewWithTag(1)!
                    let editButton = detailCell.viewWithTag(3) as! UIButton
                    conView.layer.borderWidth = 0.6
                    conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                    editButton.addTarget(self, action: #selector(editButtonTapped), forControlEvents: .TouchUpInside)
                    editButton.hidden = true
                    cell = detailCell
                }
            default: break
            }
        case (let section, 1):
            switch section {
            case 1:
                let taskCell = tableViewDetail.dequeueReusableCellWithIdentifier("Task")!
                cell = taskCell
            case 2:
                let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                cell = datesCell
            case 3:
                let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                cell = durationCell
            case 4:
                let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                cell = goalCell
            default: break
            }
        default: break
        }
        return cell
    }
    
    func heightForRowTableViewTaskDetail(indexPath: NSIndexPath) -> CGFloat{
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
        case (let section, let row):
            switch row {
            case 0:
                if type.getSectionTitle()[section].isEmpty{
                    cell.frame.size.height = 0
                }else{
                    let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
                    cell.frame.size.height = sectionCell.height
                }
            default:
                switch section {
                case 0:
                    let titleCell = tableViewDetail.dequeueReusableCellWithIdentifier("Title")!
                    cell.height = titleCell.height
                case 1:
                    let ownerCell = tableViewDetail.dequeueReusableCellWithIdentifier("Owner")!
                    cell.height = ownerCell.height
                case 2:
                    let taskCell = tableViewDetail.dequeueReusableCellWithIdentifier("Task")!
                    let labelTask = taskCell.viewWithTag(1) as! UILabel
                    taskCell.frame.size.height = heightForView(labelTask.text!, font: labelTask.font, width: UIScreen.mainScreen().bounds.width / taskCell.width * labelTask.width) + 20
                    cell.frame.size.height = taskCell.height
                case 3:
                    let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                    cell.frame.size.height = datesCell.height
                case 4:
                    let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                    cell.frame.size.height = durationCell.height
                case 5:
                    let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                    let labelGoal = goalCell.viewWithTag(1) as! UILabel
                    goalCell.frame.size.height = heightForView(labelGoal.text!, font: labelGoal.font, width: UIScreen.mainScreen().bounds.width / goalCell.width * labelGoal.width) + 10
                    cell.frame.size.height = goalCell.height
                case 6:
                    if row == 5 || row == 1{
                        cell.height = 10
                    }else{
                        let memberCell = tableViewDetail.dequeueReusableCellWithIdentifier("Member")!
                        cell.height = memberCell.height
                    }
                default: break
                }
            }
        }
        return cell.height
    }
    
    func cellForRowTableViewTaskDetail(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell(frame: CGRectZero)
        switch (indexPath.section, indexPath.row) {
        case (let section, let row):
            switch row {
            case 0:
                let sectionCell = tableViewDetail.dequeueReusableCellWithIdentifier("SectionTitle")!
                let labelTitle = sectionCell.viewWithTag(1) as! UILabel
                labelTitle.text = type.getSectionTitle()[section]
                cell = sectionCell
            default:
                switch section {
                case 0:
                    let titleCell = tableViewDetail.dequeueReusableCellWithIdentifier("Title")!
                    let conView = titleCell.viewWithTag(1)!
                    conView.layer.borderWidth = 0.6
                    conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                    cell = titleCell
                case 1:
                    let ownerCell = tableViewDetail.dequeueReusableCellWithIdentifier("Owner")!
                    let conView = ownerCell.viewWithTag(1)!
                    conView.layer.borderWidth = 0.6
                    conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                    cell = ownerCell
                case 2:
                    let taskCell = tableViewDetail.dequeueReusableCellWithIdentifier("Task")!
                    cell = taskCell
                case 3:
                    let datesCell = tableViewDetail.dequeueReusableCellWithIdentifier("Dates")!
                    cell = datesCell
                case 4:
                    let durationCell = tableViewDetail.dequeueReusableCellWithIdentifier("Duration")!
                    cell = durationCell
                case 5:
                    let goalCell = tableViewDetail.dequeueReusableCellWithIdentifier("Goal")!
                    cell = goalCell
                case 6:
                    if indexPath.row != 1 && indexPath.row != 5{
                        let memberCell = tableViewDetail.dequeueReusableCellWithIdentifier("Member")!
                        let conView = memberCell.viewWithTag(1)!
                        conView.layer.borderWidth = 0.6
                        conView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
                        cell = memberCell
                    }
                default: break
                }
            }
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
            viewActionTasks.hidden = true
        case .Edit:
            containerView.hidden = true
            editView.hidden = false
            viewActionTasks.hidden = true
        case .Task(type: let type):
            containerView.hidden = false
            editView.hidden = true
            switch type {
            case .invate:
                viewActionTasks.hidden = false
                buttonActionTask.setTitle("Select collaborator from Contact Book", forState: .Normal)
                tableViewDetail.frame.size.height = view.height - viewActionTasks.height - UIApplication.sharedApplication().statusBarFrame.height
            case .join:
                viewActionTasks.hidden = false
                buttonActionTask.setTitle("Join Project", forState: .Normal)
                tableViewDetail.frame.size.height = view.height - viewActionTasks.height - UIApplication.sharedApplication().statusBarFrame.height
            case .detail:
                viewActionTasks.hidden = true
                tableViewDetail.frame.size.height = view.height - UIApplication.sharedApplication().statusBarFrame.height
            case .approving:
                viewActionTasks.hidden = false
                buttonActionTask.hidden = true
                buttonAcceptActionTask.setTitle("Approve", forState: .Normal)
                tableViewDetail.frame.size.height = view.height - viewActionTasks.height - UIApplication.sharedApplication().statusBarFrame.height
            case .accepting:
                viewActionTasks.hidden = false
                buttonActionTask.hidden = true
                buttonAcceptActionTask.setTitle("Joining as task owner", forState: .Normal)
                tableViewDetail.frame.size.height = view.height - viewActionTasks.height - UIApplication.sharedApplication().statusBarFrame.height
            }
        }
    }
    
    func editButtonTapped(sender: UIButton){
        showView(.Edit(from: .editDetail))
    }
    
    func cancelEditTapped(sender: UIBarButtonItem){
        switch type {
        case .Edit(from: let from):
            switch from {
            case .createNew:
                popNavCon()
            case .editDetail:
                showView(.Detail)
            }
        default:
            popNavCon()
        }
    }
    
    func popNavCon(){
        if let navCon = navigationController{
            navCon.popViewControllerAnimated(true)
        }
    }
    
    func setBarButtonNavController(){
        switch type {
        case .Edit:
            let leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelEditTapped))
            let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(rightNavigationBarButtonTapped))
            navigationItem.leftBarButtonItem = leftBarButton
            navigationItem.rightBarButtonItem = rightBarButton
        case .Detail, .Task:
            let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarButton
            navigationItem.leftBarButtonItem = nil
        }
    }
    
}
















