//
//  PublicProfile.swift
//  LearnFlux
//
//  Created by ISA on 12/9/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class PublicProfile: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let clientData = Engine.clientData
    var user: User?
    
    func initViewController(user: User){
        self.user = user
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mockUpDidLoad()
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mockUpWillAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonActionTapped(sender: UIButton) {
        Engine.requestFriend(user: user!){[unowned self]status in
            if status == .Success{
                self.buttonAccept.enabled = false
                self.buttonAccept.backgroundColor = UIColor(white: 220.0/255, alpha: 1.0)
            }
        }
    }
    
    var sectionTitles = ["", "My Children", "Affilated Organizations", "Interests"]
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var indicatorHeader: UIView!
    @IBOutlet weak var buttonHeaderMyProfile: UIButton!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
}

// - MARK: Table View
extension PublicProfile: UITableViewDataSource, UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if user != nil{
            return sectionTitles.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
        case 3:
            if let interests = user!.interests{
                return interests.count + 3
            }else{
                return 1
            }
        default:
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cell = UITableViewCell(frame: CGRectZero)
        cell.height = 0
        if indexPath.row == 0{
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("headerSection")!
            case 1:
                if let childrens = user!.childrens where !childrens.isEmpty{
                    cell = tableView.dequeueReusableCellWithIdentifier("headerSection")!
                }
                break
            case 2:
                if !user!.getOrganizations().isEmpty{
                    cell = tableView.dequeueReusableCellWithIdentifier("headerSection")!
                }
                break
            case 3:
                if let interests = user!.interests where !interests.isEmpty{
                    cell = tableView.dequeueReusableCellWithIdentifier("headerSection")!
                }
            default: break
            }
        }else{
            switch indexPath.section{
            case 0:
                let headerCell = tableView.dequeueReusableCellWithIdentifier("1") as! RowProfileCell
                cell = headerCell
            case 1:
                if let childrens = user!.childrens where !childrens.isEmpty{
                    let childrenCell = tableView.dequeueReusableCellWithIdentifier("4")!
                    cell = childrenCell
                }
            case 2:
                if !user!.getOrganizations().isEmpty{
                    let organizationCell = tableView.dequeueReusableCellWithIdentifier("2")!
                    cell = organizationCell
                }
            case 3:
                if let interests = user!.interests where !interests.isEmpty{
                    let interestCell = tableView.dequeueReusableCellWithIdentifier("3") as! RowInterestsCell
                    cell = interestCell
                }
            default: break
            }
        }
        return cell.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        if indexPath.row == 0{
            let titleCell = tableView.dequeueReusableCellWithIdentifier("headerSection") as! SectionTitleCell
            titleCell.customInit(sectionTitles[indexPath.section], indexPath: indexPath, titleEdit: "")
            cell = titleCell
        }else{
            switch indexPath.section {
            case 0:
                let headerCell = tableView.dequeueReusableCellWithIdentifier("1") as! RowProfileCell
                let values : Dictionary<String, AnyObject> = ["photo"  : user!.photo ?? UIImage(named: "photo-container.png")!,
                              "id"     : user!.userId!,
                              "name"   : "\(user!.firstName!) \(user!.lastName ?? "")",
                              "roles"  : "",
                              "from"   : user!.location ?? "",
                              "work"   : user!.work ?? "",
                              "mutual" : user!.mutualFriend ?? []]
                headerCell.setValues(values, scale: view.width / headerCell.width, stateMore: false)
                cell = headerCell
            case 1:
                if let childrens = user!.childrens where !childrens.isEmpty{
                    let childrenCell = tableView.dequeueReusableCellWithIdentifier("4")!
                    let collectionView = childrenCell.viewWithTag(2) as! UICollectionView
                    collectionView.reloadData()
                    cell = childrenCell
                }
            case 2:
                if !user!.getOrganizations().isEmpty{
                    let organizationCell = tableView.dequeueReusableCellWithIdentifier("2")!
                    let collectionView = organizationCell.viewWithTag(1) as! UICollectionView
                    let containerButtonNumber = organizationCell.viewWithTag(4)!
                    containerButtonNumber.hidden = true
                    collectionView.width = organizationCell.width
                    collectionView.reloadData()
                    return organizationCell
                }
            case 3:
                if let interests = user!.interests where !interests.isEmpty{
                    let interestCell = tableView.dequeueReusableCellWithIdentifier("3") as! RowInterestsCell
                    interestCell.customInit(interests, indexPath: indexPath)
                    cell = interestCell
                    
                }
            default: break
            }
        }
        return cell
    }
    
}

// - MARK: Collection View
extension PublicProfile: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        switch collectionView.tag {
        case 1:
            return user!.getOrganizations().count
        case 2:
            return user!.childrens!.count
        default: return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = UICollectionViewCell()
        switch collectionView.tag {
        case 1:
            let organizations = user!.getOrganizations()
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
            imageViewPhoto.image = organizations[indexPath.row].image ?? UIImage(named: "company1.png")
        case 2:
            let childrens = user!.childrens!
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            let imageViewPhoto = cell.viewWithTag(1) as! UIImageView
            imageViewPhoto.image = childrens[indexPath.row].photo ?? UIImage(named: "photo-container.png")
        default: break
        }
        return cell
    }
}

// - MARK: Mock Up
extension PublicProfile{
    func mockUpWillAppear(){
        
    }
    
    func mockUpDidLoad(){
        setHeaderView()
        setTableView()
        
        if let user = user{
            if clientData.getMyConnection().pending.contains({ $0.userId == user.userId! }){
                buttonAccept.enabled = true
                buttonAccept.setTitle("Accept", forState: .Normal)
            }else if clientData.getMyConnection().requested.contains({ $0.userId == user.userId! }){
                buttonAccept.enabled = false
                buttonAccept.backgroundColor = UIColor(white: 220.0/255, alpha: 1.0)
            }
        }
    }
    
    func setHeaderView(){
        if let navCon = navigationController{
            headerView.frame.origin.y = navCon.navigationBar.height + UIApplication.sharedApplication().statusBarFrame.height
        }
        indicatorHeader.frame.origin.x = buttonHeaderMyProfile.x
        indicatorHeader.width = buttonHeaderMyProfile.width
    }
    
    func setTableView(){
        tableView.y = headerView.y + headerView.height
        tableView.height = UIScreen.mainScreen().bounds.height - tableView.y - buttonAccept.height
    }
}

// - MARK: Helper
extension PublicProfile{
    func loadData(){
        if let user = user{
            Engine.requestUserDetail(self, idUser: user.userId!){status, JSON in
                guard let dataUser = JSON as? Dictionary<String, AnyObject> where status == .Success else{
                    self.popBackFromNavigationController()
                    return
                }
                self.user!.update(dataUser){ type, id, status in
                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
            }
        }else{
            popBackFromNavigationController()
        }
    }
    
    func popBackFromNavigationController(){
        Util.showMessageInViewController(self, title: "", message: "Something's Error", buttonOKTitle: "OK", callback: {
            if let navCon = self.navigationController{
                navCon.popViewControllerAnimated(true)
            }
        })
    }
}













