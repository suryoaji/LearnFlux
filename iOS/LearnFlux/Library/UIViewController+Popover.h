//
//  UIViewController+Popover.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverDateViewController.h"

@interface UIViewController (Popover)

- (NSDate *) popoverDate:(NSDate *)date sourceView:(UIView *)view;

@end