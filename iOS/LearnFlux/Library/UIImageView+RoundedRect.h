//
//  UIImageView+RoundedRect.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/2/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RoundedRect)

- (void) makeRoundedRectWithCornerRadius :(float)cornerRadius;
- (void) makeRounded;

@end