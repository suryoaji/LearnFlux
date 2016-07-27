//
//  ForgotPassword.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class ForgotPassword : UIViewController {
    
    @IBOutlet weak var tfEmail: OSTextfieldR!;
    var animatedDistance: Double = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.height = 50.0
    }
    
    // MARK: magic code for adjusting text field into view.
    
    func textFieldDidBeginEditing(textField: UITextField) {
        Util.animateSetFocus(self, toView: textField, distance: &animatedDistance, keyboardHeight: nil)
    }
    
    func textFieldDidEndEditing(textfield: UITextField) {
        Util.animateDismissSetFocus(self, distance: &animatedDistance)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.e_globalResignFirstResponderRec(self.view!)
    }
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        NSLog("touch")
        self.e_globalResignFirstResponderRec(self.view!)
        //    CGPoint touchPoint=[gesture locationInView:scrollView];
    }
    

    
}