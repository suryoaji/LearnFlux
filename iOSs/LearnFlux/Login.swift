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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.revealController.setMinimumWidth(0, maximumWidth: 0, forViewController: self.revealController.leftViewController)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pushToHomeVC), name: "dataSingletonReady", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.window?.endEditing(true);
        self.e_globalResignFirstResponderRec(self.view!)
    }
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        NSLog("touch")
        self.e_globalResignFirstResponderRec(self.view!)
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
        Util.showIndicatorDarkOverlay(self.view, message: "loading")
        self.isPush = false
        Engine.login(self, username: tfUsername.text!, password: tfPassword.text!) { status, JSON in
             if status == .Success && JSON != nil{
                Engine.me(self) { status, JSON in
                    guard status == .Success else{
                        Util.stopIndicator(self.view)
                        return
                    }
                    guard let dataJSON = JSON as? dictType else{
                        Util.stopIndicator(self.view)
                        return
                    }
                    if !dataJSON.isEmpty{
                        Engine.getGroups(){ status, arrGroup in
                            if let groups = arrGroup{
                                for eachGroup in groups{
                                    Engine.getGroupInfo(groupId: eachGroup.id){ status, group in
                                        Engine.clientData.updateGroup(group!)
                                    }
                                }
                            }
                        }
                        Engine.getThreads()
                        Engine.getEvents(){ status, JSON in
                            if let events = Engine.clientData.getMyEvents(){
                                for eachEvent in events{
                                    Engine.getEventDetail(event: eachEvent)
                                }
                            }
                        }
                        Engine.getConnection()
                        Engine.clientData.setMyChildrens()
                    }else{
                        Util.stopIndicator(self.view)
                        Util.showMessageInViewController(self, title: "Our apologies.", message: "We sincerely apologize for the inconvenience. Our server is currently in maintenance, but will return shortly. Thank you for your patience", buttonOKTitle: "OK", callback: nil)
                    }
                }
            }else{
                self.tfUsername.becomeFirstResponder();
                Util.stopIndicator(self.view)
            }
        }
    }
    
    @IBAction func beginEdit (sender: AnyObject) {
        popTip.hide();
    }
    
    var isPush = false
    @IBAction func pushToHomeVC(){
        if !isPush{
            self.isPush = true
            Util.stopIndicator(self.view)
            let coverView = UIView(frame: UIScreen.mainScreen().bounds)
            coverView.backgroundColor = UIColor.whiteColor()
            coverView.alpha = 0.0
            self.view.addSubview(coverView)
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                coverView.alpha = 1.0
                }, completion: { finished in
                    coverView.removeFromSuperview()
                    let vc = Util.getViewControllerID("NavCon")
                    self.revealController.frontViewController = vc
            })
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.globalResignFirstResponder();
    }
}






















