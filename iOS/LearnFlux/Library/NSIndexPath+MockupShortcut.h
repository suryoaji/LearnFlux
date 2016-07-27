//
//  NSIndexPath+MockupShortcut.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 3/1/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSIndexPath (MockupShortcut)

@property (nonatomic, readonly) NSString *code;

- (BOOL) isEqualCode:(NSString *)codeCompare;

@end