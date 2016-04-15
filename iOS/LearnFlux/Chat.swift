//
//  Chat.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Chat : UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tfChat: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnImportant: UIButton!
    var isImportant: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tfChat.text = "";
        tfChat.layer.borderWidth = 1;
        tfChat.layer.borderColor = UIColor.grayColor().CGColor;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 2;
        case 2: return 3;
        case 3: return 2;
        case 4: return 1;
        case 5: return 2;
        case 6: return 1;
        default: return 0;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let code = indexPath.code;
        NSLog(code);
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        cell.setSeparatorType(CellSeparatorNone);
        if let img = cell.viewWithTag(10) as! UIImageView? {
            img.makeViewRoundedRectWithCornerRadius(5);
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier(indexPath.code)!.height;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 1: return "Yesterday";
        case 5: return "Today";
        default: return "";
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
    
    @IBAction func changeImportant (sender: AnyObject) {
        if (!isImportant) {
            btnImportant.imageView!.image = UIImage(named: "important_red-18.png");
            isImportant = true;
        }
        else {
            btnImportant.imageView!.image = UIImage(named: "important-18.png");
            isImportant = false;
        }
    }
    
    @IBAction func showAttachment (sender: AnyObject) {
        
    }
}