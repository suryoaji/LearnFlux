//
//  UISlider+Rotate.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/22/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UIView+Rotate.h"

@implementation UIView(Rotate)

- (void) rotateWithDegree:(float)degree {
    CGAffineTransform trans = CGAffineTransformMakeRotation(degree / 180 * M_PI);
    self.transform = trans;
}

- (void) rotateWithRadian:(float)radian {
    CGAffineTransform trans = CGAffineTransformMakeRotation(radian);
    self.transform = trans;
}


@end

