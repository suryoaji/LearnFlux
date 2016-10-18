//
//  RowProfileCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

@objc protocol RowProfileCellDelegate{
    func buttonMoreTapped(cell: RowProfileCell)
}

class RowProfileCell: UITableViewCell {
    weak var delegate : RowProfileCellDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRoles: UILabel!
    @IBOutlet weak var buttonOpenChat: UIButton!
    @IBOutlet weak var containerViewInsideUpper: UIView!
    @IBOutlet weak var containerViewInsideLower: UIView!
    @IBOutlet weak var buttonMore: UIButton!
    @IBAction func buttonMoreTapped(sender: AnyObject) {
        if let delegate = delegate{
            delegate.buttonMoreTapped(self)
        }
    }
    
    func resizeLabelRoles(byScale: CGFloat){
        if buttonMore != nil{
            let plusHeight = (heightForView(labelRoles.text!, font: labelRoles.font, width: labelRoles.frame.width * byScale) - labelRoles.frame.height)
            labelRoles.numberOfLines = 0
            labelRoles.frame.size.height += plusHeight
            containerViewInsideUpper.frame.size.height += plusHeight - buttonMore.frame.height + 4
            self.frame.size.height += plusHeight - buttonMore.frame.height + 4
            buttonMore.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customInit()
    }
    
    func customInit(){
        containerView.layer.borderColor = UIColor(white: 220.0/255, alpha: 1.0).CGColor
        containerView.layer.borderWidth = 1.0
    }
    
    func setValues(values: Dictionary<String, AnyObject>, scale: CGFloat = 1.0, stateMore: Bool = false){
        if let photo = values["photo"] { self.imageViewPhoto.image = photo as? UIImage }
        if let name = values["name"] { self.labelName.text = name as? String }
        if let roles = values["roles"] { self.labelRoles.text = roles as? String }
        if let id = values["id"] as? Int where id == Engine.clientData.cacheMe()!["id"] as! Int{ buttonOpenChat.hidden = true } else{ buttonOpenChat.hidden = false }
        if stateMore{ resizeLabelRoles(scale) }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

}
