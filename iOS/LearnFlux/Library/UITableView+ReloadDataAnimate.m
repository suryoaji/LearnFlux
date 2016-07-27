//
//  UITableView+ReloadDataAnimate.m
//  n2nLeasing
//
//  Created by Martin Darma Kusuma Tjandra on 2/19/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

#import "UITableView+ReloadDataAnimate.h"

@implementation UITableView (ReloadDataAnimate)

- (void) reloadDataWithAnimate:(BOOL)animate {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSections])];
    if (animate)
        [self reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        [self reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}

- (void) reloadDataSection:(long)section animate:(BOOL)animate{
    [self reloadDataSectionStart:section sectionCount:1 animate:animate];
}

- (void) reloadDataSection:(long)section{
    [self reloadDataSection:section animate:YES];
}

- (void) reloadDataSectionStart:(long)section sectionCount:(long)count animate:(BOOL)animate {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(section, count)];
    if (animate)
        [self reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        [self reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}


@end
