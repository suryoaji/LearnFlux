//
//  IGSuggestCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class IGSuggestCell: UITableViewCell {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelMember: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
        // Initialization code
    }
    
    private func customInit(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 220/255.0, alpha: 1.0).CGColor
    }

    func setValues(group: Dictionary<String, String>){
        imageViewLogo.image = UIImage(named: group["logo"]!)
        labelName.text = group["name"]
        labelDetails.text = group["details"]
        labelMember.text = group["members"]! + " members"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
