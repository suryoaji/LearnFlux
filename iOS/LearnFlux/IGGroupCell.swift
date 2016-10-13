//
//  IGGroupCell.swift
//  LearnFlux
//
//  Created by ISA on 10/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

@objc protocol IGGroupCellDelegate{
    func buttonMessageTapped(cell: IGGroupCell)
    func buttonEventsTapped(cell: IGGroupCell)
    func buttonActivitiesTapped(cell: IGGroupCell)
}

class IGGroupCell: UICollectionViewCell {
    weak var delegate : IGGroupCellDelegate?
    var indexPath: NSIndexPath!
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonStar: UIButton!
    
    @IBAction func buttonMessageTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonMessageTapped(self)
        }
    }
    
    @IBAction func buttonEventsTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonEventsTapped(self)
        }
    }
    
    @IBAction func buttonActivitiesTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonActivitiesTapped(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    private func customInit(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 220/255.0, alpha: 1.0).CGColor
    }
    
    func setValues(indexPath: NSIndexPath, group: Dictionary<String, String>){
        imageViewLogo.image = UIImage(named: group["logo"]!)
        labelName.text = group["name"]
        buttonStar.tintColor = group["thumb"] == "0" ? UIColor(white: 220/255.0, alpha: 1.0) : LFColor.green
        self.indexPath = indexPath
    }
    
    func setValues(indexPath: NSIndexPath, group: Group){
        imageViewLogo.image = group.image ?? UIImage(named: "company1.png")
        labelName.text = group.name
        buttonStar.tintColor = UIColor(white: 220/255.0, alpha: 1.0)
        self.indexPath = indexPath
    }
}
