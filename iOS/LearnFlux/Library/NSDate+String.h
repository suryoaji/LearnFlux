//
//  NSDate+String.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/11/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (String)

- (NSString *) stringValueWithFormat:(NSString *)format;
- (NSString *) stringValue;

@end