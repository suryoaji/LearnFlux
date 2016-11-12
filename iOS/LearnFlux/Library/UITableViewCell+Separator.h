//
//  UITableViewCell+Separator.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/2/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum cellSeparatorTypes
{
    CellSeparatorNone,
    CellSeparatorNormal,
    CellSeparatorFull
} CellSeparatorTypes;

@interface UITableViewCell (Separator)

- (void) setSeparatorType:(CellSeparatorTypes)separatorTypes;

@end
