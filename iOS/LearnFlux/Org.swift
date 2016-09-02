//
//  Org.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/15/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Org : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var cv : UICollectionView!;
    
    var groups : [Group]?
    let clientData = Engine.clientData
    let flow = Flow.sharedInstance
    
    func getOrganization(){
        self.groups = clientData.getGroups(.Organisation)
        cv.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getOrganization()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(getOrganization), name: "GroupsUpdateNotification", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func rightNavigationBarButtonTapped(sender: UIBarButtonItem){
        flow.begin(.NewOrganization)
        flow.setCallback { result in
            guard let title = result!["title"] as? String else { print ("FLOW: title not found"); return; }
            guard let desc = result!["desc"] as? String else { print ("FLOW: desc not found"); return; }
            guard let userIds = result!["userIds"] as? [Int] else { print ("FLOW: userIds not found"); return; }
            Engine.createOrganization(self, name: title, description: desc, userId: userIds)
        }
        self.performSegueWithIdentifier("NewOrganization", sender: sender)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (groups !=  nil) {
            return groups!.count
        }else {
            return 0;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath);
        
        let lblName = cell.viewWithTag(1) as! UILabel;
        let lblDesc = cell.viewWithTag(2) as! UILabel;
        let lblMessage = cell.viewWithTag(3) as! UILabel;
        let lblEvent = cell.viewWithTag(4) as! UILabel;
        let lblActivities = cell.viewWithTag(5) as! UILabel;
        let btnMessage = cell.viewWithTag(20) as! UIButton
        let btnEvents = cell.viewWithTag(21) as! UIButton
        let btnActivities = cell.viewWithTag(22) as! UIButton
        btnEvents.layer.name = "\(indexPath.row)"
        btnActivities.layer.name = "\(indexPath.row)"
        btnMessage.layer.name = "\(indexPath.row)"
        btnActivities.addTarget(self, action: #selector(self.btnAccOrgTapped), forControlEvents: .TouchUpInside)
        btnMessage.addTarget(self, action: #selector(self.btnAccOrgTapped), forControlEvents: .TouchUpInside)
        btnEvents.addTarget(self, action: #selector(self.btnAccOrgTapped), forControlEvents: .TouchUpInside)
        lblName.text = groups![indexPath.row].name;
        lblDesc.text = "";
        lblMessage.makeViewRounded();
        lblEvent.makeViewRounded();
        lblActivities.makeViewRounded();
        
        cell.makeViewRoundedRectWithCornerRadius(5);
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = UIColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor
        
        return cell;
    }
    
    func btnAccOrgTapped(sender: UIButton){
        if sender.tag == 21 || sender.tag == 22{
            self.performSegueWithIdentifier("OrganisationDetails", sender: sender)
        }else if sender.tag == 20{
            self.performSegueWithIdentifier("ChatFlow", sender: sender)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(148, 278);
        let screenSize = UIScreen.mainScreen().bounds.width;
        size.width = (screenSize / 2) - 15;
        return size;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OrganisationDetails") {
            let vc = segue.destinationViewController as! OrgDetails
            var group = groups![0]
            var indexTab = 0
            if let cell = sender as? UICollectionViewCell{
                let indexPath = cv.indexPathForCell(cell)!;
                group = groups![indexPath.row];
            }else if let btn = sender as? UIButton{
                let value = Int(btn.layer.name!)!
                group = groups![value]
                if btn.tag == 21{ indexTab = 1 }
                else if btn.tag == 22{ indexTab = 2 }
            }
            vc.initView(group.id, orgTitle: group.name, indexTab: indexTab)
        }else if segue.identifier == "ChatFlow"{
            if let btn = sender as? UIButton{
                let vc = segue.destinationViewController as! ChatFlow
                let value = Int(btn.layer.name!)!
                let index = Engine.clientData.getMyThreads()!.indexOf({ $0.id == groups![value].thread!.id })
                vc.initChat(index!, idThread: groups![value].thread!.id, from: .OpenChat)
            }
        }
    }

}