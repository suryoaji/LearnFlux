//
//  FriendRequestCell.swift
//  LearnFlux
//
//  Created by ISA on 10/7/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

protocol FriendRequestCellDelegate: class{
    func buttonAcceptTapped(cell: FriendRequestCell)
}

class FriendRequestCell: UITableViewCell {
    weak var delegate: FriendRequestCellDelegate?
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFriends: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    var indexPath: NSIndexPath!
    var id: Int!
    
    @IBAction func buttonAccept(sender: UIButton) {
        if let delegate = delegate{
            delegate.buttonAcceptTapped(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(friend: Dictionary<String, AnyObject>, indexPath: NSIndexPath){
        self.indexPath = indexPath
        self.id = friend["id"] as! Int
        labelId.text = "\(self.id)"
        labelName.text = (friend["name"] as? String)?.capitalizedString
        labelFriends.text = friend["friends"] != nil ? "\((friend["friends"] as! Array<Int>).count) mutual friends" : ""
        buttonCancel.setTitle(indexPath.section == 0 ? "cancel" : "remove", forState: .Normal)
        imageViewPhoto.image = friend["photo"] as? UIImage ?? UIImage(named: "photo-container.png")
        
        if friend["photo"] != nil{
            if let stringPhoto = friend["photo"] as? String{
                imageViewPhoto.image = UIImage(named: stringPhoto)
            }
        }
    }
    
    func setValues(friend: User, indexPath: NSIndexPath){
        self.indexPath = indexPath
        self.id = friend.userId!
        labelId.text = "\(self.id)"
        labelName.text = friend.lastName == nil ? (friend.firstName!).capitalizedString : (friend.firstName! + " " + friend.lastName!).capitalizedString
        labelFriends.text = friend.mutualFriend != nil && friend.mutualFriend! != 0 ? "\(friend.mutualFriend!) mutual friends" : ""
        buttonCancel.setTitle(indexPath.section == 0 ? "cancel" : "remove", forState: .Normal)
        imageViewPhoto.image = friend.photo ?? UIImage(named: "photo-container.png")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
