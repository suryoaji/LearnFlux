//
//  NSDictionary+StringForKey.h
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/29/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (ForKey)

- (NSString *) stringForKey:(NSString *)key;
- (int) intForKey:(NSString *)key;
- (NSDictionary *) dictForKey:(NSString *)key;

@end