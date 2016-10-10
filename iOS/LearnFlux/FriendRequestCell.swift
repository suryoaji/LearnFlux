//
//  FriendRequestCell.swift
//  LearnFlux
//
//  Created by ISA on 10/7/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFriends: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(friend: Dictionary<String, String>, indexPath: NSIndexPath){
        labelName.text = friend["name"]
        labelFriends.text = friend["friends"] != nil ? "\(friend["friends"]!) mutual friends" : ""
        buttonCancel.setTitle(indexPath.section == 0 ? "cancel" : "remove", forState: .Normal)
        imageViewPhoto.image = UIImage(named: friend["photo"]!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
