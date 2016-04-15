//
//  UIView+FirstResponder.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 2/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FirstResponder)

- (id)findFirstResponder;
- (void) globalResignFirstResponderRec:(UIView*) view;
- (void) globalResignFirstResponder;

@end