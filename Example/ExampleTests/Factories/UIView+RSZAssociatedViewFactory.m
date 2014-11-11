//
// Created by Radoslaw Szeja on 11.11.14.
//

#import "UIView+RSZAssociatedViewFactory.h"


@implementation UIView (RSZAssociatedViewFactory)

+ (UIView *)associatedView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat viewWidth = CGRectGetWidth(screenBounds);
    CGFloat viewHeight = CGRectGetHeight(screenBounds);

    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
}

@end