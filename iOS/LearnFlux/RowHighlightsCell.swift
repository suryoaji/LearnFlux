
//
//  RowHighlightsCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class RowHighlightsCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        customInit()
        // Initialization code
    }
    
    func customInit(){
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
