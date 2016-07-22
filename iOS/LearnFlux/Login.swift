//
//  ViewController.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit
import AMPopTip

class Login: UIViewController, UITextFieldDelegate {

    let aDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    let popTip = AMPopTip();
    var textfieldClicked = UITextField()
    
    @IBOutlet weak var tfUsername: OSTextfieldR!
    @IBOutlet weak var tfPassword: OSTextfieldR!
    var animatedDistance: Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.revealController.setMinimumWidth(0, maximumWidth: 0, forViewController: self.revealController.leftViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
//        self.revealController.setMinimumWidth(220.0, maximumWidth: 244.0, forViewController: self.revealController.leftViewController)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.globalResignFirstResponder();
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
    
    override func globalResignFirstResponderRec(view: UIView) {
        self.view.window?.endEditing(true);
        if view.respondsToSelector(#selector(self.resignFirstResponder)) {
            view.resignFirstResponder()
        }
        for subview: UIView in view.subviews {
            self.globalResignFirstResponderRec(subview)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.window?.endEditing(true);
        self.globalResignFirstResponderRec(self.view!)
    }
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        NSLog("touch")
        self.globalResignFirstResponderRec(self.view!)
        //    CGPoint touchPoint=[gesture locationInView:scrollView];
    }
    
    @IBAction func login (sender: AnyObject) {
        self.globalResignFirstResponder();
        popTip.hide();
        if (self.tfUsername.text == "") {
            self.popTip.showText("Enter your username", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfUsername.frame);
            self.tfUsername.becomeFirstResponder();
            return;
        }
        else if (self.tfPassword.text == "") {
            self.popTip.showText("Enter your password", direction: AMPopTipDirection.Up, maxWidth: 200, inView: self.view.viewWithTag(100), fromFrame: self.tfPassword.frame);
            self.tfPassword.becomeFirstResponder();
            return;
        }
        
        Engine.login(self, username: tfUsername.text!, password: tfPassword.text!) { status, JSON in
            if (JSON == nil) {
                self.tfUsername.becomeFirstResponder();
            }
            else {
                Engine.me() { status, JSON in
                    self.performSegueWithIdentifier("Home", sender: self);
                }
            }
        }
    }
    
    @IBAction func beginEdit (sender: AnyObject) {
        popTip.hide();
    }
}

