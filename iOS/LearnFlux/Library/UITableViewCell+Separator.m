//
//  UITableViewCell+Separator.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/2/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UITableViewCell+Separator.h"

@implementation UITableViewCell (Separator)

- (void) setSeparatorType:(CellSeparatorTypes)separatorTypes {
    switch (separatorTypes) {
        case CellSeparatorFull:
            self.preservesSuperviewLayoutMargins = NO;
            self.separatorInset = UIEdgeInsetsZero;
            self.layoutMargins = UIEdgeInsetsZero;
            break;
        case CellSeparatorNone:
            self.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
            break;
        default:
            break;
    }
}


@end