//
//  UIImageView+ResizeProportionally.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/18/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import "UIImageView+ResizeProportionally.h"

@implementation UIImageView (ResizeProportionally)

- (void) resizeHeightProportionallyWithWidth:(float)width {
    CGRect curFrame = [self frame];
    CGSize curImgSize = [self.image size];
    float ratio = width / curImgSize.width;
    curFrame.size.width = width;
    curFrame.size.height = curImgSize.height * ratio;
    [self setFrame:curFrame];
}

@end