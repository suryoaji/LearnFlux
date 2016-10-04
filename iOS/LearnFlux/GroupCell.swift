//
//  GroupCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var containerPhoto: UIView!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSide: UILabel!
    
    var photos = ["male01.png", "male02.png", "male03.png", "male04.png", "male05.png", "male06.png", "male07.png", "female01.png", "female02.png", "female03.png", "female04.png"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
        // Initialization code
    }
    
    func customInit(){
        self.contentView.layer.borderWidth = 0.6
        self.contentView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        containerPhoto.layer.cornerRadius = self.frame.height == 44 ? (UIScreen.mainScreen().applicationFrame.height / 568 * containerPhoto.frame.width) / 2 : containerPhoto.frame.width / 2
        randomPhotos()
    }
    
    func randomPhotos(){
        for view in self.containerPhoto.subviews{
            let imageView = view as! UIImageView
            imageView.image = UIImage(named: photos[Int(arc4random_uniform(UInt32(photos.count - 1)))])
        }
    }
    
    func setValues(group: Dictionary<String, String>, type: Int = 0){
        labelName.text = group["name"]
        labelSide.text = group["side"]
        if type == 1 { buttonAction.setImage(UIImage(named: "add-group"), forState: .Normal) }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
