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
    
    var textfieldClicked = UITextField()
    
    @IBOutlet var tfEmail : OSTextfieldR!;
    @IBOutlet var tfUsername : OSTextfieldR!;
    @IBOutlet var tfPassword : OSTextfieldR!;
    @IBOutlet var tfConfirm : OSTextfieldR!;
    @IBOutlet var tfFirstName : OSTextfieldR!;
    @IBOutlet var tfLastName : OSTextfieldR!;
    
    @IBOutlet var btnSubmit : UIButton!;
    
    var popTip = AMPopTip();
    
    var animatedDistance: Double = 0;
    
    @IBAction func submit (sender: AnyObject) {
        popTip.hide()
        if (self.tfUsername.text == "") {
            self.popTip.showText("Enter your desired username", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfUsername.frame);
            return;
        }
        else if (self.tfEmail.text == "") {
            self.popTip.showText("Enter valid email address", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfEmail.frame);
            return;
        }
        else if (self.tfFirstName.text == "") {
            self.popTip.showText("Enter your firstname", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfFirstName.frame);
            return;
        }
        else if (self.tfLastName.text == "") {
            self.popTip.showText("Enter your lastname (use '-' if there isn't any)", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfLastName.frame);
            return;
        }
        else if (self.tfPassword.text == "") {
            self.popTip.showText("Enter desired password", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfPassword.frame);
            return;
        }
        else if (self.tfConfirm.text == "") {
            self.popTip.showText("Please re-enter your password", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfConfirm.frame);
            return;
        }
        
        Engine.register(self, username: tfUsername.text!, firstName: tfFirstName.text!, lastName: tfLastName.text!, email: tfEmail.text!, password: tfPassword.text!, passwordConfirm: tfConfirm.text!) { status, JSON in
            if (status == .CustomError) {
//                let errorWrapper = JSON!["errors"]! as! NSDictionary;
//                let error = errorWrapper.valueForKey("messages")! as! NSDictionary;
//                print (error);
//                dispatch_async(dispatch_get_main_queue()) {
//                    if let errMsg = error.valueForKey("username") as? String {
//                        self.tfUsername.becomeFirstResponder();
//                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfUsername.frame)
//                    }
//                    else if let errMsg = error.valueForKey("email") as? String {
//                        self.tfEmail.becomeFirstResponder();
//                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfEmail.frame)
//                    }
//                    else if let errMsg = error.valueForKey("password") as? String {
//                        self.tfPassword.becomeFirstResponder();
//                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfPassword.frame)
//                    }
//                    else if let errMsg = error.valueForKey("passwordEqualToConfirmationPassword") as? String {
//                        self.tfPassword.becomeFirstResponder();
//                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfPassword.frame)
//                    }
//                    else if let errMsg = error.valueForKey("passwordConfirm") as? String {
//                        self.tfConfirm.becomeFirstResponder();
//                        self.popTip.showText(errMsg, direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfConfirm.frame)
//                    }
//                    else {
//                        self.popTip.showText("Sorry, unhandled error occured.", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfConfirm.frame)
//                    }
//                }
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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Register";
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: magic code for adjusting text field into view.
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textfieldClicked = textField
    }
    
    func keyboardWillShow(notification: NSNotification){
        let duration = CGFloat(Float(String(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!))!)
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        Util.animateSetFocus(self, toView: textfieldClicked, distance: &animatedDistance, duration: duration, keyboardHeight: keyboardHeight)
    }
    
    func textFieldDidEndEditing(textfield: UITextField) {
        Util.animateDismissSetFocus(self, distance: &animatedDistance)
    }
    
    // MARK: magic code to make keyboard go away when tapped outside TextField
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.e_globalResignFirstResponderRec(self.view!)
    }
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        NSLog("touch")
        self.e_globalResignFirstResponderRec(self.view!)
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