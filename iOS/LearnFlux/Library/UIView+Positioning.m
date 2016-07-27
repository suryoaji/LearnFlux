//
//  UIView+Positioning.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/14/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import "UIView+Positioning.h"


@implementation UIView (GCLibrary)

- (CGFloat) height {
    return self.frame.size.height;
}

- (CGFloat) width {
    return self.frame.size.width;
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (CGFloat) y {
    return self.frame.origin.y;
}

- (CGFloat) xOnScreen {
    CGPoint localPoint = [self bounds].origin;
    CGPoint basePoint = [self convertPoint:localPoint toView:nil];
    return basePoint.x;
}

- (CGFloat) yOnScreen {
    CGPoint localPoint = [self bounds].origin;
    CGPoint basePoint = [self convertPoint:localPoint toView:nil];
    return basePoint.y;
}

- (CGFloat) centerY {
    return self.center.y;
}

- (CGFloat) centerX {
    return self.center.x;
}

- (void) setHeight:(CGFloat) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void) setWidth:(CGFloat) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void) setX:(CGFloat) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (void) setY:(CGFloat) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

@end
