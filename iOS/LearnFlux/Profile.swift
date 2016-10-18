//
//  Profile.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/15/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Profile : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var clientData = Engine.clientData
    @IBOutlet weak var buttonHeaderMyProfile: UIButton!
    @IBOutlet weak var buttonHeaderConnection: UIButton!
    @IBOutlet weak var buttonHeaderFriendRequest: UIButton!
    @IBOutlet weak var buttonHeaderNotification: UIButton!
    @IBOutlet weak var tableViewMyProfile: UITableView!
    @IBOutlet weak var tableViewConnectionUpper: UITableView!
    @IBOutlet weak var tableViewConnectionLower: UITableView!
    @IBOutlet weak var tableViewFriendRequest: UITableView!
    @IBOutlet weak var tableViewNotification: UITableView!
    @IBOutlet weak var tableViewListInterests: UITableView!
    @IBOutlet weak var tableViewListOrganizations: UITableView!
    @IBOutlet weak var buttonSeeAllUpper: UIButton!
    @IBOutlet weak var buttonSeeAllLower: UIButton!
    @IBOutlet weak var buttonAddAccConnection: UIButton!
    @IBOutlet weak var labelSuggesting: UILabel!
    @IBOutlet weak var containerViewTableViewConnectionUpper: UIView!
    @IBOutlet weak var containerViewTableViewConnectionLower: UIView!
    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var labelFriendRequest: UILabel!
    var originalSizeConnectionTableView: CGRect = CGRectZero
    
    var shouldShowOrganizations = false{
        didSet{
            tableViewMyProfile.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .None)
        }
    }
    
    var indicatorHeader : Int = 0{
        willSet{
            moveIndicatorView(newValue)
        }
    }
    
    var indicatorAccConnection : Int = 0{
        didSet{
            hideSeeAllButton()
            tableViewConnectionUpper.reloadData()
            tableViewConnectionLower.reloadData()
            
        }
        willSet{
            buttonAddAccConnection.setTitle(titleAddAccConnection[newValue], forState: .Normal)
            labelSuggesting.text = titleSuggesting[newValue]
        }
    }
    
    var shouldSeeAllUpper : Bool = false{
        didSet{
            if shouldSeeAllUpper{
                expandContainerTableViewConnectionUpper()
            }else{
                minimizeContainerTableViewConnectionUpper()
            }
        }
    }
    
    @IBAction func buttonSeeAllUpperTapped(sender: UIButton) {
        if indicatorAccConnection == 2{
            shouldSeeAllUpper = !shouldSeeAllUpper
        }
    }
    
    func hideSeeAllButton(){
        let shouldHide = shouldHideSeeAllButton()
        buttonSeeAllUpper.hidden = shouldHide.0
        buttonSeeAllLower.hidden = shouldHide.1
    }
    
    func activeAccConnection() -> (lower: Int, upper: Int){
        switch indicatorAccConnection {
        case 0:
            return (lower: suggestContacts.count, upper: clientData.getMyConnection()?.count ?? 0)
        case 1:
            let groups = clientData.getGroups(.InterestGroup)
            return(lower: suggestGroups.count, upper: groups!.count)
        case 2:
            let organizations = clientData.getGroups(.Organisation)
            return(lower: suggestOrganizations.count, upper: organizations!.count)
        case 3:
            return(lower: 0, upper: allContacts.count)
        default:
            return(lower: 0, upper: 0)
        }
    }
    
    func shouldHideSeeAllButton() -> (Bool, Bool){
        let activeAccConnections = activeAccConnection()
        return (activeAccConnections.upper > 3 ? false : true, activeAccConnections.lower > 3 ? false : true)
    }
    
    let sectionTitle = ["", "My Children", "Affiliated organizations", "Interests"]
    let friendRequestSectionTitle = ["Connections", "People you may know"]
    let rowInterest = ["Physical Health", "Environmental Science", "Child Education"]
    var roles = ""
    
    let titleAddAccConnection = ["+ add contact", "+ add group", "+ add organizations", "+ add contacts"]
    let titleSuggesting = ["People you may know", "Groups you might interested", "Organizations you might interested", "People you may know"]
    let suggestContacts = [["name" : "Alice Whitsmans",
                            "side" : "Art and Craft Teacher",
                            "photo" : "male01.png"],
                           ["name" : "Jack Whitsmans",
                            "side" : "Associate Engineer",
                            "photo" : "male02.png"],
                           ["name" : "Jones Pearson",
                            "side" : "Physician",
                            "photo" : "male03.png"],
                           ["name" : "Jones Pearson",
                            "side" : "Physician",
                            "photo" : "male04.png"]]
    
    var groups = [Group]()
    let suggestGroups = [["name" : "Whitman's Youth Team",
                   "side" : "Art and Craft Teacher"],
                  ["name" : "Jones's Youth Team",
                   "side" : "Associate Engineer"],
                  ["name" : "Ngenes's Youth Team",
                   "side" : "Physician"],
                  ["name" : "Ngenes's Youth Team",
                   "side" : "Physician"]]
    
    let suggestOrganizations = [["name"  : "Pen's Wah Organization",
                                 "side"  : "Art and Craft Teacher",
                                 "photo" : "company1.png"],
                                ["name"  : "Apple's Ooh Organization",
                                 "side"  : "Associate Engineer",
                                 "photo" : "company2.png"],
                                ["name"  : "Pineapple's Organization",
                                 "side"  : "Physician",
                                 "photo" : "company3.png"],
                                ["name"  : "Pineapple's Organization",
                                 "side"  : "Physician",
                                 "photo" : "company3.png"]]
    
    var allContacts : Array<Dictionary<String, String>> = []
    
    var friendRequests = [Dictionary<String, AnyObject>](){
        didSet{
            tableViewFriendRequest.reloadData()
            for friend in friendRequests{
                if friend["key"] as! String != ""{
                    Engine.getImageIndividual(id: friend["id"] as! String){ image in
                        if let index = self.friendRequests.indexOf({ $0["id"] as! String == friend["id"] as! String }){
                            if image != nil{
                                self.friendRequests[index]["photo"] = image!
                                self.tableViewFriendRequest.reloadRowsAtIndexPaths([NSIndexPath(forRow: index + 1, inSection: 0)], withRowAnimation: .Fade)
                            }
                            self.friendRequests[index]["key"] = ""
                        }
                    }
                }
            }
        }
    }
    let suggestFriendConnections = [["name"   : "Lee Chopong Kin",
                                     "photo"  : "male10.png",
                                     "friends": "1"],
                                    ["name"   : "Mervyn Yeoh",
                                     "photo"  : "male11.png",
                                     "friends": "6"],
                                    ["name"   : "Caren Chong",
                                     "photo"  : "female07.png",
                                     "friends": "9"]]
    
    let notifications = [["name"      : "Child Development Club",
                          "photo"     : "company4.png",
                          "to"        : "Child Education Singapore",
                          "activity"  : "posted in",
                          "timestamp" : "42 minutes ago",
                          "icon"      : "notification1.png",
                          "checked"   : "0"],
                         ["name"      : "Andrew Chea",
                          "photo"     : "male09.png",
                          "to"        : "Child Education Singapore",
                          "activity"  : "commented on a post you are following in",
                          "timestamp" : "3 hours ago",
                          "icon"      : "notification1.png",
                          "checked"   : "1"],
                         ["name"      : "John Ang",
                          "photo"     : "male08.png",
                          "to"        : "SG Cares",
                          "activity"  : "commented on post you are following at",
                          "timestamp" : "6 hours ago",
                          "icon"      : "notification3.png",
                          "checked"   : "0"],
                         ["name"      : "Jean Lee",
                          "photo"     : "female06.png",
                          "activity"  : "mentioned you in a comment",
                          "timestamp" : "9 hours ago",
                          "icon"      : "notification2.png",
                          "checked"   : "1"],
                         ["name"      : "Michelle Leong",
                          "photo"     : "female05.png",
                          "activity"  : "replied to a comment that you're tagged in",
                          "timestamp" : "Yesterday at 00:50",
                          "icon"      : "notification1.png",
                          "checked"   : "0"]]
    
    let kids = ["kid1.png", "kid2.png", "kid3.png"]
    
    @IBAction func buttonHeadersTapped(sender: UIButton) {
        if let title = sender.currentTitle{
            switch title.lowercaseString {
            case "my profile":
                indicatorHeader = 0
                hideNotificationViews()
            case "connection":
                indicatorHeader = 1
                hideNotificationViews()
            default:
                break
            }
        }else{
            showNotificationViews(sender.tag)
        }
    }
    
    func loadDataForScreen(){
        Engine.getAvailableInterests(){ interests in
            if let interests = interests{
                self.interests = interests
            }
        }
        Engine.getFriendRequests(){ friends in
            if let friends = friends{
                self.friendRequests = friends
            }
        }
        Engine.getChildsOfAllOrganizations(){ groups in
            if let groups = groups{
                self.groups = groups
            }
        }
        Engine.getSelfRoles{ roles in
            if let roles = roles{
                self.roles = roles
            }
        }
        Engine.getAllContacts(){ dictContacts in
            self.allContacts = dictContacts
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataForScreen()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mockUpFirstAppear()
        originalSizeConnectionTableView = tableViewConnectionLower.frame
    }
    
    func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        
    }
    
    func showOrganizations(sender: UIButton){
        shouldShowOrganizations = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
        case tableViewMyProfile:
            return sectionTitle.count
        case tableViewFriendRequest:
            return 2
        case tableViewListInterests:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tableViewMyProfile:
            return numberOfRowTableViewMyProfile(section)
        case tableViewConnectionUpper:
            return numberOfRowTableViewConnectionUpper()
        case tableViewConnectionLower:
            return numberOfRowTableViewConnectionLower()
        case tableViewFriendRequest:
            return numberOfRowTableViewFriendRequest(section)
        case tableViewNotification:
            return numberOfRowTableViewNotification(section)
        case tableViewListInterests:
            return numberOfRowTableViewListInterests(section)
        case tableViewListOrganizations:
            return numberOfRowTableViewListOrganizations(section)
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var cell = UITableViewCell()
        switch tableView {
        case tableViewMyProfile:
            cell = cellForRowTableViewMyProfile(indexPath)
        case tableViewFriendRequest:
            cell = cellForRowTableViewFriendRequest(indexPath)
        case tableViewNotification:
            cell = cellForRowTableViewNotification(indexPath)
        case tableViewListInterests:
            cell = cellForRowTableViewListInterests(indexPath)
        case tableViewListOrganizations:
            cell = cellForRowTableViewListOrganizations(indexPath)
        default:
            cell.height = (originalSizeConnectionTableView.height - buttonSeeAllUpper.frame.height) / 3
        }
        return cell.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case tableViewMyProfile:
            cell = self.cellForRowTableViewMyProfile(indexPath)
        case tableViewConnectionUpper:
            cell = self.cellForRowTableViewConnectionUpper(indexPath)
        case tableViewConnectionLower:
            cell = self.cellForRowTableViewConnectionLower(indexPath)
        case tableViewFriendRequest:
            cell = self.cellForRowTableViewFriendRequest(indexPath)
        case tableViewNotification:
            cell = self.cellForRowTableViewNotification(indexPath)
        case tableViewListInterests:
            cell = self.cellForRowTableViewListInterests(indexPath)
        case tableViewListOrganizations:
            cell = self.cellForRowTableViewListOrganizations(indexPath)
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case tableViewMyProfile:
            didSelectRowTableViewMyProfile(indexPath)
        case tableViewConnectionUpper:
            didSelectRowTableViewConnectionUpper(indexPath)
        case tableViewConnectionLower:
            didSelectRowTableViewConnectionLower(indexPath)
        default:
            break
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        if tableView == tableViewConnectionUpper && indicatorAccConnection == 3{
            return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        }
        return nil
    }
    
    var shouldMoreLabelRoles = false
    var shouldMockUp = true
    var shouldEditMyProfile = false{
        didSet{
            tableViewMyProfile.reloadData()
        }
    }
    var indicatorAccConnectionView = UIView()
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var indicatorHeaderView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var containerViewConnection: UIView!
    @IBOutlet weak var accIndividualView: UIView!
    @IBOutlet weak var accGroupsView: UIView!
    @IBOutlet weak var accOrganizationsView: UIView!
    @IBOutlet weak var accContactView: UIView!
    @IBOutlet weak var viewFriendRequest: NotificationView!
    @IBOutlet weak var viewNotification: NotificationView!
    @IBOutlet weak var viewEditInterest: NotificationView!
    @IBOutlet weak var viewEditAffiliatedOrganization: NotificationView!
    
    var interests = [String](){
        didSet{
            tableViewListInterests.reloadData()
        }
    }
    
    var organizations = [["image" : "company7.png",
                          "name"  : "LASSALE Collage of The Arts"],
                         ["image" : "company6.png",
                          "name"  : "National Council of Social Service"],
                         ["image" : "company5.png",
                          "name"  : "Singapore Cares"],
                         ["image" : "company1.png",
                          "name"  : "Name of Organization"],
                         ["image" : "company2.png",
                          "name"  : "Name of Organization"]]
    
    @IBAction func accConnectionTapped(sender: UIButton) {
        let row = abs(sender.tag - 10)
        self.indicatorAccConnection = row
        selectAccConnection(row, animated: true)
        
        if indicatorAccConnection == 3{
            shouldSeeAllUpper = true
            buttonSeeAllUpper.hidden = true
        }else{
            shouldSeeAllUpper = false
        }
    }
}

