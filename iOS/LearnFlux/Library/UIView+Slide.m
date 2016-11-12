
#import "UIView+Slide.h"

@implementation UIView (Slide)

- (void)slideWithDirection:(DirectionTypes)directionTypes duration:(float)duration completed:(completionBlockBOOL)compblock {
    CGRect src = [self frame];
    CGRect dst = [self frame];
    CGRect bnd = [[UIScreen mainScreen] bounds];
    switch (directionTypes) {
        case DIR_ENTER_FROM_DOWN:   src.origin.x = 0;               src.origin.y = bnd.size.height;     dst.origin.x = 0; dst.origin.y = 0; break;
        case DIR_ENTER_FROM_LEFT:   src.origin.x = -src.size.width; src.origin.y = 0;                   dst.origin.x = 0; dst.origin.y = 0; break;
        case DIR_ENTER_FROM_RIGHT:  src.origin.x = bnd.size.width;  src.origin.y = 0;                   dst.origin.x = 0; dst.origin.y = 0; break;
        case DIR_ENTER_FROM_UP:     src.origin.x = 0;               src.origin.y = -src.size.height;    dst.origin.x = 0; dst.origin.y = 0; break;
        case DIR_EXIT_TO_DOWN:      dst.origin.x = 0;               dst.origin.y = bnd.size.height;     src.origin.x = 0; src.origin.y = 0; break;
        case DIR_EXIT_TO_LEFT:      dst.origin.x = -src.size.width; dst.origin.y = 0;                   src.origin.x = 0; src.origin.y = 0; break;
        case DIR_EXIT_TO_RIGHT:     dst.origin.x = bnd.size.width;  dst.origin.y = 0;                   src.origin.x = 0; src.origin.y = 0; break;
        case DIR_EXIT_TO_UP:        dst.origin.x = 0;               dst.origin.y = -src.size.height;    src.origin.x = 0; src.origin.y = 0; break;
            
    }
    
    [self setFrame:src];
    
    [UIView animateWithDuration:duration animations:^{
        [self setFrame:dst];
    } completion:^(BOOL finished) {
        compblock(finished);
    }];
}


- (void)slideIn {
    [self slideWithDirection:DIR_ENTER_FROM_LEFT duration:0.4 completed:nil];
}

- (void)slideOut {
    [self slideWithDirection:DIR_EXIT_TO_LEFT duration:0.4 completed:nil];
}


@end