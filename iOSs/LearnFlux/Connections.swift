//
//  Connections.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Connections : UITableViewController {
    
    var buttonDone : UIBarButtonItem!
//    var actualConnect = Array<User>()
    var selectedConnect : Array<Bool> = [];
    let flow = Flow.sharedInstance
    let clientData = Engine.clientData
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let item = UIBarButtonItem();
        item.image = UIImage(named: "menu-1.png");
        self.navigationItem.leftBarButtonItem = item;
        item.action = #selector(self.revealMenu);
        item.target = self;
        
        if let connection = clientData.getMyConnection(){
            selectedConnect = Array(count: connection.count, repeatedValue: false)
        }
        
        self.tabBarController?.title = "Connections";
        let flow = Flow.sharedInstance;
        
        if let activeFlow = flow.activeFlow() {
            if activeFlow == .NewGroup || activeFlow == .NewOrganization{
                self.title = "Invite Participants"
                setupDoneButton();
            }
            else if flow.activeFlow() == .NewThread || flow.activeFlow() == .NewInterestGroup{
                self.title = "Select Participants";
                setupDoneButton()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.updateConnection()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateConnection), name: "ConnectionsUpdateNotification", object: self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func updateConnection(){
        if let connection = clientData.getMyConnection(){
            self.selectedConnect = Array(count: connection.count, repeatedValue: false)
            self.tableView.reloadData()
        }
    }
    
    lazy var flowDirection : String! = "";
    lazy var flowData : NSMutableDictionary! = [:];
    
    func setupDoneButton () {
        buttonDone = UIBarButtonItem()
        buttonDone.title = "Done"
        buttonDone.action = #selector(self.buttonDoneTapped)
        buttonDone.target = self
        buttonDone.enabled = false
        self.navigationItem.rightBarButtonItem = buttonDone
    }
    
    func buttonDoneTapped(sender: UIBarButtonItem) {
        var userId : Array<Int> = [];
        for i in 0..<selectedConnect.count {
            if selectedConnect[i] && clientData.getMyConnection() != nil {
                let el = clientData.getMyConnection()![i]
                userId.append(el.userId!)
            }
        }
        flow.add(dict: ["userIds":userId]);
        if let activeFlow = flow.activeFlow() where activeFlow == .NewGroup ||
                                                    activeFlow == .NewThread ||
                                                    activeFlow == .NewOrganization{
            flow.end(self, andClear: true)
        }else if let activeFlow = flow.activeFlow() where activeFlow == .NewInterestGroup{
            flow.end()
        }
    }
    
    @IBAction func revealMenu (sender: AnyObject) {
        self.revealController.showViewController(self.revealController.leftViewController);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1:
            if let count = clientData.getMyConnection()?.count{
                return count
            }
            return 0
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier("1-0")!.height;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("1-0")!;
        cell.setSeparatorType(CellSeparatorFull);
        let lbl = cell.viewWithTag(1) as! UILabel;
        let user = clientData.getMyConnection()![indexPath.row]
        var name = "\(user.userId!)"
        name += user.lastName != nil ? " \(user.firstName!) \(user.lastName!)".capitalizedString : " \(user.firstName)"
        lbl.text = name
        let img = cell.viewWithTag(10) as! UIImageView;
        if let photo = user.photo{ img.image = photo }
        img.layer.cornerRadius = img.frame.width / 2
        if (selectedConnect[indexPath.row]) {
            cell.accessoryType = .Checkmark;
        }
        else {
            cell.accessoryType = .None;
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        let flow = Flow.sharedInstance;
        
        if (flow.activeFlow() != nil) {
            selectedConnect[indexPath.row] = !selectedConnect[indexPath.row];
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None);
            buttonDoneShouldEnable()
        }else{
            let user = clientData.getMyConnection()![indexPath.row]
            var arrUserId = Array<Int>();
            arrUserId.append(user.userId!)
            Engine.createPrivateThread(userId: arrUserId){ status, thread in
                if let thread = thread where status == .Success{
                    self.performSegueWithIdentifier("InitiateChat", sender: thread)
                }
            }
        }
    }
    
    func buttonDoneShouldEnable(){
        buttonDone.enabled = !selectedConnect.isEmpty ? !selectedConnect.filter({ $0==true }).isEmpty ? true : false : false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "InitiateChat") {
            let chatVC = segue.destinationViewController as! ChatFlow;
            let thread = sender as! Thread
            
            chatVC.initChat(clientData.getMyThreads()!.indexOf({ $0.id == thread.id })!, idThread: thread.id, from: .OpenChat)
        }
    }
}