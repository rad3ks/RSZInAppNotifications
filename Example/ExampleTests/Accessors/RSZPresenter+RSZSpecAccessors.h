//
// Created by Radoslaw Szeja on 10.11.14.
//

#import <Foundation/Foundation.h>
#import "RSZPresenter.h"

@interface RSZPresenter (RSZSpecAccessors)
+ (UIWindow *)window;
+ (UIView *)collisionBoundsView;
+ (UIDynamicAnimator *)animator;
+ (NSOperationQueue *)notificationQueue;
@end