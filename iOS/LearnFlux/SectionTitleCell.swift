//
//  SectionTitleCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class SectionTitleCell: UITableViewCell {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customInit(title: String, indexPath: NSIndexPath){
        self.contentView.backgroundColor = indexPath.section == 0 ? UIColor.whiteColor() : UIColor(white: 245/255.0, alpha: 1.0)
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        titleButton.setTitle(title, forState: .Normal)
        if indexPath.section != 0 { editButton.removeFromSuperview() }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
