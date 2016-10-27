//
//  RowEditProfileCell.swift
//  LearnFlux
//
//  Created by ISA on 10/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

struct DEFAULT_EDIT_PROFILE_TEXT{
    static let FROM = "From (example: United Kingdom)"
    static let WORK = "Work"
}

class RowEditProfileCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textviewRoles: UITextView!
    @IBOutlet weak var textfieldFrom: UITextField!
    @IBOutlet weak var textfieldWork: UITextField!
    weak var viewController : UIViewController?
    var shouldNewImage : Bool!
    
    
    @IBAction func textfieldFromBeginEdited(sender: UITextField) {
        if sender.text! == DEFAULT_EDIT_PROFILE_TEXT.FROM{
            sender.text = ""
        }
    }
    
    @IBAction func textfieldFromEndEdited(sender: UITextField) {
        if sender.text!.isEmpty{
            sender.text = DEFAULT_EDIT_PROFILE_TEXT.FROM
        }
    }
    
    @IBAction func textfieldWorkBeginEdited(sender: UITextField) {
        if sender.text! == DEFAULT_EDIT_PROFILE_TEXT.WORK{
            sender.text = ""
        }
    }
    
    @IBAction func textfieldWorkEndEdited(sender: UITextField) {
        if sender.text!.isEmpty{
            sender.text = DEFAULT_EDIT_PROFILE_TEXT.WORK
        }
    }
    
    @IBAction func imageViewPhotoTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
            viewController?.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    func customInit(){
        containerView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        containerView.layer.borderWidth = 1.0
        shouldNewImage = false
    }
    
    func setValues(viewController: UIViewController, values: Dictionary<String, AnyObject>, scale: CGFloat = 1.0, stateMore: Bool = false){
        self.viewController = viewController
        if let photo = values["photo"] { self.imageViewPhoto.image = photo as? UIImage }
        if let name = values["name"] { self.textfieldName.text = (name as? String)?.capitalizedString }
        if let roles = values["roles"] { self.textviewRoles.text = roles as? String }
        if let from = values["from"] { self.textfieldFrom.text = from as? String }
        if let work = values["work"] { self.textfieldWork.text = work as? String }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RowEditProfileCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageViewPhoto.image = pickedImage.size.width > 800 ? Util.resizeImage(pickedImage, newWidth: 800) : pickedImage
            shouldNewImage = true
        }
        viewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}