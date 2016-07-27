//
//  Profile.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 7/15/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

class Profile : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let rowTitle = ["Name", "Affiliated Organisations", "Role", "Interests", "Children", "Connections", "Children profile"];
    var isPrivate = true;
    
    var animatedDistance : Double = 0;
    
//    let oriDescHeight = 
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Profile";
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basic")!;
        
        let lbl = cell.viewWithTag(1)! as! UILabel;
//        let tf = cell.viewWithTag(2)! as! UITextField;
        
        lbl.text = rowTitle[indexPath.row];
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        let tf = cell?.viewWithTag(2)! as! UITextField;
        tf.becomeFirstResponder();
    }

    
    
    // MARK: magic code for adjusting text field into view.
    
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
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
    
    @IBAction func textFieldDidEndEditing(textfield: UITextField) {
        var viewFrame: CGRect = self.view.frame
        viewFrame.origin.y += CGFloat(animatedDistance)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true);
        UIView.setAnimationDuration(Double(KEYBOARD_ANIMATION_DURATION))
        self.view!.frame = viewFrame
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
}