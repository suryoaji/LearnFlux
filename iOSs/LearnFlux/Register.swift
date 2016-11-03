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
        guard let username = self.tfUsername.text where !username.isEmpty else{
            self.popError("Enter your desired username", inView: tfUsername)
            return
        }
        guard let email = self.tfEmail.text where !email.isEmpty else{
            self.popError("Enter valid email address", inView: tfEmail)
            return
        }
        guard let firstName = self.tfFirstName.text where !firstName.isEmpty else{
            self.popError("Enter your firstname", inView: tfFirstName)
            return
        }
        guard let lastName = self.tfLastName.text where !lastName.isEmpty else{
            self.popError("Enter your lastname (use '-' if there isn't any)", inView: tfLastName)
            return
        }
        guard let password = self.tfPassword.text where !password.isEmpty else{
            self.popError("Enter desired password", inView: tfPassword)
            return
        }
        guard let confirm = self.tfConfirm.text where !confirm.isEmpty else{
            self.popError("Please re-enter your password", inView: tfConfirm)
            return
        }
        Engine.register(self, username: username, firstName: firstName, lastName: lastName, email: email, password: password, passwordConfirm: confirm) { status, JSON in
            if (status == .CustomError) {
                if (status == .CustomError) {
                    let errors = (JSON!["errors"] as! Array<Dictionary<String, AnyObject>>).first!
                    if let message = errors["details"] as? String{
                        if message.lowercaseString.containsString("username"){
                            self.popError(message, inView: self.tfUsername)
                        }else if message.lowercaseString.containsString("email"){
                            self.popError(message, inView: self.tfEmail)
                        }else if message.lowercaseString.containsString("password"){
                            self.popError(message, inView: self.tfPassword)
                        }else{
                            self.popError(message, inView: self.btnSubmit)
                        }
                        return
                    }
                }
            }
            else if (status == .Success) {
                self.performSegueWithIdentifier("unwind", sender: self)
            }
        }
    }
    
    @IBAction func beginEdit (sender: AnyObject) {
        popTip.hide();
    }
    
    @IBAction func login (sender: AnyObject) {
        self.performSegueWithIdentifier("unwind", sender: self)
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
    
    func popError(message: String, inView: UIView){
        self.popTip.showText(message, direction: AMPopTipDirection.Up, maxWidth: message.characters.count > 30 ? 200 : 100, inView: self.view.viewWithTag(100), fromFrame: inView.frame);
    }
    
}