//
//  CommonUtilitySwift.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 5/3/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class Util : NSObject {
    
    static func showMessageInViewController(viewController: UIViewController?, title: String, message: String, buttonOKTitle: String = "Ok", callback: (()->Void)? = nil) -> () {
        if (viewController == nil) { return; }
        let alertController: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        let actionOk: UIAlertAction = UIAlertAction(title:buttonOKTitle, style: .Default) { (nil)->() in
            if (callback != nil) { callback!(); }
        }
        alertController.addAction(actionOk)
        dispatch_async(dispatch_get_main_queue()) {
            viewController!.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    static func showChoiceInViewController(viewController: UIViewController?, title: String, message: String, buttonTitle: [String], buttonStyle: [UIAlertActionStyle?]?,callback: ((Int)->Void)?) -> () {
        if (viewController == nil) { return; }
        let alertController: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        
        for i in 0..<buttonTitle.count {
            let btn = buttonTitle[i];
            var style : UIAlertActionStyle = UIAlertActionStyle.Default;
            if (buttonStyle != nil) {
                if (buttonStyle![i] != nil) {
                    style = buttonStyle![i]!;
                }
            }
            let action: UIAlertAction = UIAlertAction(title:btn, style: style) { (nil)->Void in
                if (callback != nil) { callback!(i); }
            }
            alertController.addAction(action)
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            viewController!.presentViewController(alertController, animated: true, completion: nil)
        }
    }
  
    
    static func showChoiceInViewController(viewController: UIViewController?, title: String, message: String, buttonOKTitle: String = "Ok", buttonCancelTitle: String = "Cancel", callback: ((Int)->Void)? = nil) -> () {
        if (viewController == nil) { return; }
        let alertController: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .Alert)
        
        let actionOk: UIAlertAction = UIAlertAction(title:buttonOKTitle, style: .Default) { (nil)->() in
            if (callback != nil) {
                callback!(0)
            }
        }
        alertController.addAction(actionOk)
        
        let actionCancel: UIAlertAction = UIAlertAction(title:buttonCancelTitle, style: .Cancel) { (nil)->() in
            if (callback != nil) {
                callback!(1)
            }
        }
        alertController.addAction(actionCancel)

        dispatch_async(dispatch_get_main_queue()) {
            viewController!.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    static func showIndicatorDarkOverlay (view: UIView, message: String = "") {
        if (view.viewWithTag(12937) != nil) {
            stopIndicator(view);
        }
        
        let overlay = UIView(frame: view.frame);
        overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3);
        overlay.tag = 12937;
        view.addSubview(overlay);
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = overlay.center
        overlay.addSubview(indicator)
        overlay.bringSubviewToFront(indicator);
        view.bringSubviewToFront(overlay);
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating();
        
        let label = UILabel();
        label.text = message;
        label.font = label.font.fontWithSize(15);
        label.textColor = UIColor.whiteColor();
        label.center = overlay.center;
        
        if (message != "") {
            indicator.y -= 20;
            label.y += 20;
        }
        
    }
    
    static func stopIndicator (view: UIView) {
        let vcs = view.viewWithTag(12937);
        var vc : UIView!;
        if (vcs != nil) {
            vc = vcs
            vc.removeFromSuperview();
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }

    static func getViewControllerID(vcname: String, fromStoryboard storyboardName: String = "Main") -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(vcname)
    }
    
    static func designTextField (textField : OSTextField, leftInset: CGFloat) -> OSTextField {
        return designTextField(textField, insets: UIEdgeInsets (top: 10, left: leftInset, bottom: 10, right: 10));
    }
    
    static func designTextField (textField : OSTextField, insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) -> OSTextField {
        let temp = textField;
        temp.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        temp.borderStyle = .Line;
        temp.layer.borderWidth = 2;
        temp.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).CGColor;
        temp.height = 50;
        return temp;
    }
    
}