//
//  UIView+Positioning.h
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/14/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (GCLibrary)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, readonly) CGFloat xOnScreen;
@property (nonatomic, readonly) CGFloat yOnScreen;
@end