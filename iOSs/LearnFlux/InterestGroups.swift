//
//  InterestGroups.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class InterestGroups: UIViewController {
    
    let MAX_INTEREST_GROUP_SHOWN = 2
    
    let flow = Flow.sharedInstance
    let clientData = Engine.clientData
    @IBOutlet weak var collectionViewGroups: UICollectionView!
    @IBOutlet weak var tableViewSuggestGroups: UITableView!
    @IBOutlet weak var imageViewNoGroup: UIImageView!
    @IBOutlet weak var buttonSeeAllInterestGroup: UIButton!
    var suggestGroups = [["name" : "Early Childhood Education",
                          "details" : "The National Association for the Education of Young Children",
                          "members" : "370",
                          "logo" : "company3.png"],
                         ["name" : "Early Childhood Education",
                          "details" : "The National Association for the Education of Young Children",
                          "members" : "280",
                          "logo" : "company2.png"]]
    
    @IBAction func buttonAddNewInterestGroupTapped(sender: UIButton) {
        performSegueWithIdentifier("NewGroups", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mockUp()
    }
    
    func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        Util.showAlertMenu(self, title: "Menu", choices: ["Create New Interest Group..."], styles: [.Default], addCancel: true){ selected in
            switch selected{
            case 0:
                self.performSegueWithIdentifier("NewGroups", sender: nil)
                break
            default:
                break
            }
        }
    }
    
    func createNewInterestGroup(){
        flow.begin(.NewInterestGroup)
        flow.setCallback { result in
            guard let title = result!["title"] as? String else { print ("FLOW: title not found"); return; }
            guard let desc = result!["desc"] as? String else { print ("FLOW: desc not found"); return; }
            guard let userIds = result!["userIds"] as? [Int] else { print ("FLOW: userIds not found"); return; }
            Engine.createGroupChat(self, name: title, description: desc, userId: userIds) { status, JSON in
                if status == .Success && JSON != nil{
                    let dataJSON = JSON!["data"] as! Dictionary<String, AnyObject>
                    let vc = Util.getViewControllerID("GroupDetails") as! GroupDetails;
                    let group = Group(dict: dataJSON);
                    group.description = self.flow.get(key: "desc")! as? String;
                    group.color = Util.randomizePastelColor();
                    vc.isAdmin = true
                    vc.initFromCall(group);
                    self.navigationController?.pushViewController(vc, animated: true);
                    
                    if result!["img"] != nil{
                        let dataJSON = Engine.getDictData(JSON!)!
                        Engine.editGroupPhoto(idGroup: dataJSON["id"]! as! String, photo: result!["img"]! as! UIImage){status in
                            if status == .Success{
                                let indexGroup = self.clientData.getGroups().indexOf({ $0.id == dataJSON["id"]! as! String })!
                                self.clientData.getGroups()[indexGroup].image = result!["img"] as? UIImage
                                self.collectionViewGroups.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
        return clientData.getGroups(.InterestGroup).count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! IGGroupCell
        cell.delegate = self
        cell.setValues(indexPath, group: clientData.getGroups(.InterestGroup)[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(collectionView.frame.width / 2 - 2, collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("GroupSegue", sender: dictSenderForGroupSegue(indexPath, indexTab: 0))
    }
}

// - MARK Mock Up
extension InterestGroups{
    func mockUp(){
        setAccNavBar()
        
        if clientData.getGroups(.InterestGroup).isEmpty{
            imageViewNoGroup.hidden = false
        }else{
            imageViewNoGroup.hidden = true
            if clientData.getGroups(.InterestGroup).count > MAX_INTEREST_GROUP_SHOWN{
                buttonSeeAllInterestGroup.backgroundColor = LFColor.green
                buttonSeeAllInterestGroup.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                buttonSeeAllInterestGroup.enabled = true
            }else{
                buttonSeeAllInterestGroup.backgroundColor = UIColor(white: 245.0/255, alpha: 1.0)
                buttonSeeAllInterestGroup.setTitleColor(UIColor.grayColor(), forState: .Normal)
                buttonSeeAllInterestGroup.enabled = false
            }
            collectionViewGroups.reloadData()
        }
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

// - MARK CollectionView IGGroupCell Delegate
extension InterestGroups: IGGroupCellDelegate{
    func buttonMessageTapped(cell: IGGroupCell){
        performSegueWithIdentifier("ChatSegue", sender: cell.indexPath.row)
    }
    
    func buttonEventsTapped(cell: IGGroupCell){
        performSegueWithIdentifier("GroupSegue", sender: dictSenderForGroupSegue(cell.indexPath, indexTab: 1))
    }
    
    func buttonActivitiesTapped(cell: IGGroupCell){
        performSegueWithIdentifier("GroupSegue", sender: dictSenderForGroupSegue(cell.indexPath, indexTab: 2))
    }
}

// - MARK PrepareForSegue
extension InterestGroups{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChatSegue"{
            let chatController = segue.destinationViewController as! ChatFlow
            let indexThread = clientData.getMyThreads()!.indexOf({ $0.id == clientData.getGroups(.InterestGroup)[sender as! Int].thread!.id })!
            chatController.initChat(indexThread, idThread: clientData.getMyThreads()![indexThread].id, from: .OpenChat)
        }else if segue.identifier == "GroupSegue"{
            let groupController = segue.destinationViewController as! GroupDetails
            let sender = tupleSenderForGroupSegue(sender!)
            groupController.initFromCall(clientData.getGroups(.InterestGroup)[sender.0.row], indexTab: sender.1)
        }else if segue.identifier == "NewGroups"{
            createNewInterestGroup()
        }
    }
    
    func tupleSenderForGroupSegue(dict: AnyObject) -> (NSIndexPath, Int){
        return (dict["indexPath"] as! NSIndexPath, dict["indexTab"] as! Int)
    }
    
    func dictSenderForGroupSegue(indexPath: NSIndexPath, indexTab: Int) -> Dictionary<String, AnyObject>{
        return ["indexPath" : indexPath, "indexTab" : indexTab]
    }
}














