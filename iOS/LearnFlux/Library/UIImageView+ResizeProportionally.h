//
//  UIImageView+ResizeProportionally.h
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/18/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ResizeProportionally)

- (void) resizeHeightProportionallyWithWidth:(float)width;  // this will also set the width

@end