// - MARK TableView Helper
extension Profile{
    func numberOfRowTableViewConnectionLower() -> Int{
        switch indicatorAccConnection {
        case 0:
            return suggestContacts.count >= 3 ? 3 : suggestContacts.count
        case 1:
            return suggestGroups.count >= 3 ? 3 : suggestGroups.count
        case 2:
            return suggestOrganizations.count >= 3 ? 3 : suggestOrganizations.count
        case 3:
            return 0
        default:
            return 0
        }
    }
    
    func numberOfRowTableViewConnectionUpper() -> Int{
        switch indicatorAccConnection {
        case 0:
            if clientData.getMyConnection() != nil{
                return clientData.getMyConnection()!.count >= 3 ? 3 : clientData.getMyConnection()!.count
            }
        case 1:
            return groups.count >= 3 ? 3 : groups.count
        case 2:
            if let organizations = clientData.getGroups(.Organisation){
                return organizations.count
            }
        case 3:
            return allContacts.count
        default:
            return 0
        }
        return 0
    }
    
    func numberOfRowTableViewMyProfile(section: Int) -> Int{
        switch section {
        case 3:
            return shouldEditMyProfile ? 2 : rowInterest.count + 3
        default:
            return 2
        }
    }
    
    func numberOfRowTableViewFriendRequest(section: Int) -> Int{
        switch section {
        case 0:
            return friendRequests.count + 1
        case 1:
            return suggestFriendConnections.count + 1
        default:
            return 0
        }
    }
    
