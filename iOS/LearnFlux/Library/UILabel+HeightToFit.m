//
//  UILabel+FitToHeight.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/14/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import "UILabel+HeightToFit.h"

@implementation UILabel (heightToFit)

-(void) heightToFit {
    CGRect framex = self.frame;
    if ([self text] == nil || [[self text] isEqualToString:@""]) {
        [self setText:@"T"];
        [self sizeToFit];
        [self setText:@""];
    }
    else
        [self sizeToFit];
    framex.origin.x = self.frame.origin.x;
    framex.origin.y = self.frame.origin.y;
    framex.size.height = self.frame.size.height;
    [self setFrame:framex];
}

@end