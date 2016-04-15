//
//  UIView+RoundedRect.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/15/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UIView+RoundedRect.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RoundedRect)

- (void) makeViewRoundedRectWithCornerRadius :(float)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void) makeViewRounded {
    [self makeViewRoundedRectWithCornerRadius:self.frame.size.width / 2];
}


@end