//
//  CommonUtility.m
//  EMAN
//
//  Created by Martin Darma Kusuma Tjandra on 1/22/16.
//  Copyright © 2016 Danny Raharja. All rights reserved.
//

#import "CommonUtility.h"

@implementation Util


+(void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonOKTitle:(NSString *)buttonOKTitle completion:(completionBlock)completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:buttonOKTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (completion != nil) completion();
                                                     }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message completion:(completionBlock)completion {
    [self showMessageInViewController:viewController title:title message:message buttonOKTitle:@"Ok" completion:completion];
}

+(void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonOKTitle:(NSString *)buttonOKTitle nextFirstResponder:(NSObject *)nextFirstResponder {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:buttonOKTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         if (nextFirstResponder != nil && [nextFirstResponder isKindOfClass:[UITextField class]]) {
                                                             UITextField *t = (UITextField *)nextFirstResponder;
                                                             [t becomeFirstResponder];
                                                         }
                                                     }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


+(void) showMessageInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message nextFirstResponder:(NSObject *)nextFirstResponder{
    [self showMessageInViewController:viewController title:title message:message buttonOKTitle:@"Ok" nextFirstResponder:nextFirstResponder];
}


+ (void) showConfirmationInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message buttonYESTitle:(NSString *)buttonYESTitle buttonNOTitle:(NSString*)buttonNOTitle chooseYES:(completionBlock)chooseYES chooseNO:(completionBlock)chooseNO {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:buttonYESTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (chooseYES != nil) chooseYES();
                                                     }];
    [alertController addAction:actionYES];

    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:buttonNOTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (chooseNO != nil) chooseNO();
                                                     }];
    [alertController addAction:actionNO];

    [viewController presentViewController:alertController animated:YES completion:nil];
}


+ (void)showIndicatorAtView:(UIView *)view withNetworkActivityIndicator:(BOOL)withNetworkActivityIndicator {
    UIActivityIndicatorView *indicator;
    if ([view viewWithTag:15372] != nil)
        indicator = [view viewWithTag:15372];
    else
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = view.center;
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UITextField class]]) {
        indicator.center = CGPointMake(view.bounds.size.width - (view.bounds.size.height / 2), view.bounds.size.height / 2);
    }
    
    [indicator bringSubviewToFront:view];
    [indicator setTag:15372];
    [indicator startAnimating];
    [view addSubview:indicator];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = withNetworkActivityIndicator;
}

+ (void)showIndicatorAtView:(UIView *)view {
    [Util showIndicatorAtView:view withNetworkActivityIndicator:YES];
}


+ (void)stopIndicatorAtView:(UIView *)view {
    UIActivityIndicatorView *indicator = [view viewWithTag:15372];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [indicator stopAnimating];
    [indicator removeFromSuperview];
}

+(UILabel *)copyLabelFrom:(UILabel *) label withText:(NSString *)text tag:(int)tag {
    UILabel *result = [[UILabel alloc] initWithFrame:[label frame]];
    [result setBackgroundColor:[label backgroundColor]];
    [result setNumberOfLines:[label numberOfLines]];
    [result setFont:[label font]];
    [result setTextAlignment:[label textAlignment]];
    [result setTag:[label tag]];
    [result setAdjustsFontSizeToFitWidth:[label adjustsFontSizeToFitWidth]];
    [result setTextColor:[label textColor]];
    [result setText:text];
    [result setTag:tag];
    return result;
}


+(UILabel *)createLabelWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text textColor:(UIColor *)textColor tag:(int)tag
{
    UILabel *result = [[UILabel alloc] initWithFrame:frame];
    [result setBackgroundColor:[UIColor clearColor]];
    [result setNumberOfLines:0];
    [result setFont:[UIFont systemFontOfSize:size weight:weight]];
    [result setTextAlignment:NSTextAlignmentLeft];
    [result setTag:tag];
    [result setAdjustsFontSizeToFitWidth:NO];
    [result setTextColor:textColor];
    [result setText:text];
    return result;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text backgroundColor:(UIColor *)backgroundColor tag:(int)tag {
//    UIButton *result = [[UIButton alloc] initWithFrame:frame];
    UIButton *result = [UIButton buttonWithType:UIButtonTypeSystem];
    [result setFrame:frame];
    [result setTitle:text forState:UIControlStateNormal];
    [[result titleLabel] setFont:[UIFont systemFontOfSize:size weight:weight]];
//    [result setTitleColor:[Global colorButtonFaceNormal] forState:UIControlStateNormal];
//    [result setTitleColor:[Global colorButtonFaceHighlight] forState:UIControlStateHighlighted];
//    [result setTitleColor:[Global colorButtonFaceDisabled] forState:UIControlStateDisabled];
    [result setBackgroundColor:backgroundColor];
    [result setTag:tag];
    return result;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame fontSize:(int)size weight:(float)weight text:(NSString *)text  tag:(int)tag {
    return [self createButtonWithFrame:frame fontSize:size weight:weight text:text backgroundColor:[UIColor clearColor] tag:tag];
}



+(NSDateComponents *) stringToDateComponents:(NSString *)dateStr withFormat:(NSString *)dateTimeFormat
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:dateTimeFormat];//@"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormat dateFromString:dateStr];
    // Convert date object to date component object
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return components;
}

+(NSDateComponents *) stringToDateComponents:(NSString *)dateStr {
    return [self stringToDateComponents:dateStr withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *) monthName:(NSInteger)monthIndex {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:monthIndex];
    return monthName;
}

+(float)scaledHeightFromWidth:(float)oldWidth height:(float)oldHeight targetWidth:(float)newWidth
{
    if (oldWidth == 0) return 155;
    float scaleFactor = newWidth / oldWidth;
    float newHeight = oldHeight * scaleFactor;
    return newHeight;
}

