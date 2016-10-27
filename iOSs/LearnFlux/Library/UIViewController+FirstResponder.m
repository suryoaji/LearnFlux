//
//  UIView+FirstResponder.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 2/16/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UIViewController+FirstResponder.h"

@implementation UIViewController(FirstResponder)

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

- (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}

- (void) globalResignFirstResponder {
    [self globalResignFirstResponderRec:[self view]];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end

