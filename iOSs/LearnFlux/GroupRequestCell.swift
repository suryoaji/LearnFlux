//
//  GroupRequestCell.swift
//  LearnFlux
//
//  Created by ISA on 11/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

protocol GroupRequestCellDelegate: class{
    func buttonAcceptTappedGroupRequestCell(cell: GroupRequestCell)
}

class GroupRequestCell: UITableViewCell {
    weak var delegate: GroupRequestCellDelegate?
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFriends: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    var indexPath: NSIndexPath!
    var id: String!
    
    @IBAction func buttonAccept(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonAcceptTappedGroupRequestCell(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(group: String, indexPath: NSIndexPath){
        self.indexPath = indexPath
        self.id = group
        labelId.text = "\(self.id)"
        labelName.text = ""
        labelFriends.text = ""
        buttonCancel.setTitle("cancel", forState: .Normal)
        imageViewPhoto.image = UIImage(named: "photo-container.png")
    }
    
    func setValues(group: Group, indexPath: NSIndexPath){
        self.indexPath = indexPath
        self.id = group.id
        labelId.text = "\(self.id)"
        labelName.text = group.name.capitalizedString
        labelFriends.text = ""
        buttonCancel.setTitle("cancel", forState: .Normal)
        imageViewPhoto.image = group.image ?? UIImage(named: "photo-container.png")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
