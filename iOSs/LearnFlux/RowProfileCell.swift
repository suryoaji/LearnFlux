//
//  RowProfileCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

protocol RowProfileCellDelegate: class{
    func buttonMoreTapped(cell: RowProfileCell)
}

class RowProfileCell: UITableViewCell {
    weak var delegate : RowProfileCellDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelRoles: UILabel!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var labelWork: UILabel!
    @IBOutlet weak var labelSFrom: UILabel!
    @IBOutlet weak var labelSWork: UILabel!
    @IBOutlet weak var labelMutuals: UILabel!
    @IBOutlet weak var imageViewMutualPhoto: UIImageView!
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
        if let name = values["name"] { self.labelName.text = (name as? String)?.capitalizedString }
        
        if let from = values["from"] where !(from as! String).isEmpty {
            self.labelFrom.text = (from as? String)?.capitalizedString
            self.labelSFrom.hidden = false
            self.labelFrom.hidden = false
        }else{
            self.labelSFrom.hidden = true
            self.labelFrom.hidden = true
        }
        
        if let work = values["work"] where !(work as! String).isEmpty {
            self.labelWork.text = (work as? String)?.capitalizedString
            self.labelSWork.hidden = false
            self.labelWork.hidden = false
        }else{
            self.labelSWork.hidden = true
            self.labelWork.hidden = true
        }
        
        if let mutuals = values["mutual"] as? Array<Int> where !mutuals.isEmpty{
            let mutuals = setLabelMutuals(mutuals)
            self.labelMutuals.attributedText = mutuals.1
            self.imageViewMutualPhoto.image = mutuals.0
        }
        
        if let roles = values["roles"] {
            self.labelRoles.text = roles as? String
            if heightForView(self.labelRoles.text!, font: UIFont(name: "Helvetica Neue", size: 14.0)!, width: scale * self.labelRoles.frame.width) < scale * self.labelRoles.frame.height && buttonMore != nil{
                buttonMore.removeFromSuperview()
            }
        }
        if let id = values["id"] as? Int where id == Engine.clientData.cacheSelfId(){
            buttonOpenChat.hidden = true
            labelMutuals.hidden = true
            imageViewMutualPhoto.hidden = true
        }else{
            buttonOpenChat.hidden = false
            labelMutuals.hidden = false
            imageViewMutualPhoto.hidden = false
        }
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
    
    private func setLabelMutuals(mutuals: Array<Int>) -> (UIImage, NSAttributedString){
        let firstWords = NSMutableAttributedString(string: "\(mutuals.count) Mutuals friends, ", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightMedium)])
        let friend1 = Engine.clientData.getMyConnection().friends.filter({ $0.userId! == mutuals[0] }).first!
        let secondWords = NSMutableAttributedString(string: "including \(friend1.lastName != nil ? friend1.firstName! + " " + friend1.lastName! : friend1.firstName!)", attributes: [NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 14)!])
        if mutuals.count > 1{
            let friend2 = Engine.clientData.getMyConnection().friends.filter({ $0.userId! == mutuals[1] }).first!
            let addSecondWords = NSMutableAttributedString(string: ", and \(friend2.lastName != nil ? friend2.firstName! + " " + friend2.lastName! : friend2.firstName!)", attributes: [NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 14)!])
            secondWords.appendAttributedString(addSecondWords)
        }
        firstWords.appendAttributedString(secondWords)
        return (friend1.photo ?? UIImage(named: "photo-container.png")!, firstWords)
    }

}

























