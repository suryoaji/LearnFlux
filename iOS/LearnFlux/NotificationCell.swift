//
//  NotificationCell.swift
//  LearnFlux
//
//  Created by ISA on 10/7/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(notification: Dictionary<String, String>){
        imageViewPhoto.image = UIImage(named: notification["photo"]!)
        labelDate.text = notification["timestamp"]
        
        let detailAttributedString = NSMutableAttributedString(string: notification["name"]! + " ", attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(12)])
        let stringActivity = NSMutableAttributedString(string: notification["activity"]!, attributes: [NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 12)!])
        detailAttributedString.appendAttributedString(stringActivity)
        let stringTo = NSMutableAttributedString(string: notification["to"] != nil ? " " + notification["to"]! + ".\n" : ".\n", attributes: [NSFontAttributeName : notification["to"] != nil ? UIFont.boldSystemFontOfSize(12) : UIFont(name: "Helvetica Neue", size: 12)!])
        detailAttributedString.appendAttributedString(stringTo)
        
        labelDetail.attributedText = detailAttributedString
        imageViewIcon.image = UIImage(named: notification["icon"]!)
        self.contentView.backgroundColor = notification["checked"]! == "1" ? UIColor(white: 245.0/255, alpha: 1.0) : UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
