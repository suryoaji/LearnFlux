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
    
    static func getSmallStringMonth(int: Int)->String{
        switch int {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sep"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Des"
        default:
            return ""
        }
    }
    
    static func getDateFromTimestamp(timestamp: Double) -> (date: String, time: String){
        let date = NSDate(timeIntervalSince1970: timestamp)
        let dateFormatter : NSDateFormatter = {
            let tmpFormatter = NSDateFormatter()
            tmpFormatter.dateStyle = .LongStyle
            return tmpFormatter
        }()
        let timeFormatter : NSDateFormatter = {
            let tmpFormatter = NSDateFormatter()
            tmpFormatter.timeStyle = .ShortStyle
            return tmpFormatter
        }()
        return (date: dateFormatter.stringFromDate(date), time: timeFormatter.stringFromDate(date))
    }
    
    static func dateFromString(string: String)->NSDate?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yy-MM-dd HH:mm:ss +0000"
        return formatter.dateFromString(string)
    }
    
    static func getElementDate(element: NSCalendarUnit, stringDate: String)->Int?{
        let date = dateFromString(stringDate)
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let inDate = date{
            return calendar!.component(element, fromDate: inDate)
        }
        return nil
    }
    
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
        return designTextField(textField, insets: UIEdgeInsets (top: 10, left: leftInset, bottom: 10, right: 10))
    }
    
    static func designTextField (textField : OSTextField, insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)) -> OSTextField {
        let temp = textField
        temp.edgeInsets = insets
        temp.borderStyle = .Line
        temp.layer.borderWidth = 2
        temp.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).CGColor
        return temp
    }
    
    static func animateSetFocus(controller: UIViewController, toView: UIView, inout distance: Double, duration: CGFloat = KEYBOARD_ANIMATION_DURATION, keyboardHeight : CGFloat?){
        let toViewRect: CGRect = controller.view.window!.convertRect(toView.bounds, fromView: toView)
        let viewRect: CGRect = controller.view.window!.convertRect(controller.view.bounds, fromView: controller.view!)
        let midline: CGFloat = toViewRect.origin.y + 0.5 * toViewRect.size.height
        let numerator: CGFloat = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator: CGFloat = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction: CGFloat = numerator / denominator
        if heightFraction < 0.0 {
            heightFraction = 0.0
        }
        else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        if keyboardHeight != nil{
            distance = floor(Double(keyboardHeight! * heightFraction))
        }else{
            let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
            if orientation == .Portrait || orientation == .PortraitUpsideDown {
                distance = floor(Double(PORTRAIT_KEYBOARD_HEIGHT * heightFraction))
            }
            else {
                distance = floor(Double(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction))
            }
        }
        var viewFrame: CGRect = controller.view.frame
        viewFrame.origin.y -= CGFloat(distance)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(Double(duration))
        controller.view!.frame = viewFrame
        UIView.commitAnimations()
    }
    
    static func animateDismissSetFocus(controller: UIViewController, inout distance: Double){
        var viewFrame: CGRect = controller.view.frame
        viewFrame.origin.y += CGFloat(distance)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(Double(KEYBOARD_ANIMATION_DURATION))
        controller.view!.frame = viewFrame
        UIView.commitAnimations()
    }
    
    static func labelPerfectHeight (mylabel : UILabel, textToFit : String = "")->CGFloat {
        var str = textToFit;
        if (str == "") {
            str = mylabel.text!;
        }
        
        return str.boundingRectWithSize(CGSizeMake(mylabel.frame.size.width, 10000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: mylabel.font], context: nil).size.height;
        
    }
    
    static func showAlertMenu (viewController: UIViewController, title: String = "", message: String = "", choices: [String], styles: [UIAlertActionStyle?], addCancel : Bool = true, callback: ((Int)->Void)?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

        var useStyle = UIAlertActionStyle.Default;
        for i in 0..<choices.count {
            var contextStyle = useStyle;
            if (i < styles.count) {
                if (styles[i] != nil) { useStyle = styles[i]!; }
                if isSubStrExists(choices[i], findFor: "delete") || isSubStrExists(choices[i], findFor: "erase") { contextStyle = .Destructive; }
                if isSubStrExists(choices[i], findFor: "cancel") { contextStyle = .Cancel; }
            }
            let act: UIAlertAction = UIAlertAction(title:choices[i], style: contextStyle, handler: {(action: UIAlertAction) -> Void in
                if (callback != nil) { callback! (i); }
            });
            alert.addAction(act)
        }
        
        if (addCancel) {
            let act: UIAlertAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: {(action: UIAlertAction) -> Void in
                if (callback != nil) { callback! (choices.count); }
            });
            alert.addAction(act)
        }
        
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func mainThread (callback: (()->Void)) {
        dispatch_async(dispatch_get_main_queue()) {
            callback();
        }
    }
    
    static func isSubStrExists (mainStr: String, findFor: String) -> Bool {
        let str = mainStr.lowercaseString;
        let substr = findFor.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if str.rangeOfString(substr) != nil { return true; } else { return false; }
    }
}