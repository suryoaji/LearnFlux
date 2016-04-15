
#import <UIKit/UIKit.h>
#import "CommonTypes.h"

@interface UIView (Slide)

- (void)slideWithDirection:(DirectionTypes)directionTypes duration:(float)duration completed:(completionBlockBOOL)compblock;
- (void)slideIn;
- (void)slideOut;
@end