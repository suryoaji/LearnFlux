//
//  NotificationView.swift
//  LearnFlux
//
//  Created by ISA on 10/6/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

enum NotificationViewType{
    case Header
    case Row
}

class NotificationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var type : NotificationViewType?
    var layerArrow = CAShapeLayer()
    
    override var hidden: Bool{
        didSet{
            if hidden{
                if let type = type where type == .Row{
                    self.layer.mask = nil
                    if layerArrow.superlayer != nil{
                        layerArrow.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hidden = true
    }
    
    func dinamicCustomInit(location: CGRect = CGRectZero, type: NotificationViewType = .Header){
        dinamicSetFrame(location, type: type)
        setBorderLayer(2.0, borderHeight: 10.0, type: type)
        dinamicSetMaskLayer(location, height: 8.0)
    }
    
    private func dinamicSetFrame(location: CGRect, type: NotificationViewType){
        self.frame.size.width = UIScreen.mainScreen().bounds.width * 0.72
        self.frame.size.height = self.frame.size.width * 0.95
        if location.origin.x < UIScreen.mainScreen().bounds.width / 2{
            self.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.frame.size.width) * 1/5
        }else{
            self.frame.origin.x = (UIScreen.mainScreen().bounds.width - self.frame.size.width) * 4/5
        }
        self.frame.origin.y = location.origin.y + location.size.height
    }
    
    func dinamicSetMaskLayer(location: CGRect, height: CGFloat){
        let pointXLocation = location.origin.x - self.frame.origin.x + location.size.width / 2
        let maskPath = UIBezierPath()
        maskPath.moveToPoint(CGPointMake(0, height))
        maskPath.addLineToPoint(CGPointMake(pointXLocation - 8, height))
        maskPath.addLineToPoint(CGPointMake(pointXLocation, 0))
        maskPath.addLineToPoint(CGPointMake(pointXLocation + 8, 8))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, 8))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, self.frame.height))
        maskPath.addLineToPoint(CGPointMake(0, self.frame.height))
        maskPath.closePath()
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
    
    func customInit(viewController: UIViewController, viewIndicator: UIView, type: NotificationViewType = .Header){
        let viewIndicatorPosition = viewIndicator.convertRect(viewIndicator.frame, toView: viewController.view)
        self.setFrame(viewController, rect: viewIndicatorPosition, type: type)
        self.setBorderLayer(2.0, borderHeight: viewIndicatorPosition.size.height * 1/4 - 1, type: type)
        self.setMaskLayer(viewController, fromView: viewIndicator, height: viewIndicatorPosition.size.height * 1/4 - 3, type: type)
        
        if type == .Row{
            self.hidden = false
            viewController.view.bringSubviewToFront(self)
        }
    }
    
    private func setFrame(viewController: UIViewController, rect: CGRect, type: NotificationViewType){
        switch type {
        case .Header:
            self.frame.size.height = viewController.view.frame.height * 0.5
            self.frame.origin.y = rect.origin.y + rect.size.height - rect.size.height * 1/4 + 5
        case .Row:
            self.frame.origin.y = viewController.view.frame.height * 0.4
            self.frame.size.height = (viewController.view.frame.height - self.frame.origin.y) * 0.95
        }
        self.frame.size.width = viewController.view.frame.width * 3/4
        self.frame.origin.x = (viewController.view.frame.width - self.frame.width) * 4/5
    }
    
    private func setBorderLayer(borderWidth: CGFloat, borderHeight: CGFloat, type: NotificationViewType){
        self.layer.borderWidth = borderWidth
        var path = UIBezierPath()
        switch type {
        case .Header:
            self.layer.borderColor = LFColor.blue.CGColor
            layerArrow.fillColor = LFColor.blue.CGColor
            path = UIBezierPath(rect: CGRectMake(0, 0, self.frame.width, borderHeight))
        case .Row:
            self.layer.borderColor = LFColor.blue.CGColor
            layerArrow.fillColor = LFColor.blue.CGColor
            path = UIBezierPath(rect: CGRectMake(0, 0, borderHeight, self.frame.height))
        }
        layerArrow.path = path.CGPath
        self.layer.addSublayer(layerArrow)
    }
    
    private func setMaskLayer(viewController: UIViewController, fromView: UIView, height: CGFloat, type: NotificationViewType){
        switch type {
        case .Header:
            setMaskLayerUp(fromView, height: height)
        case .Row:
            setMaskLayerLeft(viewController, fromView: fromView, width: height)
        }
    }
    
    func setMaskLayerLeft(viewController: UIViewController, fromView: UIView, width: CGFloat){
        let buttonToViewLocation = fromView.convertRect(fromView.frame, toView: self)
        let location = buttonToViewLocation.origin.y + buttonToViewLocation.size.height / 2
        let maskPath = UIBezierPath()
        maskPath.moveToPoint(CGPointMake(width, 0))
        maskPath.addLineToPoint(CGPointMake(width, location - width))
        maskPath.addLineToPoint(CGPointMake(0, location))
        maskPath.addLineToPoint(CGPointMake(width, location + width))
        maskPath.addLineToPoint(CGPointMake(width, self.frame.height))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, self.frame.height))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, 0))
        maskPath.closePath()
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
    
    func setMaskLayerUp(fromView: UIView, height: CGFloat){
        let buttonToViewLocation = fromView.convertRect(fromView.frame, toView: self)
        let location = buttonToViewLocation.origin.x + buttonToViewLocation.size.width / 2
        let maskPath = UIBezierPath()
        maskPath.moveToPoint(CGPointMake(0, height))
        maskPath.addLineToPoint(CGPointMake(location - height, height))
        maskPath.addLineToPoint(CGPointMake(location, 0))
        maskPath.addLineToPoint(CGPointMake(location + height, height))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, height))
        maskPath.addLineToPoint(CGPointMake(self.frame.width, self.frame.height))
        maskPath.addLineToPoint(CGPointMake(0, self.frame.height))
        maskPath.closePath()
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}
