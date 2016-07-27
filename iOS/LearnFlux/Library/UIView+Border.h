//
//  UIView+Border.h
//  EMAN
//
//  Created by Danny Raharja on 12/22/15.
//  Copyright © 2015 Danny Raharja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;
- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

@end
