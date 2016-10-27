//
//  NSDictionary+StringForKey.m
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "NSDictionary+ForKey.h"

@implementation NSDictionary(ForKey)

- (NSString *) stringForKey:(NSString *)key { return (NSString *)[self valueForKey:key]; }
- (int) intForKey:(NSString *)key { return (int)[self valueForKey:key]; }
- (NSDictionary *) dictForKey:(NSString *)key { return (NSDictionary *)[self valueForKey:key]; }

@end
