//
//  NSString+Trim.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 2/23/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString(Trim)

- (NSString *) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

