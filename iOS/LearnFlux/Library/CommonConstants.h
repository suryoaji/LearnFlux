//
//  CommonConstants.h
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/19/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTypes.h"

@interface Global : NSObject

+ (float) fontSizeTitle;
+ (float) fontSizeSectionTitle;
+ (float) fontSizeLabel;
+ (float) fontSizeTextField;
+ (float) fontSizeButton;
+ (float) heightButton;
+ (float) heightCellListDouble;
+ (float) heightCellListSingle;
+ (float) heightCellListProperty;

+ (float) spacingText;
+ (float) paddingH;
+ (float) paddingV;
+ (float) paddingCellH;
+ (float) paddingCellV;
+ (float) paddingExtra;

+ (UIColor *) colorViewBackground;
+ (UIColor *) colorLabelText;
+ (UIColor *) colorLabelBackground;
+ (UIColor *) colorTextFieldText;
+ (UIColor *) colorTextFieldBackground;
+ (UIColor *) colorButtonBackground;

+ (UIButton *) instantCustomButton;
+ (UIColor *) colorButtonFaceNormal;
+ (UIColor *) colorButtonFaceHighlight;
+ (UIColor *) colorButtonFaceDisabled;

+ (UIEdgeInsets) insetTextField;

+ (NSString *) baseURL;
+ (NSString *) ppbaseURL;
+ (NSString *) tokenAccess;

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

#define OWNER_SB @"Owner"
#define TENANT_SB @"Tenant"
#define AGENT_SB @"Agent"
#define MAIN_SB @"Main"