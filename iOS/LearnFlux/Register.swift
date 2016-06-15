//
//  Register.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/12/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation
import AMPopTip

class Register : UIViewController {
    
    @IBOutlet var tfEmail : OSTextField!;
    @IBOutlet var tfUsername : OSTextField!;
    @IBOutlet var tfPassword : OSTextField!;
    @IBOutlet var tfConfirm : OSTextField!;
    @IBOutlet var tfFirstName : OSTextField!;
    @IBOutlet var tfLastName : OSTextField!;
    
    @IBOutlet var btnSubmit : UIButton!;
    
    var popTip = AMPopTip();
    
    var animatedDistance: Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tfEmail = Util.designTextField(tfEmail);
        tfUsername = Util.designTextField(tfUsername);
        tfPassword = Util.designTextField(tfPassword);
        tfConfirm = Util.designTextField(tfConfirm);
        tfFirstName = Util.designTextField(tfFirstName);
        tfLastName = Util.designTextField(tfLastName);
        
        self.title = "Register";
    }
    
    @IBAction func submit (sender: AnyObject) {
        popTip.hide()
        Engine.register(self, username: tfUsername.text!, firstName: tfFirstName.text!, lastName: tfLastName.text!, email: tfEmail.text!, password: tfPassword.text!, passwordConfirm: tfConfirm.text!) { status, JSON in
            if (status == .CustomError) {
                let error = JSON!["error"]! as! NSDictionary;
                print (error);
                dispatch_async(dispatch_get_main_queue()) {
                    if let errMsg = error.valueForKey("username") as? String {
                        self.tfUsername.becomeFirstResponder();
                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfUsername.frame)
                    }
                    else if let errMsg = error.valueForKey("email") as? String {
                        self.tfEmail.becomeFirstResponder();
                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfEmail.frame)
                    }
                    else if let errMsg = error.valueForKey("password") as? String {
                        self.tfPassword.becomeFirstResponder();
                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfPassword.frame)
                    }
                    else if let errMsg = error.valueForKey("passwordEqualToConfirmationPassword") as? String {
                        self.tfPassword.becomeFirstResponder();
                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfPassword.frame)
                    }
                    else if let errMsg = error.valueForKey("passwordConfirm") as? String {
                        self.tfConfirm.becomeFirstResponder();
                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfConfirm.frame)
                    }
                    else {
                        self.popTip.showText("Sorry, unhandled error occured.", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view, fromFrame: self.tfConfirm.frame)
                    }
                }
            }
            else if (status == .Success) {
                self.navigationController?.popViewControllerAnimated(true);
            }
        }
    }
    
    @IBAction func beginEdit (sender: AnyObject) {
        popTip.hide();
    }
    
    @IBAction func login (sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    // MARK: magic code for adjusting text field into view.
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let textFieldRect: CGRect = self.view.window!.convertRect(textField.bounds, fromView: textField)
        let viewRect: CGRect = self.view.window!.convertRect(self.view.bounds, fromView: self.view!)
        let midline: CGFloat = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
        let numerator: CGFloat = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height
        let denominator: CGFloat = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height
        var heightFraction: CGFloat = numerator / denominator
        if heightFraction < 0.0 {
            heightFraction = 0.0
        }
        else if heightFraction > 1.0 {
            heightFraction = 1.0
        }
        
        let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation == .Portrait || orientation == .PortraitUpsideDown {
            animatedDistance = floor(Double(PORTRAIT_KEYBOARD_HEIGHT * heightFraction))
        }
        else {
            animatedDistance = floor(Double(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction))
        }
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y -= CGFloat(animatedDistance)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(Double(KEYBOARD_ANIMATION_DURATION))
        self.view!.frame = viewFrame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(textfield: UITextField) {
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += CGFloat(animatedDistance)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(Double(KEYBOARD_ANIMATION_DURATION))
        self.view!.frame = viewFrame
        UIView.commitAnimations()
    }
    
    // MARK: magic code to make keyboard go away when tapped outside TextField

    override func globalResignFirstResponderRec(view: UIView) {
        if view.respondsToSelector(#selector(self.resignFirstResponder)) {
            view.resignFirstResponder()
        }
        for subview: UIView in view.subviews {
            self.globalResignFirstResponderRec(subview)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.globalResignFirstResponderRec(self.view!)
    }
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        NSLog("touch")
        self.globalResignFirstResponderRec(self.view!)
        //    CGPoint touchPoint=[gesture locationInView:scrollView];
    }

    // MARK: magic code to make cursor go to the next TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    

    
}