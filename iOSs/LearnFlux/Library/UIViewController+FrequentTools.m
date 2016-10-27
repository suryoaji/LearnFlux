//
//  UIView+FrequentTools.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/21/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import "UIViewController+FrequentTools.h"

@implementation UIViewController (FrequentTools)

- (float) getKeyboardHeightFromNotification:(NSNotification *)notification {
    
    // these code is to calculate how tall the keyboard based on current view
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    //        NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    return keyboardFrame.size.height;
}

@end