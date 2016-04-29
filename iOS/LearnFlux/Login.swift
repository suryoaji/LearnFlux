//
//  ViewController.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate {

    let aDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet weak var tfUsername: OSTextField!;
    @IBOutlet weak var tfPassword: OSTextField!;
    var animatedDistance: Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var temp = tfUsername;
        
        temp.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        temp.borderStyle = .Line;
        temp.layer.borderWidth = 2;
        temp.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).CGColor;
        temp.height = 50;
        
        temp = tfPassword;

        temp.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        temp.borderStyle = .Line;
        temp.layer.borderWidth = 2;
        temp.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1).CGColor;
        temp.height = 50;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.revealController.setMinimumWidth(0, maximumWidth: 0, forViewController: self.revealController.leftViewController)
        
//        self.revealController.setMinimumWidth(220.0, maximumWidth: 244.0, forViewController: self.revealController.leftViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Login") {
            aDelegate.userId = "1";
        }
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
}

