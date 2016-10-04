//
//  RowInterestsCell.swift
//  LearnFlux
//
//  Created by ISA on 9/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class RowInterestsCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customInit(titles: [String], indexPath: NSIndexPath){
        if indexPath.row == 1 || indexPath.row == titles.count + 2{
            cleanSubview()
        }else{
            let row = indexPath.row - 2
            if row < titles.count{
                label.text = titles[row]
            }
            switch row {
            case 0:
                view.backgroundColor = UIColor.redColor()
            case 1:
                view.backgroundColor = UIColor.greenColor()
            case 2:
                view.backgroundColor = UIColor.blueColor()
            default:
                break
            }
        }
    }
    
    func cleanSubview(){
        for subview in contentView.subviews{
            subview.removeFromSuperview()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