+(float)textHeightFromWidth:(float)swidth text:(NSString *)text size:(NSUInteger)textSize
{
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, swidth, 150)];
    [desc setFont:[UIFont systemFontOfSize:textSize]];
    [desc setNumberOfLines:0];
    [desc setText:text];
    [desc sizeToFit];
    return desc.bounds.size.height;
}

+(NSUInteger)countRowsFromString:(NSString *)string {
    if (string == nil) return 0;
    
    NSUInteger numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    return numberOfLines;
}


+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction {
    switch (requestAction) {
        case ACTION_POST_USER_REGISTRATION:
            return [NSString stringWithFormat:@"%@/%@/user/reg", [Global baseURL], [Global tokenAccess]];
        case ACTION_POST_USER_LOGIN:
            return [NSString stringWithFormat:@"%@/%@/user/login", [Global baseURL], [Global tokenAccess]];
        default:
            break;
    }
    return @"";
}

+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID page:(long)page {
    switch (requestAction) {
        default:
            break;
    }
    return @"";

}


+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID {
    switch (requestAction) {
        case ACTION_GET_USER_DETAIL:
            return [NSString stringWithFormat:@"%@/%@/user/%ld", [Global baseURL], [Global tokenAccess], (long) userID];
            break;
        default:
            break;
    }
    return [self URLRequestForAction:requestAction userID:userID page:0];
}

+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction userID:(NSInteger)userID requesterID:(NSInteger)requesterID {
    switch (requestAction) {
        default:
            break;
    }
    return @"";
}

+ (NSString *) URLRequestForAction:(URLRequestAction)requestAction pictureFilename:(NSString *)pictureFilename {
    if (pictureFilename == nil) return @"";
    NSString *thumb = @"";
    if (requestAction == ACTION_GET_PROFILEPICTURE_THUMB && ![pictureFilename isEqualToString:@"default.jpg"]) thumb = @"thumb_";
    return [NSString stringWithFormat:@"%@/%@%@", [Global ppbaseURL], thumb, pictureFilename];
}

+ (BOOL) isNull:(id)object {
    if (object == nil || object == NULL || object == [NSNull null]) return YES; else return NO;
}


+(NSString *) getSafeString: (NSString *)nullableString {
    if ([self isNull:nullableString]) {
        return @"";
    }
    else {
        return nullableString;
    }
}

+(NSString *) getSafeString: (NSString *)nullableString withFallbackString:(NSString *)fallbackString {
    if ([self isNull:nullableString] || [nullableString isEqualToString:@""]) {
        return fallbackString;
    }
    else {
        return nullableString;
    }
}

+ (UITableViewCell *) emptyCellWithBackgroundColor:(UIColor*)backgroundColor {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setBackgroundColor:backgroundColor];
    return cell;
}


+ (void) globalResignFirstResponderRec:(UIView*) view {
    if ([view respondsToSelector:@selector(resignFirstResponder)]){
        [view resignFirstResponder];
    }
    for (UIView * subview in [view subviews]){
        [self globalResignFirstResponderRec:subview];
    }
}

+(OSTextField *)copyTextFieldFrom:(OSTextField *) textField withText:(NSString *)text placeholder:(NSString *)placeholder tag:(int)tag{
    OSTextField *result = [[OSTextField alloc] initWithFrame:[textField frame]];
    [result setBackgroundColor:[textField backgroundColor]];
    [result setBorderStyle:[textField borderStyle]];
    [result setFont:[textField font]];
    [result setTextAlignment:[textField textAlignment]];
    [result setAdjustsFontSizeToFitWidth:[textField adjustsFontSizeToFitWidth]];
    [result setTextColor:[textField textColor]];
    [result setTag:tag];
    result.returnKeyType = textField.returnKeyType;
    result.edgeInsets = textField.edgeInsets;
    if (text != nil)
        [result setText:text];
    if (placeholder != nil)
        [result setPlaceholder:placeholder];
    return result;
}

+(OSTextField *)createTextFieldWithFrame:(CGRect)frame inset:(UIEdgeInsets)inset fontSize:(int)size weight:(float)weight text:(NSString *)text placeholder:(NSString *)placeholder textColor:(UIColor *)textColor border:(UITextBorderStyle)borderStyle returnKeyType:(UIReturnKeyType)returnKeyType tag:(int)tag
{
    OSTextField *result = [[OSTextField alloc] initWithFrame:frame];
    [result setBackgroundColor:[UIColor clearColor]];
    [result setBorderStyle:borderStyle];
    [result setFont:[UIFont systemFontOfSize:size weight:weight]];
    [result setTextAlignment:NSTextAlignmentLeft];
    [result setTag:tag];
    [result setAdjustsFontSizeToFitWidth:NO];
    [result setTextColor:textColor];
    [result setText:text];
    [result setPlaceholder:placeholder];
    result.returnKeyType = returnKeyType;
    return result;
}


+ (UIViewController*) getViewControllerID:(NSString *)vcname {
    return [self getViewControllerID:vcname fromStoryboard:@"Main"];
}

+ (UIViewController*) getViewControllerID:(NSString *)vcname fromStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:vcname];
}

//+ (AppDelegate *) aDelegate {
//    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
//}

+ (void) phoneCall:(NSString *)number {

    NSString *cleanedString = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
//    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", cleanedString];
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", cleanedString];

    
//    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    NSLog (@"%@", phoneURLString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURLString]];
}

+ (void) delay:(double)delay closure:(completionBlock)closure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        closure();
    });
}

@end