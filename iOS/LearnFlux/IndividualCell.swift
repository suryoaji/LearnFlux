//
//  IndividualCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class IndividualCell: UITableViewCell {

    var dummySides = ["Arts and Craft Teacher", "Associate Engineer", "Physician"]
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSide: UILabel!
    
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
    
    func setValues(contact: User){
        labelName.text = contact.firstName
        labelSide.text = dummySides[Int(arc4random_uniform(2))]
        imageViewPhoto.image = contact.photo ?? UIImage(named: "photo-container.png")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
