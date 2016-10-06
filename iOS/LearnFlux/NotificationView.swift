//
//  NotificationView.swift
//  LearnFlux
//
//  Created by ISA on 10/6/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hidden = true
    }
    
    func customInit(viewController: UIViewController, viewIndicator: UIView){
        let viewIndicatorPosition = viewIndicator.convertRect(viewIndicator.frame, toView: viewController.view)
        self.setFrame(viewController, rect: viewIndicatorPosition)
        self.setBorderLayer(2.0, borderHeight: viewIndicatorPosition.size.height * 1/4 - 1)
        self.setMaskLayer(viewIndicator, height: viewIndicatorPosition.size.height * 1/4 - 3)
    }
    
    private func setFrame(viewController: UIViewController, rect: CGRect){
        self.frame.size.width = viewController.view.frame.width * 3/4
        self.frame.size.height = viewController.view.frame.height * 0.5
        self.frame.origin.x = (viewController.view.frame.width - self.frame.width) * 4/5
        self.frame.origin.y = rect.origin.y + rect.size.height - rect.size.height * 1/4 + 5
    }
    
    private func setBorderLayer(borderWidth: CGFloat, borderHeight: CGFloat){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = LFColor.green.CGColor
        
        let path = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, borderHeight))
        let layer = CAShapeLayer()
        layer.fillColor = LFColor.green.CGColor
        layer.path = path.CGPath
        self.layer.addSublayer(layer)
    }
    
    private func setMaskLayer(fromView: UIView, height: CGFloat){
        let buttonToViewLocation = fromView.convertRect(fromView.frame, toView: self)
        let location = buttonToViewLocation.origin.x + buttonToViewLocation.size.width / 2
        let heightArrow = height
        let widthArrow = heightArrow
        let maskPath = UIBezierPath()
        maskPath.moveToPoint(CGPointMake(0, heightArrow))
        maskPath.addLineToPoint(CGPointMake(location - widthArrow, heightArrow))
        maskPath.addLineToPoint(CGPointMake(location, 0))
        maskPath.addLineToPoint(CGPointMake(location + widthArrow, heightArrow))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, heightArrow))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, self.frame.height))
        maskPath.addLineToPoint(CGPointMake(0, self.frame.height))
        maskPath.closePath()
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}
