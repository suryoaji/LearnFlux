//
//  UITableView.h
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 2/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(ReloadDataAnimate)

- (void) reloadDataWithAnimate:(BOOL)animate;
- (void) reloadDataSection:(long)section animate:(BOOL)animate;
- (void) reloadDataSection:(long)section;
- (void) reloadDataSectionStart:(long)section sectionCount:(long)count animate:(BOOL)animate;

@end;