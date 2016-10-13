//
//  RowProfileCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class RowProfileCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRoles: UILabel!
    @IBOutlet weak var buttonOpenChat: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    func customInit(){
        containerView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        containerView.layer.borderWidth = 1.0
    }
    
    func setValues(values: Dictionary<String, AnyObject>){
        if let photo = values["photo"] { self.imageViewPhoto.image = photo as? UIImage }
        if let name = values["name"] { self.labelName.text = name as? String }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
