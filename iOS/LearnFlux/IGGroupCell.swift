//
//  IGGroupCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class IGGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonStar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    private func customInit(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 220/255.0, alpha: 1.0).CGColor
    }
    
    func setValues(group: Dictionary<String, String>){
        imageViewLogo.image = UIImage(named: group["logo"]!)
        labelName.text = group["name"]
        buttonStar.tintColor = group["thumb"] == "0" ? UIColor(white: 220/255.0, alpha: 1.0) : LFColor.green
    }
}
