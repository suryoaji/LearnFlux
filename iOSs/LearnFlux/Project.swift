//
//  Project.swift
//  LearnFlux
//
//  Created by ISA on 11/18/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum TypeScreenProject{
    case List
    case InsideProject
    func indicatorHeader() -> Int{
        switch self {
        case .List:
            return 0
        case .InsideProject:
            return 1
        }
    }
}

class Project: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfieldSearch: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .List
        setTitleView(navigationItem.title!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideTextViewReply), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardIsShown), name: UIKeyboardWillShowNotification, object: nil)
        mockUp()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var doSearch = false
    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var viewButtonBroadcast: UIView!
    @IBOutlet weak var buttonSearchHeader: UIButton!
    @IBOutlet weak var buttonHeaderList: UIButton!
    @IBOutlet weak var buttonHeaderProfile: UIButton!
    @IBOutlet weak var indicatorHeaderView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var buttonCommenting: UIButton!
    @IBOutlet weak var viewContainerTextViewReply: UIView!
    @IBOutlet weak var textViewReply: UITextView!
    var titleList = ["Old Folks Home", "Animal Shelter"]
    
    var screenType = TypeScreenProject.List{
        didSet{
            indicatorHeader = screenType.indicatorHeader()
            setButtonHeadersByScreenType(screenType)
            buttonCommenting.hidden = screenType == .List ? true : false
            tableView.reloadData()
        }
    }
    
    @IBAction func buttonCommentingTapped(sender: UIButton) {
        viewContainerTextViewReply.hidden = !viewContainerTextViewReply.hidden
        textViewReply.becomeFirstResponder()
    }
    
    @IBAction func buttonTitleHeaderTapped(sender: UIButton) {
        screenType = screenType == .InsideProject ? .List : .InsideProject
    }
    
    @IBAction func buttonSearchHeaderTapped(sender: UIButton) {
        switch screenType {
        case .List:
            viewSearch.alpha = 1.0
            textfieldSearch.becomeFirstResponder()
        case .InsideProject:
            break
        }
    }
    
    @IBAction func textfieldSearchChanged(sender: UITextField) {
        doSearch = sender.text!.isEmpty ? false : true
    }
    
    @IBAction func buttonBackSearch(sender: UIButton) {
        viewSearch.alpha = 0
        textfieldSearch.resignFirstResponder()
        doSearch = false
    }
    
    @IBAction func viewListHeaderTapped(sender: UIButton) {
        screenType = .List
    }
    
    var indicatorHeader : Int = 0{
        willSet{
            moveIndicatorView(newValue)
        }
    }
}

// - MARK: TableView
extension Project: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        switch screenType {
        case .List:
            return 1
        case .InsideProject:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cell = UITableViewCell()
        switch screenType {
        case .List:
            cell = tableView.dequeueReusableCellWithIdentifier("ListCell")!
        case .InsideProject:
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("InsideListCell")!
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("InsideListCommentedCell")!
            case 2:
                cell.height = UIScreen.mainScreen().bounds.height - buttonCommenting.frame.origin.y - middleView.frame.origin.y + 5
            default: break
            }
        }
        return cell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch screenType {
        case .List:
            return 2
        case .InsideProject:
            switch section {
            case 0:
                return 1
            case 1:
                return 3
            case 2:
                return 1
            default: return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch screenType {
        case .List:
            cell = tableView.dequeueReusableCellWithIdentifier("ListCell")!
            let buttonIcon = cell.viewWithTag(1) as! UIButton
            let buttonLike = cell.viewWithTag(2) as! UIButton
            let buttonSave = cell.viewWithTag(3) as! UIButton
            let labelTitle = cell.viewWithTag(4) as! UILabel
            labelTitle.text = titleList[indexPath.row]
            buttonIcon.tintColor = indexPath.row % 2 == 1 ? UIColor(white: 220.0/255, alpha: 1) : LFColor.green
            buttonLike.tintColor = buttonIcon.tintColor
            buttonSave.tintColor = indexPath.row % 2 == 1 ? UIColor(white: 220.0/255, alpha: 1) : UIColor(red: 1.0, green: 207.0/255, blue: 0, alpha: 1)
            cell.contentView.layer.borderWidth = 0.6
            cell.contentView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        case .InsideProject:
            switch indexPath.section{
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("InsideListCell")!
                let projectView = cell.viewWithTag(1)!
                projectView.layer.borderWidth = 0.6
                projectView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1).CGColor
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("InsideListCommentedCell")!
            default: break
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        view.endEditing(true)
        switch screenType {
        case .List:
            screenType = .InsideProject
            indicatorHeader = 1
        case .InsideProject:
            break
        }
    }
}

// : MARK: Perform Segue
extension Project{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let projectDetailVc = segue.destinationViewController as? ProjectDetail{
            if let sender = sender as? Int{
                switch sender {
                case -1:
                    projectDetailVc.type = .Edit
                default: break
                }
            }
        }
    }
}

