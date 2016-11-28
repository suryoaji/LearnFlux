//
//  SectionTitleCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

protocol SectionTitleCellDelegate: class{
    func editButtonTapped(cell: SectionTitleCell)
}

class SectionTitleCell: UITableViewCell {
    
    weak var delegate: SectionTitleCellDelegate?

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    var indexPath : NSIndexPath!
    
    @IBAction func editButtonTapped(sender: UIButton) {
        if let delegate = delegate{
            delegate.editButtonTapped(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customInit(title: String, indexPath: NSIndexPath, icon: String? = nil, titleEdit: String){
        self.contentView.backgroundColor = indexPath.section == 0 ? UIColor.whiteColor() : UIColor(white: 245/255.0, alpha: 1.0)
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        titleButton.setTitle(title, forState: .Normal)
        editButton.setTitle(titleEdit, forState: .Normal)
        if let icon = icon{
            editButton.setImage(UIImage(named: icon), forState: .Normal)
            editButton.contentHorizontalAlignment = .Center
            editButton.contentEdgeInsets = indexPath.section != 0 ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(editButton.frame.height / 3, 0, 0, 0)
            editButton.frame.size.width = self.frame.width * 0.24
        }else{
            editButton.setImage(nil, forState: .Normal)
            editButton.contentHorizontalAlignment = .Left
            editButton.contentEdgeInsets = UIEdgeInsetsMake(editButton.frame.height / 3, 0, 0, 0)
            if indexPath.section != 0 { editButton.hidden = true } else{ editButton.hidden = false }
            editButton.frame.size.width = self.frame.width * 0.3
        }
        editButton.frame.origin.x = self.frame.width - editButton.frame.size.width
        self.indexPath = indexPath
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
