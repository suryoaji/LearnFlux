//
//  OrganizationCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum OrganizationCellType{
    case Mine
    case NotMine
}

protocol OrganizationCellDelegate: class {
    func buttonAddTapped(cell: OrganizationCell)
}

class OrganizationCell: UITableViewCell {
    @IBOutlet weak var imageViewOrganization: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSide: UILabel!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var viewContainerLabels: UIView!
    weak var delegate : OrganizationCellDelegate?
    var indexPath : NSIndexPath!
    var type: OrganizationCellType!
    var forSearch: Bool!
    
    @IBAction func buttonActionTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonAddTapped(self)
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
    }
    
    func setValues(organization: Group, indexPath: NSIndexPath, type: OrganizationCellType = .Mine, forSearch: Bool = false){
        self.forSearch = forSearch
        self.type = type
        self.indexPath = indexPath
        labelName.text = organization.name
        imageViewOrganization.image = organization.image != nil ? organization.image! : UIImage(named: "company1.png")
        if type == .Mine {
            labelSide.text = Engine.getRoleOfGroup(organization)?.name.lowercaseString ?? "member"
            if buttonAction.hidden == false{
                viewContainerLabels.frame.size.width = self.frame.width - viewContainerLabels.frame.origin.x - 13
            }
            buttonAction.hidden = true
        }else{
            buttonAction.hidden = false
        }
        
    }
    
    func setValues(organization: Dictionary<String, String>, type: OrganizationCellType = .Mine){
        labelName.text = organization["name"]
        labelSide.text = organization["side"]
        imageViewOrganization.image = UIImage(named: organization["photo"]!)
        if type == .Mine { buttonAction.hidden = true } else{ buttonAction.hidden = false }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
