//
//  OrganizationCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class OrganizationCell: UITableViewCell {

    @IBOutlet weak var imageViewOrganization: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSide: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var viewContainerLabels: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
        // Initialization code
    }

    func customInit(){
        self.contentView.layer.borderWidth = 0.6
        self.contentView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
    }
    
    func setValues(organization: Group, type: Int = 0){
        labelName.text = organization.name
        labelSide.text = Engine.getRoleOfGroup(organization)?.name.lowercaseString ?? "member"
        imageViewOrganization.image = organization.image != nil ? organization.image! : UIImage(named: "company1.png")
        if type == 0 {
            if buttonAction.hidden == false{
                viewContainerLabels.frame.size.width = self.frame.width - viewContainerLabels.frame.origin.x - 13
            }
            buttonAction.hidden = true
        }else{
            buttonAction.hidden = false
        }
        
    }
    
    func setValues(organization: Dictionary<String, String>, type: Int = 0){
        labelName.text = organization["name"]
        labelSide.text = organization["side"]
        imageViewOrganization.image = UIImage(named: organization["photo"]!)
        if type == 0 { buttonAction.hidden = true } else{ buttonAction.hidden = false }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
