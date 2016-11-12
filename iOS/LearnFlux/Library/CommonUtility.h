//
//  CommonUtility.h
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/22/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
//#import "CommonTypes.h"
#import "CommonConstants.h"
#import "OSTextField.h"

@interface Util : NSObject

+ (UILabel *)copyLabelFrom:(UILabel *) label withText:(NSString *)text tag:(int)tag;
+ (UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text textColor:(UIColor *)textColor tag:(int)tag;
+ (UIButton *)createButtonWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text backgroundColor:(UIColor *)backgroundColor tag:(int)tag;
+ (UIButton *)createButtonWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text tag:(int)tag;
+ (OSTextField *)copyTextFieldFrom:(OSTextField *) textField withText:(NSString *)text placeholder:(NSString *)placeholder tag:(int)tag;
+ (OSTextField *)createTextFieldWithFrame:(CGRect)frame inset:(UIEdgeInsets)inset fontSize:(int)size weight:(float)weight text:(NSString *)text placeholder:(NSString *)placeholder textColor:(UIColor *)textColor border:(UITextBorderStyle)borderStyle returnKeyType:(UIReturnKeyType)returnKeyType tag:(int)tag;


+ (void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonOKTitle:(NSString *)buttonOKTitle completion:(completionBlock)completion;
+ (void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonOKTitle:(NSString *)buttonOKTitle nextFirstResponder:(NSObject *)nextFirstResponder;

+ (void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message completion:(completionBlock)completion;
+ (void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message nextFirstResponder:(NSObject *)nextFirstResponder;

+ (void) showConfirmationInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonYESTitle:(NSString *)buttonYESTitle buttonNOTitle:(NSString*)buttonNOTitle chooseYES:(completionBlock)chooseYES chooseNO:(completionBlock)chooseNO;


+ (void) showIndicatorAtView:(UIView *)view withNetworkActivityIndicator:(BOOL)withNetworkActivityIndicator;
+ (void) showIndicatorAtView:(UIView *)view;
+ (void) stopIndicatorAtView:(UIView *)view;

+ (NSDateComponents *) stringToDateComponents:(NSString *)dateStr withFormat:(NSString *)dateFormat;
+ (NSDateComponents *) stringToDateComponents:(NSString *)dateStr;
+ (NSString *) monthName:(NSInteger)monthIndex;

+ (float)scaledHeightFromWidth:(float)oldWidth height:(float)oldHeight targetWidth:(float)newWidth;
+ (float)textHeightFromWidth:(float)swidth text:(NSString *)text size:(NSUInteger)textSize;
+ (NSUInteger) countRowsFromString:(NSString *) string;

+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction;
+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID;
+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID page:(long)page;
+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID requesterID:(NSInteger)requesterID;
+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction pictureFilename:(NSString *)pictureFilename;


+ (BOOL) isNull:(id)object;

+ (NSString *) getSafeString: (NSString *)nullableString;
+ (NSString *) getSafeString: (NSString *)nullableString withFallbackString:(NSString *)fallbackString;

+ (UITableViewCell *) emptyCellWithBackgroundColor:(UIColor*)backgroundColor;
//+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:()eventSFID:(NSString *)eventSFID;

+ (void) globalResignFirstResponderRec:(UIView*) view;

+ (UIViewController*) getViewControllerID:(NSString *)vcname;
+ (UIViewController*) getViewControllerID:(NSString *)vcname fromStoryboard:(NSString *)storyboardName;

+ (void) phoneCall:(NSString *)number;

+ (void) delay: (double) delay closure:(completionBlock)closure;


@end