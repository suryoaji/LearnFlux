//
//  OSTextfieldR.swift
//  LearnFlux
//
//  Created by ISA on 7/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class OSTextfieldR: UITextField{
    var lineColor : UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
    var edgeInsets : UIEdgeInsets!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createTextfield()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createTextfield()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, self.edgeInsets))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets))
    }
    
    func createTextfield(){
        self.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.borderStyle = .Line
        self.layer.borderWidth = 2.0
        self.layer.borderColor = lineColor.CGColor
    }
    
    func setLeftInset(inset: Float){
        self.edgeInsets.left = CGFloat(inset)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
