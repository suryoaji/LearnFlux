//
//  NSDate+String.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate(String)

- (NSString *) stringValueWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    //Optionally for time zone conversions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    return [formatter stringFromDate:self];
}

- (NSString *) stringValue {
    return [self stringValueWithFormat:@"MMM dd, yyyy"];
}

@end