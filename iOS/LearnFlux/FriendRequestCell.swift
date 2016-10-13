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
    
    func setValues(friend: Dictionary<String, AnyObject>, indexPath: NSIndexPath){
        labelName.text = friend["name"] as? String
        labelFriends.text = friend["friends"] != nil ? "\(friend["friends"]!) mutual friends" : ""
        buttonCancel.setTitle(indexPath.section == 0 ? "cancel" : "remove", forState: .Normal)
        imageViewPhoto.image = friend["photo"] as? UIImage ?? UIImage(named: "photo-container.png")
        
        if friend["photo"] != nil{
            if let stringPhoto = friend["photo"] as? String{
                imageViewPhoto.image = UIImage(named: stringPhoto)
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
