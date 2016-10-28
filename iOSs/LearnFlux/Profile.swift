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
    @IBOutlet weak var tableViewListConnection: UITableView!
    @IBOutlet weak var tableViewChildrenDetail: UITableView!
    @IBOutlet weak var tableViewSearchResult: UITableView!
    @IBOutlet weak var buttonSeeAllUpper: UIButton!
    @IBOutlet weak var buttonSeeAllLower: UIButton!
    @IBOutlet weak var buttonAddAccConnection: UIButton!
    @IBOutlet weak var labelSuggesting: UILabel!
    @IBOutlet weak var containerViewTableViewConnectionUpper: UIView!
    @IBOutlet weak var containerViewTableViewConnectionLower: UIView!
    @IBOutlet weak var labelNotification: UILabel!
    @IBOutlet weak var labelFriendRequest: UILabel!
    @IBOutlet weak var textfieldSearch: UITextField!
    var originalSizeConnectionTableView: CGRect = CGRectZero
    var searchResult = (users: [User](), groups: [Group]()){
        didSet{
            getImageSearchResult(&searchResult)
            tableViewSearchResult.reloadData()
            loadImageResult(searchResult)
        }
    }
    var conImageResult : Array<(id: String, image: UIImage)> = []
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Load Image when search
    func getImageSearchResult(inout result: (users: [User], groups:[Group])){
        var users = result.users
        var groups = result.groups
        for i in 0..<users.count{
            if users[i].photo == nil{
                if let index = conImageResult.indexOf({ $0.id == String(users[i].userId!) }){
                    users[i].photo = conImageResult[index].image
                }
            }
        }
        for i in 0..<groups.count{
            if groups[i].image == nil{
                if let index = conImageResult.indexOf({ $0.id == String(groups[i].id) }){
                    groups[i].image = conImageResult[index].image
                }
            }
        }
    }
    
    func loadImageResult(result: (users: [User], groups: [Group])){
        let users = result.users
        let groups = result.groups
        for i in 0..<users.count{
            if users[i].photo == nil{
                Engine.getImageIndividual(self, id: String(users[i].userId!)){ image in
                    if let image = image{
                        self.conImageResult.append((id: String(users[i].userId!), image: image))
                        self.tableViewSearchResult.reloadRowsAtIndexPaths([NSIndexPath(forRow: i + 1, inSection: 0)], withRowAnimation: .None)
                    }
                }
            }
        }
        for i in 0..<groups.count{
            if groups[i].image == nil{
                Engine.getImageGroup(group: groups[i]){image in
                    if let image = image{
                        self.conImageResult.append((id: groups[i].id, image: image))
                        self.tableViewSearchResult.reloadRowsAtIndexPaths([NSIndexPath(forRow: i + 1, inSection: 1)], withRowAnimation: .None)
                    }
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    enum ConnectionType{
        case Individual
        case Group
        case Organization
        case InterestGroup
    }
    
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
    
    let sectionTitle = ["", "My Children", "Affiliated organizations", "Interests", "Connections"]
    let friendRequestSectionTitle = ["Connections", "People you may know"]
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
    
    var allContacts : Dictionary<String, Array<Dictionary<String, String>>> = [:]
    var allContactsSectionIndex = Array<String>()
    
    var friendRequests = [User](){
        didSet{
            labelFriendRequest.text = "\(friendRequests.count)"
            labelFriendRequest.hidden = friendRequests.count > 0 ? false : true
            tableViewFriendRequest.reloadData()
            
            if indicatorHeader == 1 && (indicatorAccConnection == 0 || indicatorAccConnection == 3){
                tableViewConnectionUpper.reloadData()
            }
        }
    }
    var suggestFriendConnections = Array<Dictionary<String, AnyObject>>(){
        didSet{
            tableViewFriendRequest.reloadData()
        }
    }
    
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
    
    @IBAction func buttonHeadersTapped(sender: UIButton) {
        if let title = sender.currentTitle{
            switch title.lowercaseString {
            case "my profile":
                indicatorHeader = 0
                hideNotificationViews()
            case "connection":
                indicatorHeader = 1
                hideNotificationViews()
            default: break
            }
        }else{
            switch sender.tag {
            case 1, 2:
                showNotificationViews(sender.tag)
            case 3:
                viewSearch.alpha = 1.0
                textfieldSearch.becomeFirstResponder()
                hideNotificationViews()
                viewChildrenProfileNotification.hidden = true
            default: break
            }
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
        Engine.getAllContacts(){ arrDictContacts in
            self.allContacts = Engine.generateContactsByFirstLetter(arrDictContacts)
            self.allContactsSectionIndex = [String](self.allContacts.keys)
            self.allContactsSectionIndex.sortInPlace({ $0 < $1 })
        }
        
        //loadSuggestFriend
        self.suggestFriendConnections = Engine.getSuggestFriends()
        let maxCount = self.suggestFriendConnections.count > 5 ? 5 : self.suggestFriendConnections.count
        for i in 0..<maxCount{
            if self.suggestFriendConnections[i]["photo"] == nil{
                Engine.getImageIndividual(id: String(self.suggestFriendConnections[i]["id"] as! Int)){ image in
                    if let image = image{
                        self.suggestFriendConnections[i]["photo"] = image
                        self.tableViewFriendRequest.reloadRowsAtIndexPaths([NSIndexPath(forRow: i + 1, inSection: 1)], withRowAnimation: .None)
                    }else{
                        self.suggestFriendConnections[i]["photo"] = UIImage(named: "photo-container.png")
                    }
                }
            }
        }
        ////////////
        
        Engine.getNotifications(self){ notifs in
            print(notifs)
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
        
        if !shouldEditMyProfile{ tableViewMyProfile.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 4)], withRowAnimation: .None) }
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
        case tableViewConnectionUpper:
            return indicatorAccConnection == 3 ? allContacts.count : 1
        case tableViewSearchResult:
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
            return numberOfRowTableViewConnectionUpper(section)
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
        case tableViewListConnection:
            return numberOfRowTableViewListConnections(section)
        case tableViewChildrenDetail:
            return numberOfRowTableViewChildrenDetail(section)
        case tableViewSearchResult:
            return numberOfRowTableViewSearchResult(section)
        default:
            if tableView.tag == 1{
                return numberOfRowTableViewConnectionMyProfile(section)
            }
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
        case tableViewListConnection:
            cell = cellForRowTableViewListConnections(indexPath)
        case tableViewSearchResult:
            switch indexPath.row {
            case 0:
                cell = cellForRowTableViewSearchResult(indexPath)
            default:
                cell.height = (originalSizeConnectionTableView.height - buttonSeeAllUpper.frame.height) / 3
            }
        case tableViewChildrenDetail:
            switch indexPath.row {
            case 0:
                return tableViewChildrenDetail.frame.height * 0.6
            default:
                cell = cellForRowTableViewChildrenDetail(indexPath)
            }
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
        case tableViewListConnection:
            cell = self.cellForRowTableViewListConnections(indexPath)
        case tableViewChildrenDetail:
            cell = self.cellForRowTableViewChildrenDetail(indexPath)
        case tableViewSearchResult:
            cell = self.cellForRowTableViewSearchResult(indexPath)
        default:
            if tableView.tag == 1{
                cell = cellForRowTableViewConnectionMyProfile(tableView, indexPath: indexPath)
            }
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
        case tableViewListInterests:
            didSelectRowTableViewListInterests(indexPath)
        default:
            if tableView.tag == 1{
                didSelectRowTableViewConnectionMyProfile(tableView, indexPath: indexPath)
            }
            break
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        if tableView == tableViewConnectionUpper && indicatorAccConnection == 3{
            return allContactsSectionIndex
        }
        return nil
    }
    
    var doSearch = false{
        didSet{
            if doSearch{
                viewResultSearch.hidden = false
                Engine.requestSearch(keySearch: textfieldSearch.text!){ data in
                    var users = data.0
                    var groups = data.1
                    for i in 0..<users.count{
                        if let index = self.clientData.getMyConnection()!.indexOf({ $0.userId! == users[i].userId! }){
                            users[i] = self.clientData.getMyConnection()![index]
                        }
                    }
                    for i in 0..<groups.count{
                        if let index = self.groups.indexOf({ $0.id == groups[i].id }){
                            groups[i] = self.groups[index]
                        }else if let index = self.clientData.getGroups()!.indexOf({ $0.id == groups[i].id }){
                            groups[i] = self.clientData.getGroups()![index]
                        }
                    }
                    self.searchResult = (users: users, groups: groups)
                }
            }else{
                viewResultSearch.hidden = true
            }
        }
    }
    
    var conditionPhotoEdited = false{
        didSet{
            if self.shouldEditMyProfile == false{
                self.tableViewMyProfile.reloadDataSection(0, animate: false)
            }
        }
    }
    var listInterestChecked : Set<String> = []
    var childLastTapped = -1
    var shouldMoreLabelRoles = false
    var shouldMockUp = true
    var shouldEditMyProfile = false{
        didSet{
            tableViewMyProfile.reloadData()
        }
        willSet{
            if newValue == true{
                viewChildrenProfileNotification.hidden = true
            }
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
    @IBOutlet weak var viewEditConnection: NotificationView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewChildrenProfileNotification: NotificationView!
    @IBOutlet weak var viewResultSearch: NotificationView!
    
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
    var connections = [["photo" : "male01.png",
                        "side"  : "Art and Craft Teacher",
                        "name"  : "This Is A Pen"],
                       ["photo" : "male02.png",
                        "side"  : "Associate Engineer",
                        "name"  : "This is An Apple"],
                       ["photo" : "male03.png",
                        "side"  : "Physician",
                        "name"  : "Hop"],
                       ["photo" : "male04.png",
                        "side" : "Physician",
                        "name"  : "ApplePen"],
                       ["photo" : "male05.png",
                        "side" : "Physician",
                        "name"  : "This Is A Pen"]]
    
    func getConnectionsMyProfileData() -> Array<ConnectionType>{
        var types = Array<ConnectionType>()
        if !clientData.getMyConnection()!.isEmpty{ types.append(.Individual) }
        if !clientData.getGroups(.Organisation)!.isEmpty{ types.append(.Organization) }
        if !clientData.getFilteredGroup(.ByInterestGroup).isEmpty{ types.append(.InterestGroup) }
        if !groups.isEmpty{ types.append(.Group) }
        return types
    }
    
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
    
    @IBAction func textfieldSearchChanged(sender: UITextField) {
        if sender.text!.isEmpty{
            doSearch = false
        }else{
            doSearch = true
        }
    }
    
    @IBAction func buttonBackSearch(sender: UIButton) {
        viewSearch.alpha = 0
        textfieldSearch.resignFirstResponder()
        doSearch = false
    }
    
}

// - MARK TableView Helper
extension Profile{
    func numberOfRowTableViewSearchResult(section: Int) -> Int{
        switch section {
        case 0:
            return searchResult.users.isEmpty ? 0 : searchResult.users.count + 1
        case 1:
            return searchResult.groups.isEmpty ? 0 : searchResult.groups.count + 1
        default: return 0
        }
    }
    
    func numberOfRowTableViewConnectionMyProfile(section: Int) -> Int{
        return getConnectionsMyProfileData().count
    }
    
    func numberOfRowTableViewChildrenDetail(section: Int) -> Int{
        if childLastTapped < clientData.getMyChildrens().count && childLastTapped >= 0{
            let childrenData = clientData.getMyChildrens()[childLastTapped]
            if let interests = childrenData.interests{
                return interests.count + 2
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    
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
    
    func numberOfRowTableViewConnectionUpper(section: Int) -> Int{
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
            return allContacts[allContactsSectionIndex[section]]!.count
        default:
            return 0
        }
        return 0
    }
    
    func numberOfRowTableViewMyProfile(section: Int) -> Int{
        switch section {
        case 3:
            let interests = clientData.cacheSelfInterests()
            return shouldEditMyProfile ? 2 : interests.count + 3
        default:
            return 2
        }
    }
    
    func numberOfRowTableViewFriendRequest(section: Int) -> Int{
        switch section {
        case 0:
            return friendRequests.isEmpty ? 0 : friendRequests.count + 1
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
    
    func numberOfRowTableViewListConnections(section: Int) -> Int{
        return connections.count
    }
    
    func cellForRowTableViewSearchResult(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        let titleHeader = ["Users", "Groups"]
        if indexPath.row == 0{
            cell = tableViewFriendRequest.dequeueReusableCellWithIdentifier("Header")!
            let labelHeader = cell.viewWithTag(1) as! UILabel
            labelHeader.text = titleHeader[indexPath.section]
        }else{
            switch indexPath.section {
            case 0:
                let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
                let user = searchResult.users[indexPath.row - 1]
                if let index = clientData.getMyConnection()!.indexOf({ $0.userId! == user.userId! }){
                    individualCell.setValues(clientData.getMyConnection()![index], indexPath: indexPath, type: .Friend)
                }else{
                    individualCell.setValues(searchResult.users[indexPath.row - 1], indexPath: indexPath, type: .NotFriend)
                }
                individualCell.delegate = self
                cell = individualCell
            case 1:
                let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
                let group = searchResult.groups[indexPath.row - 1]
                organizationCell.delegate = self
                if let index = self.groups.indexOf({ $0.id == group.id }){
                    organizationCell.setValues(self.groups[index], indexPath : indexPath, type: .Mine, forSearch: true)
                }else if let index = clientData.getGroups()!.indexOf({ $0.id == group.id }){
                    organizationCell.setValues(clientData.getGroups()![index], indexPath : indexPath, type: .Mine, forSearch: true)
                }else{
                    organizationCell.setValues(searchResult.groups[indexPath.row - 1], indexPath: indexPath, type: .NotMine, forSearch: true)
                }
                cell = organizationCell
            default: break
            }
        }
        return cell
    }
    
    func cellForRowTableViewChildrenDetail(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if childLastTapped < clientData.getMyChildrens().count && childLastTapped >= 0{
            let childrenData = clientData.getMyChildrens()[childLastTapped]
            switch indexPath.row {
            case 0:
                cell = tableViewChildrenDetail.dequeueReusableCellWithIdentifier("Cell")!
                let imageView = cell.viewWithTag(1) as! UIImageView
                let labelName = cell.viewWithTag(2) as! UILabel
                imageView.image = childrenData.photo ?? UIImage(named: "photo-container.png")
                labelName.text = childrenData.lastName != nil ? "\(childrenData.firstName!) \(childrenData.lastName!)" : "\(childrenData.firstName!)"
            case 1:
                cell = tableViewChildrenDetail.dequeueReusableCellWithIdentifier("InterestHeader")!
            default:
                let interestCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("3") as! RowInterestsCell
                interestCell.customInit(childrenData.interests ?? [], indexPath: indexPath)
                cell = interestCell
            }
        }
        return cell
    }
    
    func cellForRowTableViewMyProfile(indexPath: NSIndexPath) -> UITableViewCell{
        return shouldEditMyProfile ? cellForRowTableViewMyProfileEdit(indexPath) : cellForRowTableViewMyProfileNormal(indexPath)
    }
    
    func cellForRowTableViewMyProfileNormal(indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            switch indexPath.section {
            case 1:
                if !clientData.getMyChildrens().isEmpty{
                    fallthrough
                }else{
                    break
                }
            case 2:
                if !clientData.getGroups(.Organisation)!.isEmpty{
                    let headerCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("headerSection") as! SectionTitleCell
                    headerCell.customInit(sectionTitle[indexPath.section], indexPath: indexPath, titleEdit: "+ edit profile")
                    headerCell.delegate = self
                    return headerCell
                }else{
                    break
                }
            case 3:
                if !clientData.cacheSelfInterests().isEmpty{
                    fallthrough
                }else{
                    break
                }
            case 4:
                if !getConnectionsMyProfileData().isEmpty{
                    fallthrough
                }else{
                    break
                }
            default:
                let headerCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("headerSection") as! SectionTitleCell
                headerCell.customInit(sectionTitle[indexPath.section], indexPath: indexPath, titleEdit: "+ edit profile")
                headerCell.delegate = self
                return headerCell
            }
        }else{
            switch indexPath.section{
            case 0:
                let profileCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("1") as! RowProfileCell
                profileCell.delegate = self
                let values = ["photo" : clientData.photo,
                              "id"    : clientData.cacheSelfId(),
                              "name"  : clientData.cacheFullname(),
                              "roles" : self.roles,
                              "from"  : clientData.cacheSelfFrom(),
                              "work"  : clientData.cacheSelfWork()]
                profileCell.setValues(values, scale: self.view.frame.width / profileCell.frame.width, stateMore: shouldMoreLabelRoles)
                if conditionPhotoEdited{
                    Util.showIndicatorDarkOverlay(profileCell.imageViewPhoto)
                }else{
                    Util.stopIndicator(profileCell.imageViewPhoto)
                }
                
                return profileCell
            case 1:
                if !clientData.getMyChildrens().isEmpty{
                    let childrenCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("5")!
                    let collectionView = childrenCell.viewWithTag(2) as! UICollectionView
                    collectionView.reloadData()
                    return childrenCell
                }else{
                    break
                }
            case 2:
                if !clientData.getGroups(.Organisation)!.isEmpty{
                    let organizationCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("2")!
                    let collectionView = organizationCell.viewWithTag(1) as! UICollectionView
                    let number = organizationCell.viewWithTag(2) as! UILabel
                    let button = organizationCell.viewWithTag(3) as! UIButton
                    let containerButtonNumber = organizationCell.viewWithTag(4)!
                    if shouldShowOrganizations{
                        containerButtonNumber.hidden = true
                        collectionView.frame.size.width = organizationCell.frame.width
                    }else{
                        containerButtonNumber.hidden = clientData.getGroups(.Organisation)!.count > 3 ? false : true
                        number.layer.cornerRadius = number.bounds.size.width / 2
                        number.text = "\(clientData.getGroups(.Organisation)!.count - 3)"
                        button.enabled = true
                        button.addTarget(self, action: #selector(showOrganizations), forControlEvents: .TouchUpInside)
                    }
                    collectionView.reloadData()
                    return organizationCell
                }else{
                    break
                }
            case 3:
                if clientData.cacheSelfInterests().isEmpty{
                    break
                }else{
                    let interestCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("3") as! RowInterestsCell
                    interestCell.customInit(clientData.cacheSelfInterests(), indexPath: indexPath)
                    return interestCell
                }
            case 4:
                if getConnectionsMyProfileData().isEmpty{
                    break
                }else{
                    let connectionCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("6")!
                    let connectionTableView = connectionCell.viewWithTag(1) as! UITableView
                    connectionTableView.reloadData()
                    connectionCell.height = originalSizeConnectionTableView.size.height * 4/3 + connectionTableView.superview!.frame.origin.y
                    return connectionCell
                }
            default: break
            }
        }
        
        let cellZero = UITableViewCell()
        cellZero.frame.size.height = 0
        return cellZero
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
                let editProfileCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit1") as! RowEditProfileCell
                let param = ["photo" : clientData.photo,
                             "name"  : clientData.cacheFullname(),
                             "roles" : self.roles,
                             "work"  : clientData.cacheSelfWork(),
                             "from"  : clientData.cacheSelfFrom()]
                editProfileCell.setValues(self,values: param)
                return editProfileCell
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
            case 4:
                let connectionCell = tableViewMyProfile.dequeueReusableCellWithIdentifier("edit5")!
                let buttonAllCauses = connectionCell.viewWithTag(3) as! UIButton
                buttonAllCauses.addTarget(self, action: #selector(buttonAllCausesTapped), forControlEvents: .TouchUpInside)
                return connectionCell
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
            buttonChecked.tintColor = listInterestChecked == Set(interests) ? LFColor.green : UIColor(white: 245.0/255, alpha: 1.0)
        default:
            labelInterest.text = interests[indexPath.row]
            if listInterestChecked.contains({ $0.lowercaseString == interests[indexPath.row].lowercaseString }){
                buttonChecked.tintColor = LFColor.green
            }else{
                buttonChecked.tintColor = UIColor(white: 245.0/255, alpha: 1.0)
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
    
    func cellForRowTableViewListConnections(indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableViewListConnection.dequeueReusableCellWithIdentifier("Cell")!
        let imageView = cell.viewWithTag(4) as! UIImageView
        let labelName = cell.viewWithTag(2) as! UILabel
        let labelSide = cell.viewWithTag(3) as! UILabel
        imageView.frame.size.width = imageView.frame.size.height
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.image = UIImage(named: connections[indexPath.row]["photo"]!)
        labelName.text = connections[indexPath.row]["name"]
        labelSide.text = connections[indexPath.row]["side"]
        return cell
    }
    
    func cellForRowTableViewConnectionUpper(indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch indicatorAccConnection {
        case 0:
            let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
            individualCell.setValues(clientData.getMyConnection()![indexPath.row], indexPath: indexPath)
            individualCell.delegate = self
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
            organizationCell.setValues(organizations![indexPath.row], indexPath: indexPath)
            cell = organizationCell
        case 3:
            var contacts = allContacts[allContactsSectionIndex[indexPath.section]]!
            switch contacts[indexPath.row]["type"]! {
            case "individual":
                let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
                let index = clientData.getMyConnection()!.indexOf({ $0.userId! == Int(contacts[indexPath.row]["id"]!)! })
                individualCell.setValues(clientData.getMyConnection()![index!], indexPath: NSIndexPath(forRow: index!, inSection: 0))
                individualCell.delegate = self
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
                let index = groups.indexOf({ $0.id == contacts[indexPath.row]["id"]! })
                groupCell.setValues(NSIndexPath(forRow: index!, inSection: 0), group: groups[index!])
                cell = groupCell
            case "organization":
                let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
                let organizations = clientData.getGroups(.Organisation)!
                let index = organizations.indexOf({ $0.id == contacts[indexPath.row]["id"] })
                organizationCell.setValues(organizations[index!], indexPath: indexPath)
                cell = organizationCell
            default: break
            }
        default: break
        }
        return cell
    }
    
    func cellForRowTableViewConnectionMyProfile(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        let rowTypes = getConnectionsMyProfileData()
        switch rowTypes[indexPath.row] {
        case .Individual:
            let individualCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Cell") as! IndividualCell
            individualCell.setValues(clientData.getMyConnection()![0], indexPath: NSIndexPath(forRow: 0, inSection: 0))
            individualCell.delegate = self
            if clientData.getMyConnection()![0].photo == nil{
                Engine.getPhotoOfConnection(NSIndexPath(forRow: 0, inSection: 0)){ success in
                    if success{
                        self.tableViewConnectionUpper.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
                    }
                }
            }
            cell = individualCell
        case .Organization:
            let organizationCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Organization") as! OrganizationCell
            let organizations = clientData.getGroups(.Organisation)!
            organizationCell.setValues(organizations[0], indexPath: NSIndexPath(forRow: 0, inSection: 0))
            cell = organizationCell
        case .InterestGroup:
            let groupCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Group") as! GroupCell
            groupCell.delegate = self
            groupCell.setValues(NSIndexPath(forRow: 0, inSection: 0), group: clientData.getFilteredGroup(.ByInterestGroup)[0], groupType: .InterestGroup)
            cell = groupCell
        case .Group:
            let groupCell = tableViewConnectionUpper.dequeueReusableCellWithIdentifier("Group") as! GroupCell
            groupCell.delegate = self
            groupCell.setValues(NSIndexPath(forRow: 0, inSection: 0), group: groups[0])
            cell = groupCell
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
            organizationCell.setValues(suggestOrganizations[indexPath.row], type: .NotMine)
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
            friendRequestCell.delegate = self
            switch indexPath.section {
            case 0:
                let friend = friendRequests[indexPath.row - 1]
                friendRequestCell.setValues(friend, indexPath: indexPath)
            case 1:
                let friendDict = suggestFriendConnections[indexPath.row - 1]
                friendRequestCell.setValues(friendDict, indexPath: indexPath)
            default: break
            }
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
            let cell = tableViewConnectionUpper.cellForRowAtIndexPath(indexPath) as! GroupCell
            self.performSegueWithIdentifier("GroupSegue", sender: cell)
        case 2:
            self.performSegueWithIdentifier("OrgSegue", sender: indexPath.row)
        case 3:
            var contacts = allContacts[allContactsSectionIndex[indexPath.section]]!
            switch contacts[indexPath.row]["type"]! {
            case "individual":
                break
            case "group":
                let cell = tableViewConnectionUpper.cellForRowAtIndexPath(indexPath) as! GroupCell
                self.performSegueWithIdentifier("GroupSegue", sender: cell)
            case "organization":
                let index = clientData.getGroups(.Organisation)!.indexOf({ $0.id == contacts[indexPath.row]["id"]! })
                self.performSegueWithIdentifier("OrgSegue", sender: index!)
            default: break
            }
        default:
            break
        }
    }
    
    func didSelectRowTableViewListInterests(indexPath: NSIndexPath){
        switch indexPath.section {
        case 0:
            if listInterestChecked == Set(interests){
                listInterestChecked = []
            }else{
                listInterestChecked = Set(interests)
            }
            tableViewListInterests.reloadData()
        case 1:
            tableViewListInterests.deselectRowAtIndexPath(indexPath, animated: false)
            if let index = listInterestChecked.indexOf({ $0.lowercaseString == interests[indexPath.row].lowercaseString }){
                listInterestChecked.removeAtIndex(index)
            }else{
                listInterestChecked.insert(interests[indexPath.row])
            }
            tableViewListInterests.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            tableViewListInterests.reloadDataSection(0, animate: false)
        default: break
        }
        
    }
    
    func didSelectRowTableViewConnectionLower(indexPath: NSIndexPath){
        
    }
    
    func didSelectRowTableViewConnectionMyProfile(tableView: UITableView, indexPath: NSIndexPath){
        switch getConnectionsMyProfileData()[indexPath.row] {
        case .Individual:
            break
        case .Organization:
            self.performSegueWithIdentifier("OrgSegue", sender: 0)
        case .Group, .InterestGroup:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! GroupCell
            self.performSegueWithIdentifier("GroupSegue", sender: cell)
        }
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
                    return count > 3 ? 3 : count
                }
            }
        case 2:
            return clientData.getMyChildrens().count > 3 ? 4 : clientData.getMyChildrens().count
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
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
            imageViewPhoto.image = clientData.getGroups(.Organisation)![indexPath.row].image ?? UIImage(named: "company1.png")
        case 2:
            if indexPath.row == 3{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddMore", forIndexPath: indexPath)
                let number = cell.viewWithTag(1) as! UILabel
                number.layer.cornerRadius = number.bounds.size.width / 2
            }else{
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
                let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
                imageViewPhoto.image = clientData.getMyChildrens()[indexPath.row].photo ?? UIImage(named: "photo-container.png")
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
            if indexPath.row != 3{
                if childLastTapped == indexPath.row{
                    viewChildrenProfileNotification.hidden = !viewChildrenProfileNotification.hidden
                }else{
                    let cell = collectionView.cellForItemAtIndexPath(indexPath)!
                    let positionCellToTableView = cell.convertRect(cell.bounds, toView: tableViewMyProfile)
                    viewChildrenProfileNotification.dinamicCustomInit(positionCellToTableView)
                    viewChildrenProfileNotification.hidden = false
                    childLastTapped = indexPath.row
                    tableViewChildrenDetail.reloadData()
                }
            }
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
        
        tableViewConnectionUpper.sectionIndexColor = LFColor.green
        viewSearch.alpha = 0
        
        tableViewMyProfile.addSubview(viewChildrenProfileNotification)
        viewChildrenProfileNotification.dinamicCustomInit()
        
        viewResultSearch.customInit(self, viewIndicator: viewSearch, type: .SearchHeader)
        
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
            viewFriendRequest.hidden = !viewFriendRequest.hidden
            viewNotification.hidden = true
            labelNotification.hidden = false
            tableViewFriendRequest.reloadData()
        case 2:
            labelNotification.hidden = !labelNotification.hidden
            viewNotification.hidden = !viewNotification.hidden
            viewFriendRequest.hidden = true
        default: break
        }
    }
    
    func hideNotificationViews(){
        viewFriendRequest.hidden = true
        viewNotification.hidden = true
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
            for each in interests{
                if clientData.cacheSelfInterests().contains({ $0.lowercaseString == each.lowercaseString }){
                    listInterestChecked.insert(each)
                }
            }
            tableViewListInterests.reloadData()
            viewEditInterest.customInit(self, viewIndicator: sender, type: .Row)
        case 2:
            viewEditAffiliatedOrganization.customInit(self, viewIndicator: sender, type: .Row)
        case 3:
            viewEditConnection.customInit(self, viewIndicator: sender, type: .Row)
            tableViewListConnection.reloadData()
        default: break
        }
        
    }
    
    func holdViewTapped(gesture: UITapGestureRecognizer){
        gesture.view?.removeFromSuperview()
        viewEditInterest.hidden = true
        viewEditAffiliatedOrganization.hidden = true
        viewEditConnection.hidden = true
        
        listInterestChecked = []
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
            let sender = sender! as! GroupCell
            if sender.groupType! == .InterestGroup{
                groupDetailController.initFromCall(clientData.getFilteredGroup(.ByInterestGroup)[sender.indexPath.row])
            }else if sender.groupType! == .Group{
                groupDetailController.initFromCall(groups[sender.indexPath.row])
            }
        }else if segue.identifier == "ChatSegue"{
            let chatController = segue.destinationViewController as! ChatFlow
            var indexThread = 0
            if let sender = sender as? GroupCell{
                let group = sender.groupType! == .InterestGroup ? clientData.getFilteredGroup(.ByInterestGroup).first! : groups[sender.indexPath.row]
                indexThread = clientData.getMyThreads()!.indexOf({ $0.id == group.threadId! })!
            }else if let sender = sender as? Thread{
                indexThread = clientData.getMyThreads()!.indexOf({ $0.id == sender.id })!
            }
            chatController.initChat(indexThread, idThread: clientData.getMyThreads()![indexThread].id, from: .OpenChat)
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
            switch cell.indexPath.section {
            case 0:
                let valuesCell = tableViewMyProfile.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: cell.indexPath.section)) as! RowEditProfileCell
                if valuesCell.shouldNewImage == true{
                    conditionPhotoEdited = true
                    Engine.editPhoto(photo: valuesCell.imageViewPhoto.image!){ status in
                        if status == .Success{
                            self.conditionPhotoEdited = false
                            self.tableViewMyProfile.reloadDataSection(0, animate: false)
                        }
                    }
                }
                Engine.editMe(name: valuesCell.textfieldName.text!, from: valuesCell.textfieldFrom.text!, work: valuesCell.textfieldWork.text!){status in
                    if status == .Success{
                        self.tableViewMyProfile.reloadDataSection(0, animate: false)
                    }
                }
            default: break
            }
            shouldEditMyProfile = false
        }
    }
}

// - MARK: GroupCell My Profile Delegate
extension Profile: GroupCellDelegate{
    func buttonActionTapped(cell: GroupCell) {
        if cell.indexPath != nil{
            performSegueWithIdentifier("ChatSegue", sender: cell)
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

// - MARK: FriendRequestCell My Profile Delegate
extension Profile: FriendRequestCellDelegate{
    func buttonAcceptTapped(cell: FriendRequestCell) {
        switch cell.indexPath.section {
        case 0:
            Engine.addFriend(user: friendRequests[cell.indexPath.row - 1]){ status in
                if status == .Success{
                    self.friendRequests.removeAtIndex(cell.indexPath.row - 1)
                    if self.indicatorAccConnection == 0{
                        self.tableViewConnectionUpper.reloadData()
                    }
                }
            }
        case 1:
            Engine.requestFriend(userId: suggestFriendConnections[cell.indexPath.row - 1]["id"] as! Int){status in
                if status == .Success{
                    self.suggestFriendConnections.removeAtIndex(cell.indexPath.row - 1)
                }
            }
            break
        default: break
        }
    }
}

// - MARK IndividualCell My Profile Delegate
extension Profile: IndividualCellDelegate{
    func buttonChatTapped(cell: IndividualCell) {
        let user = clientData.getMyConnection()![cell.indexPath.row]
        Engine.createPrivateThread(userId: [user.userId!]){ status, thread in
            if let thread = thread where status == .Success{
                self.performSegueWithIdentifier("ChatSegue", sender: thread)
            }
        }
    }
}

// - MARK OrganizationCell My Profile Delegate
extension Profile: OrganizationCellDelegate{
    func buttonAddTapped(cell: OrganizationCell) {
        if cell.forSearch!{
            let group = searchResult.groups[cell.indexPath.row - 1]
            
            print(group.name)
        }else{
            
        }
    }
}