    func numberOfRowTableViewNotification(section: Int) -> Int{
        return 5
    }
    
    func numberOfRowTableViewListInterests(section: Int) -> Int{
        switch section {
        case 0:
            return 1
        default:
            return interests.count
        }
    }
    
    func numberOfRowTableViewListOrganizations(section: Int) -> Int{
        return organizations.count
    }
    
    func cellForRowTableViewMyProfile(indexPath: NSIndexPath) -> UITableViewCell{
        return shouldEditMyProfile ? cellForRowTableViewMyProfileEdit(indexPath) : cellForRowTableViewMyProfileNormal(indexPath)
    }
    
    func cellForRowTableViewMyProfileNormal(indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let headerCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("headerSection") as! SectionTitleCell
            headerCell.customInit(sectionTitle[indexPath.section], indexPath: indexPath, titleEdit: "+ edit profile")
            headerCell.delegate = self
            return headerCell
        }else{
            switch indexPath.section{
            case 0:
                let profileCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("1") as! RowProfileCell
                profileCell.delegate = self
                let values = ["photo" : clientData.photo,
                              "id"    : clientData.cacheMe()!["id"]!,
                              "name"  : "\(clientData.cacheMe()!["first_name"] as! String) \(clientData.cacheMe()!["first_name"] as! String)",
                              "roles" : self.roles]
                profileCell.setValues(values, scale: self.view.frame.width / profileCell.frame.width, stateMore: shouldMoreLabelRoles)
                return profileCell
            case 1:
                let childrenCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("5")!
                let collectionView = childrenCell.viewWithTag(2) as! UICollectionView
                collectionView.reloadData()
                return childrenCell
            case 2:
                let organizationCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("2")!
                let collectionView = organizationCell.viewWithTag(1) as! UICollectionView
                if self.shouldShowOrganizations{ collectionView.frame.size.width = organizationCell.frame.width }
                collectionView.reloadData()
                return organizationCell
            case 3:
                let interestCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("3") as! RowInterestsCell
                interestCell.customInit(rowInterest, indexPath: indexPath)
                return interestCell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func cellForRowTableViewMyProfileEdit(indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let headerCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("headerSection") as! SectionTitleCell
            headerCell.customInit(sectionTitle[indexPath.section], indexPath: indexPath, icon: "save", titleEdit: "save")
            headerCell.delegate = self
            return headerCell
        }else{
            switch indexPath.section{
            case 0:
                let profileCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit1")!
                return profileCell
            case 1:
                let childrenCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit2")!
                let collectionView = childrenCell.viewWithTag(3) as! UICollectionView
                collectionView.reloadData()
                return childrenCell
            case 2:
                let organizationCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit3")!
                let buttonAllCauses = organizationCell.viewWithTag(2) as! UIButton
                buttonAllCauses.addTarget(self, action: #selector(buttonAllCausesTapped), forControlEvents: .TouchUpInside)
                return organizationCell
            case 3:
                let interestCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit4")!
                let buttonAllCauses = interestCell.viewWithTag(1) as! UIButton
                buttonAllCauses.addTarget(self, action: #selector(buttonAllCausesTapped), forControlEvents: .TouchUpInside)
                return interestCell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func cellForRowTableViewListInterests(indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableViewListInterests.dequeueReusableCellWithIdentifier("Cell")!
        let buttonChecked = cell.viewWithTag(1) as! UIButton
        let labelInterest = cell.viewWithTag(2) as! UILabel
        switch indexPath.section {
        case 0:
            labelInterest.text = "All Causes"
        default:
            labelInterest.text = interests[indexPath.row]
            if indexPath.row == 0 || indexPath.row == 8{
                buttonChecked.tintColor = LFColor.green
            }
        }
        return cell
    }
    
    func cellForRowTableViewListOrganizations(indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableViewListOrganizations.dequeueReusableCellWithIdentifier("Cell")!
        let imageView = cell.viewWithTag(1) as! UIImageView
        let labelOrganization = cell.viewWithTag(2) as! UILabel
        imageView.image = UIImage(named: organizations[indexPath.row]["image"]!)
        labelOrganization.text = organizations[indexPath.row]["name"]
        return cell
    }
    
    func cellForRowTableViewConnectionUpper(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch indicatorAccConnection {
        case 0:
            let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
            individualCell.setValues(clientData.getMyConnection()![indexPath.row])
            Engine.getPhotoOfConnection(indexPath){ success in
                if success{
                    self.tableViewConnectionUpper.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
            cell = individualCell
        case 1:
            let groupCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Group") as! GroupCell
            groupCell.delegate = self
            groupCell.setValues(indexPath, group: groups[indexPath.row], type: 0)
            cell = groupCell
        case 2:
            let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
            let organizations = clientData.getGroups(.Organisation)
            organizationCell.setValues(organizations![indexPath.row])
            cell = organizationCell
        case 3:
            switch allContacts[indexPath.row]["type"]! {
            case "individual":
                let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
                let index = clientData.getMyConnection()!.indexOf({ $0.userId! == Int(allContacts[indexPath.row]["id"]!)! })
                individualCell.setValues(clientData.getMyConnection()![index!])
                if clientData.getMyConnection()![index!].photo == nil{
                    Engine.getPhotoOfConnection(NSIndexPath(forRow: index!, inSection: 0)){ success in
                        if success{
                            self.tableViewConnectionUpper.reloadRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .None)
                        }
                    }
                    
                }
                cell = individualCell
            case "group":
                let groupCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Group") as! GroupCell
                groupCell.delegate = self
                let index = groups.indexOf({ $0.id == allContacts[indexPath.row]["id"]! })
                groupCell.setValues(NSIndexPath(forRow: index!, inSection: 0), group: groups[index!])
                cell = groupCell
            case "organization":
                let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
                let organizations = clientData.getGroups(.Organisation)!
                let index = organizations.indexOf({ $0.id == allContacts[indexPath.row]["id"] })
                organizationCell.setValues(organizations[index!])
                cell = organizationCell
            default: break
            }
            cell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
        default: break
        }
        return cell
    }
    
    func cellForRowTableViewConnectionLower(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch indicatorAccConnection {
        case 0:
            let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
            individualCell.setValues(suggestContacts[indexPath.row])
            cell = individualCell
        case 1:
            let groupCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Group") as! GroupCell
            groupCell.setValues(indexPath, group: suggestGroups[indexPath.row], type: 1)
            cell = groupCell
        case 2:
            let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
            organizationCell.setValues(suggestOrganizations[indexPath.row], type: 1)
            cell = organizationCell
        default: break
        }
        return cell
    }
    
    func cellForRowTableViewFriendRequest(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell = tableViewFriendRequest.dequeueReusableCellWithIdentifier("Header")!
            let labelHeader = cell.viewWithTag(1) as! UILabel
            labelHeader.text = friendRequestSectionTitle[indexPath.section]
        default:
            let friendRequestCell = tableViewFriendRequest.dequeueReusableCellWithIdentifier("Cell") as! FriendRequestCell
            let friendDict = indexPath.section == 0 ? friendRequests[indexPath.row - 1] : suggestFriendConnections[indexPath.row - 1]
            friendRequestCell.setValues(friendDict, indexPath: indexPath)
            cell = friendRequestCell
        }
        return cell
    }
    
    func cellForRowTableViewNotification(indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableViewNotification.dequeueReusableCellWithIdentifier("Cell") as! NotificationCell
        cell.setValues(notifications[indexPath.row])
        return cell
    }
    
    func didSelectRowTableViewMyProfile(indexPath: NSIndexPath){
        
    }
    
    func didSelectRowTableViewConnectionUpper(indexPath: NSIndexPath){
        switch indicatorAccConnection {
        case 0:
            break
        case 1:
            self.performSegueWithIdentifier("GroupSegue", sender: indexPath.row)
        case 2:
            self.performSegueWithIdentifier("OrgSegue", sender: indexPath.row)
        case 3:
            switch allContacts[indexPath.row]["type"]! {
            case "individual":
                break
            case "group":
                let index = self.groups.indexOf({ $0.id == allContacts[indexPath.row]["id"]! })
                self.performSegueWithIdentifier("GroupSegue", sender: index!)
            case "organization":
                let index = clientData.getGroups(.Organisation)!.indexOf({ $0.id == allContacts[indexPath.row]["id"]! })
                self.performSegueWithIdentifier("OrgSegue", sender: index!)
            default: break
            }
        default:
            break
        }
    }
    
    func didSelectRowTableViewConnectionLower(indexPath: NSIndexPath){
        
    }
}

// - MARK Collection View
extension Profile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch collectionView.tag {
        case 1:
            if let count = clientData.getGroups(.Organisation)?.count{
                if shouldShowOrganizations{
                    return count
                }else{
                    return count > 3 ? 4 : count
                }
            }
        case 2:
            return 4
        case 3:
            return 1
        default: return 0
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = UICollectionViewCell()
        switch collectionView.tag {
        case 1:
            if indexPath.row == 3 && !self.shouldShowOrganizations{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddMore", forIndexPath: indexPath)
                let number = cell.viewWithTag(1) as! UILabel
                let button = cell.viewWithTag(2) as! UIButton
                number.layer.cornerRadius = number.bounds.size.width / 2
                number.text = "\(clientData.getGroups(.Organisation)!.count - 3)"
                button.enabled = true
                button.addTarget(self, action: #selector(showOrganizations), forControlEvents: .TouchUpInside)
            }else{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
                let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
                imageViewPhoto.image = clientData.getGroups(.Organisation)![indexPath.row].image ?? UIImage(named: "company1.png")
            }
        case 2:
            if indexPath.row == 3{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddMore", forIndexPath: indexPath)
                let number = cell.viewWithTag(1) as! UILabel
                number.layer.cornerRadius = number.bounds.size.width / 2
            }else{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
                let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
                imageViewPhoto.image = UIImage(named: kids[indexPath.row])
            }
        case 3:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        default: break
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        switch collectionView.tag {
        case 1:
            if indexPath.row == 3 && !self.shouldShowOrganizations{
                return CGSizeMake(40, 70)
            }else{
                return CGSizeMake(80, 70)
            }
        case 2:
            if indexPath.row == 3{
                return CGSizeMake(40, 50)
            }else{
                return CGSizeMake(50, 50)
            }
        case 3:
            return CGSizeMake(65, 65)
        default: return CGSizeZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionView.tag {
        case 1:
            if indexPath.row == 3 && !self.shouldShowOrganizations{
            }else{
                self.performSegueWithIdentifier("OrgSegue", sender: indexPath.row)
            }
        case 2:
            break
        case 3:
            break
        default: break
        }
    }
    
}

// - MARK MOCK UP
extension Profile{
    func mockUpFirstAppear(){
        if shouldMockUp{
            mockUp()
            indicatorAccConnection = 0
            shouldMockUp = false
        }
    }
    
    func mockUp(){
        setAccNavBar()
        setScrollView()
        setConnectionView()
        
        viewFriendRequest.customInit(self, viewIndicator: buttonHeaderFriendRequest)
        viewNotification.customInit(self, viewIndicator: buttonHeaderNotification)
    }
    
    func setAccNavBar(){
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self, action: #selector(rightNavigationBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
        layoutWithNavBar()
    }
    
    func layoutWithNavBar(){
        headerView.bounds.size.height = self.navigationController!.navigationBar.bounds.height
        headerView.frame.origin.y = self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        labelNotification.layer.cornerRadius = labelNotification.frame.width / 2
        labelFriendRequest.layer.cornerRadius = labelFriendRequest.frame.width / 2
        setPositionIndicatorHeaderView(buttonHeaderMyProfile)
    }
    
    func moveIndicatorView(position: Int = 0){
        let button = position == 0 ? self.buttonHeaderMyProfile : self.buttonHeaderConnection
        let fromButton = position == 0 ? self.buttonHeaderConnection : self.buttonHeaderMyProfile
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.setPositionIndicatorHeaderView(button, fromButton: fromButton)
            self.setOffsetScrollView(position)
            }, completion: nil)
    }
    
    func setPositionIndicatorHeaderView(toButton: UIButton, fromButton: UIButton? = nil){
        fromButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        toButton.setTitleColor(LFColor.blue, forState: .Normal)
        indicatorHeaderView.frame.origin.x = toButton.frame.origin.x
        indicatorHeaderView.frame.size.width = toButton.bounds.width
    }
    
    func setScrollView(){
        
        let yPosition = headerView.frame.origin.y + headerView.frame.height
        let height = self.view.height - yPosition
        containerScrollView.frame.origin.y = yPosition
        containerScrollView.frame.size.height = height
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.width * 2, containerScrollView.frame.height)
        containerScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        tableViewMyProfile.frame = CGRectMake(0, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height)
        
        containerViewConnection.frame = CGRectMake(containerScrollView.frame.size.width, 0, containerScrollView.frame.size.width, containerScrollView.frame.size.height)
    }
    
    func setOffsetScrollView(position: Int){
        containerScrollView.contentOffset = CGPointMake(CGFloat(position) * containerScrollView.bounds.width, 0)
    }

    func setConnectionView(){
        selectAccConnection()
    }
    
    func selectAccConnection(indicator: Int = 0, animated: Bool = false){
        guard let selectedAccConnectionView = getAccSelected(indicator) else{
            return
        }
        removeIndicatorView()
        layoutIndicatorView(selectedAccConnectionView, animated: animated)
    }
    
    func layoutIndicatorView(selectedView: UIView, animated: Bool){
        let label = selectedView.viewWithTag(1) as! UILabel
        let widthStringLabel = NSString(string: label.text!).sizeWithAttributes([NSFontAttributeName : label.font]).width
        let expectedWidth = widthStringLabel > selectedView.bounds.width ? selectedView.bounds.width : widthStringLabel
        let xPosition = (selectedView.bounds.width - expectedWidth) / 2
        indicatorAccConnectionView = UIView(frame: CGRectMake(xPosition, 0, expectedWidth, 5))
        indicatorAccConnectionView.backgroundColor = LFColor.green
        indicatorAccConnectionView.frame.origin.y = selectedView.frame.height - indicatorAccConnectionView.frame.size.height
        indicatorAccConnectionView.tag = 9898
        selectedView.addSubview(indicatorAccConnectionView)
        if animated{
            indicatorAccConnectionView.transform = CGAffineTransformMakeScale(0, 1)
            UIView.animateWithDuration(0.14, delay: 0.07, options: .CurveEaseIn, animations: {
                self.indicatorAccConnectionView.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    
    func removeIndicatorView(){
        let views = [accIndividualView, accGroupsView, accOrganizationsView, accContactView]
        for view in views{
            if let indicatorView = view.viewWithTag(9898){
                indicatorView.removeFromSuperview()
            }
        }
    }
    
    func getAccSelected(indicator: Int) -> UIView?{
        switch indicator {
        case 0:
            return accIndividualView
        case 1:
            return accGroupsView
        case 2:
            return accOrganizationsView
        case 3:
            return accContactView
        default:
            return nil
        }
    }
    
    func expandContainerTableViewConnectionUpper(){
        containerViewTableViewConnectionUpper.frame.size.height = containerViewTableViewConnectionLower.frame.origin.y + containerViewTableViewConnectionLower.frame.height - containerViewTableViewConnectionUpper.frame.origin.y
        self.view.bringSubviewToFront(containerViewTableViewConnectionUpper)
        tableViewConnectionUpper.scrollEnabled = true
        tableViewConnectionUpper.frame.size.height = indicatorAccConnection == 3 ? containerViewTableViewConnectionUpper.frame.height : containerViewTableViewConnectionUpper.frame.height - buttonSeeAllUpper.frame.height
    }
    
    func minimizeContainerTableViewConnectionUpper(){
        containerViewTableViewConnectionUpper.frame.size.height = originalSizeConnectionTableView.size.height
        tableViewConnectionUpper.scrollEnabled = false
        tableViewConnectionUpper.frame.size.height = containerViewTableViewConnectionUpper.frame.height
    }
    
    func showNotificationViews(senderTag: Int){
        switch senderTag {
        case 1:
            labelFriendRequest.hidden = !labelFriendRequest.hidden
            viewFriendRequest.hidden = !viewFriendRequest.hidden
            viewNotification.hidden = true
            labelNotification.hidden = false
        case 2:
            labelNotification.hidden = !labelNotification.hidden
            viewNotification.hidden = !viewNotification.hidden
            viewFriendRequest.hidden = true
            labelFriendRequest.hidden = false
        case 3:
            break
        default: break
        }
    }
    
    func hideNotificationViews(){
        viewFriendRequest.hidden = true
        viewNotification.hidden = true
        labelFriendRequest.hidden = false
        labelNotification.hidden = false
    }
    
    func buttonAllCausesTapped(sender: UIButton){
        let holdView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        holdView.backgroundColor = UIColor.clearColor()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(holdViewTapped))
        holdView.addGestureRecognizer(gesture)
        self.view.addSubview(holdView)
        switch sender.tag {
        case 1:
            viewEditInterest.customInit(self, viewIndicator: sender, type: .Row)
        case 2:
            viewEditAffiliatedOrganization.customInit(self, viewIndicator: sender, type: .Row)
        default: break
        }
        
    }
    
    func holdViewTapped(gesture: UITapGestureRecognizer){
        gesture.view?.removeFromSuperview()
        viewEditInterest.hidden = true
        viewEditAffiliatedOrganization.hidden = true
    }
    
}

// - MARK Perform Segues
extension Profile{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OrgSegue"{
            let orgDetailController = segue.destinationViewController as! OrgDetails
            var group = Group(type: "", id: "", name: "")
            group = clientData.getGroups(.Organisation)![sender as! Int]
            orgDetailController.initView(group.id, orgTitle: group.name, indexTab: 0)
        }else if segue.identifier == "GroupSegue"{
            let groupDetailController = segue.destinationViewController as! GroupDetails
            let group = groups[sender as! Int]
            groupDetailController.initFromCall(group)
        }else if segue.identifier == "ChatSegue"{
            let chatController = segue.destinationViewController as! ChatFlow
            let group = groups[sender as! Int]
            let indexThread = clientData.getMyThreads()!.indexOf({ $0.id == group.threadId! })!
            chatController.initChat(indexThread, idThread: group.threadId!, from: .OpenChat)
        }
    }
}

// - MARK: SectionTitleCell My Profile Delegate
extension Profile: SectionTitleCellDelegate{
    func editButtonTapped(cell: SectionTitleCell){
        if !shouldEditMyProfile{
            switch cell.indexPath.section {
            case 0:
                shouldEditMyProfile = true
            default: break
            }
        }else{
            shouldEditMyProfile = false
        }
    }
}

// - MARK: GroupCell My Profile Delegate
extension Profile: GroupCellDelegate{
    func buttonActionTapped(cell: GroupCell) {
        if cell.indexPath != nil{
            performSegueWithIdentifier("ChatSegue", sender: cell.indexPath.row)
        }
    }
}

// - MARK: RowProfileCell My Profile Delegate
extension Profile: RowProfileCellDelegate{
    func buttonMoreTapped(cell: RowProfileCell) {
        shouldMoreLabelRoles = true
        tableViewMyProfile.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
    }
}













