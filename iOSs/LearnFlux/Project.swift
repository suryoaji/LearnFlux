//
//  Project.swift
//  LearnFlux
//
//  Created by ISA on 11/18/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum typeScreenProject{
    case List
    case InsideProject
}

class Project: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfieldSearch: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        screenType = .List
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
    @IBOutlet weak var buttonTitleHeader: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var buttonCommenting: UIButton!
    @IBOutlet weak var viewContainerTextViewReply: UIView!
    @IBOutlet weak var textViewReply: UITextView!
    var titleList = ["Old Folks Home", "Animal Shelter"]
    
    var screenType = typeScreenProject.List{
        didSet{
            setTitleHeaderByScreenType(screenType)
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
}

// - MARK: TableView
extension Project: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        switch screenType {
        case .List:
            return 1
        case .InsideProject:
            return 2
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
        case .InsideProject:
            break
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
        
        let label = UILabel(frame: CGRectMake(0, 0, self.view.width, 100))
        label.text = navigationItem.title
        label.font = UIFont(name: "Helvetica Neue Medium", size: 12.0)
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
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
        
    }
    
    func revealMenu(){
        revealController.showViewController(self.revealController.leftViewController)
    }
    
    func setTitleHeaderByScreenType(screenType: typeScreenProject){
        switch screenType {
        case .List:
            buttonTitleHeader.setImage(nil, forState: .Normal)
            buttonTitleHeader.userInteractionEnabled = false
        case .InsideProject:
            buttonTitleHeader.setImage(UIImage(named: "back-24.png"), forState: .Normal)
            buttonTitleHeader.userInteractionEnabled = true
        }
    }
    
    func setButtonHeadersByScreenType(screenType: typeScreenProject){
        switch screenType {
        case .List:
            viewButtonBroadcast.frame.origin.x = view.frame.width - viewButtonBroadcast.frame.width * 2
            buttonSearchHeader.setImage(UIImage(named: "search"), forState: .Normal)
        case .InsideProject:
            viewButtonBroadcast.frame.origin.x = view.frame.width - viewButtonBroadcast.frame.width * 3
            buttonSearchHeader.setImage(UIImage(named: "add-two-people"), forState: .Normal)
        }
    }
    
    func hideTextViewReply(notif: NSNotification){
        viewContainerTextViewReply.frame.origin.y = UIScreen.mainScreen().bounds.height - viewContainerTextViewReply.frame.height
        viewContainerTextViewReply.hidden = true
        tableView.frame.size.height = UIScreen.mainScreen().bounds.height - tableView.frame.origin.y
    }
    
    func keyboardIsShown(notif: NSNotification){
        let keyboardHeight = (notif.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        viewContainerTextViewReply.frame.origin.y = middleView.frame.height - keyboardHeight - viewContainerTextViewReply.frame.height
        tableView.frame.size.height = viewContainerTextViewReply.frame.origin.y
    }
}


















