//
//  IndividualCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

protocol IndividualCellDelegate: class {
    func buttonChatTapped(cell: IndividualCell)
}

class IndividualCell: UITableViewCell {
    weak var delegate : IndividualCellDelegate?
    var indexPath: NSIndexPath!
    var dummySides = ["Arts and Craft Teacher", "Associate Engineer", "Physician"]
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSide: UILabel!
    @IBOutlet weak var buttonChat: UIButton!
    
    @IBAction func buttonChatTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonChatTapped(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
        // Initialization code
    }
    
    func customInit(){
        self.contentView.layer.borderWidth = 0.6
        self.contentView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        imageViewPhoto.layer.cornerRadius = self.frame.height == 44 ? (UIScreen.mainScreen().bounds.height / 568.0 * imageViewPhoto.frame.width) / 2 : imageViewPhoto.frame.width / 2
    }
    
    func setValues(contact: Dictionary<String, String>){
        labelName.text = contact["name"]
        labelSide.text = contact["side"]
        imageViewPhoto.image = UIImage(named: contact["photo"]!)
    }
    
    func setValues(contact: User, indexPath: NSIndexPath){
        self.indexPath = indexPath
        if let lastname = contact.lastName{
            labelName.text = "\(contact.firstName!) \(lastname)".capitalizedString
        }else{
            labelName.text = contact.firstName?.capitalizedString
        }
        labelSide.text = dummySides[Int(arc4random_uniform(2))]
        imageViewPhoto.image = contact.photo ?? UIImage(named: "photo-container.png")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
