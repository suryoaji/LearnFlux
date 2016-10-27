//
//  NSIndexPath+MockupShortcut.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/1/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "NSIndexPath+MockupShortcut.h"

@implementation NSIndexPath (MockupShortcut)


- (NSString *) code {
    return [NSString stringWithFormat:@"%ld-%ld", (long)self.section, (long)self.row];
}

- (BOOL) isEqualCode:(NSString *)codeCompare {
    return [[self code] isEqualToString:codeCompare];
}



@end