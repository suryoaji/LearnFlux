//
//  UIImageView+RoundedRect.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/2/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UIImageView+RoundedRect.h"

@implementation UIImageView (RoundedRect)

- (void) makeRoundedRectWithCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                cornerRadius:cornerRadius] addClip];
    [self.image drawInRect:self.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = finalImage;
}

- (void) makeRounded {
    [self makeRoundedRectWithCornerRadius:self.frame.size.width / 2];
}


@end