// - MARK: Mock Up
extension Project{
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
        headerView.bounds.size.height = navigationController!.navigationBar.bounds.height
        headerView.frame.origin.y = navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        middleView.frame.origin.y = headerView.frame.origin.y + headerView.frame.height + 14
        middleView.frame.size.height = UIScreen.mainScreen().bounds.height - middleView.frame.origin.y
        labelNotification.layer.cornerRadius = labelNotification.frame.width / 2
        viewContainerTextViewReply.hidden = true
    }
    
    func rightNavigationBarButtonTapped(){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        let createNewProjectAlert = UIAlertAction(title: "Create New Project", style: .Default){ action in
            self.performSegueWithIdentifier("ProjectDetailSegue", sender: -1)
        }
        let cancelAlert = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(createNewProjectAlert)
        alertController.addAction(cancelAlert)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func revealMenu(){
        revealController.showViewController(self.revealController.leftViewController)
    }
    
    func setTitleView(title: String){
        let label = UILabel(frame: CGRectMake(0, 0, self.view.width, 100))
        label.text = title
        label.font = UIFont(name: "Helvetica Neue Medium", size: 12.0)
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    func moveIndicatorView(position: Int){
        let button = position == 0 ? buttonHeaderList : buttonHeaderProfile
        let fromButton = position == 0 ? buttonHeaderProfile : buttonHeaderList
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.setPositionIndicatorHeaderView(button, fromButton: fromButton)
            }, completion: nil)
    }
    
    func setPositionIndicatorHeaderView(toButton: UIButton, fromButton: UIButton? = nil){
        fromButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        toButton.setTitleColor(LFColor.blue, forState: .Normal)
        indicatorHeaderView.frame.origin.x = toButton.frame.origin.x
        indicatorHeaderView.frame.size.width = toButton.bounds.width
    }
    
    func setButtonHeadersByScreenType(screenType: TypeScreenProject){
        switch screenType {
        case .List:
            viewButtonBroadcast.frame.origin.x = view.frame.width - viewButtonBroadcast.frame.width * 2
            buttonSearchHeader.setImage(UIImage(named: "search"), forState: .Normal)
            buttonHeaderProfile.hidden = true
        case .InsideProject:
            viewButtonBroadcast.frame.origin.x = view.frame.width - viewButtonBroadcast.frame.width * 3
            buttonSearchHeader.setImage(UIImage(named: "add-two-people"), forState: .Normal)
            buttonHeaderProfile.hidden = false
        }
    }
    
    func hideTextViewReply(notif: NSNotification){
        viewContainerTextViewReply.frame.origin.y = UIScreen.mainScreen().bounds.height - viewContainerTextViewReply.frame.height
        viewContainerTextViewReply.hidden = true
        tableView.frame.size.height = UIScreen.mainScreen().bounds.height - middleView.frame.origin.y
    }
    
    func keyboardIsShown(notif: NSNotification){
        let keyboardHeight = (notif.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        viewContainerTextViewReply.frame.origin.y = middleView.frame.height - keyboardHeight - viewContainerTextViewReply.frame.height
        tableView.frame.size.height = viewContainerTextViewReply.frame.origin.y
    }
}


















