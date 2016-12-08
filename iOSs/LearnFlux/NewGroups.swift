//
//  NewGroups.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 6/28/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AMPopTip

class NewGroups : UIViewController {
    
    @IBOutlet var imgGroup : UIImageView!;
    @IBOutlet var viewImage : UIView!;
    @IBOutlet var viewTitle : UIView!;
    @IBOutlet var tfTitle : UITextField!;
    @IBOutlet var lblCount : UILabel!;
    @IBOutlet weak var lblImgGroup: UILabel!
    @IBOutlet var viewDesc : UIView!;
    @IBOutlet var tvDesc : UITextView!;
    var popTip = AMPopTip();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        mockUpDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mockUpWillAppear()
    }
    
    @IBAction func imageViewGroupTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func titleChanged (sender: AnyObject) {
        let maxChar = 40
        let remaining = maxChar - tfTitle.text!.characters.count
        lblCount.text = "\(remaining)"
        lblCount.textColor = remaining < 0 ? UIColor(red: 1, green: 136.0/255, blue: 81.0/255, alpha: 1) : UIColor.lightGrayColor()
        
        if let rightBarButton = navigationItem.rightBarButtonItem{
            rightBarButton.enabled = remaining == maxChar ? false : true
        }
    }
}

// - MARK: Picker Controller Delegate
extension NewGroups: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgGroup.image = pickedImage.size.width > 350 ? Util.resizeImage(pickedImage, newWidth: 350) : pickedImage
            lblImgGroup.hidden = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// - MARK: Mock Up
extension NewGroups{
    func mockUpDidLoad(){
        setRightNavBarButtonNext()
        viewImage.makeViewRounded();
        
        tvDesc.text = "";
        viewDesc.layer.borderWidth = 1;
        viewDesc.layer.borderColor = UIColor.lightGrayColor().CGColor;
        viewDesc.makeViewRoundedRectWithCornerRadius(5);
        viewDesc.backgroundColor = UIColor.clearColor();
        viewTitle.layer.borderWidth = 1;
        viewTitle.layer.borderColor = UIColor.lightGrayColor().CGColor;
        viewTitle.makeViewRoundedRectWithCornerRadius(5);
        viewTitle.backgroundColor = UIColor.clearColor();
    }
    
    func mockUpWillAppear(){
        if let rightBarButton = navigationItem.rightBarButtonItem{
            rightBarButton.enabled = tfTitle.text!.isEmpty ? false : true
        }
    }
    
    func setRightNavBarButtonNext(){
        let rightBarButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(rightNavBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func rightNavBarButtonTapped(sender: AnyObject) {
        let remaining = 40 - tfTitle.text!.characters.count;
        if (remaining < 0) {
            self.popTip.showText("The Group's subject is too long.", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfTitle.frame);
        }
        else {
            let flow = Flow.sharedInstance;
            if flow.activeFlow() != nil{
                flow.add(dict: ["title":tfTitle.text!, "desc":tvDesc.text, "img":imgGroup.image ?? UIImage(named: "company1.png")!]);
                let connections = Util.getViewControllerID("Connections") as! Connections;
                self.navigationController?.pushViewController(connections, animated: true);
            }
        }
    }
}



















