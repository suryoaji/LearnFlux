//
//  CommonConstants.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/22/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//


#import "CommonConstants.h"

@implementation Global

+ (float) fontSizeTitle { return 20; }
+ (float) fontSizeSectionTitle { return 14; }
+ (float) fontSizeLabel { return 15; }
+ (float) fontSizeTextField { return 15; }
+ (float) fontSizeButton { return 17; }
+ (float) heightButton { return 45; }
+ (float) heightCellListDouble { return 50; }
+ (float) heightCellListSingle { return 100; }
+ (float) heightCellListProperty { return 150; }

+ (float) spacingText { return 10; }
+ (float) paddingH { return 20; }
+ (float) paddingV { return 20; }
+ (float) paddingCellH { return 5; }
+ (float) paddingCellV { return 5; }
+ (float) paddingExtra { return 60; }

+ (UIColor *) colorViewBackground { return UIColorFromRGB(0xefefef); }
+ (UIColor *) colorLabelText { return [UIColor blackColor]; }
+ (UIColor *) colorLabelBackground { return [UIColor clearColor]; }
+ (UIColor *) colorTextFieldText; { return [UIColor blackColor]; }
+ (UIColor *) colorTextFieldBackground { return [UIColor whiteColor]; }
+ (UIColor *) colorButtonBackground { return UIColorFromRGB(0xdedede); }

+ (UIButton *) instantCustomButton { return [UIButton buttonWithType:UIButtonTypeCustom]; }
+ (UIColor *) colorButtonFaceNormal { return [[self instantCustomButton] titleColorForState:UIControlStateNormal]; }
+ (UIColor *) colorButtonFaceHighlight { return [[self instantCustomButton] titleColorForState:UIControlStateHighlighted]; }
+ (UIColor *) colorButtonFaceDisabled; { return [[self instantCustomButton] titleColorForState:UIControlStateDisabled]; }

+ (UIEdgeInsets) insetTextField { return UIEdgeInsetsMake(10, 10, 10, 10); }

+ (NSString *) baseURL { return @"http://kodedewe.com/n2nleasing/public/api"; }
+ (NSString *) ppbaseURL { return @"https://s3-ap-southeast-1.amazonaws.com/isaeventapp/member_files"; }
+ (NSString *) tokenAccess { return @"n2n"; }

@end