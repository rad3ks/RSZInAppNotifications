//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "RSZPresenter.h"
#import "RSZNotificationOperation.h"

#import <objc/runtime.h>

CGFloat const kGravityValue = 1.0;
CGFloat const kHideNotificationDelay = 4.5;

void *const kPresentingWindowKey = "_window";
void *const kCollisionBoundsViewKey = "_collisionBoundsView";
void *const kPresenterAnimatorKey = "_animator";
void *const kPresenterNotificationQueueKey = "_notificationQueue";

#pragma mark -
#pragma mark - Interface
@interface RSZPresenter (RSZAccessors)
+ (UIWindow *)window;
+ (UIView *)collisionBoundsView;
+ (UIDynamicAnimator *)animator;
+ (NSOperationQueue *)notificationQueue;

+ (void)setWindow:(UIWindow *)window;
+ (void)setCollisionBoundsView:(UIView *)view;
+ (void)setAnimator:(UIDynamicAnimator *)animator;
+ (void)setNotificationQueue:(NSOperationQueue *)queue;
@end

#pragma mark -
@interface RSZPresenter (RSZNotificationPhysics)
+ (void)resetAnimatorForAssociatedView:(UIView *)associatedView collisionBoundsView:(UIView *)boundsView;
+ (UIGravityBehavior *)gravityBehaviorForView:(UIView *)view;
+ (UICollisionBehavior *)collisionBehaviorForView:(UIView *)view;
+ (UIDynamicItemBehavior *)elasticityBehaviorForView:(UIView *)view;
@end

#pragma mark -
@interface UIView (RSZBoundingView)
+ (UIView *)notificationBoundingViewForInteriorView:(UIView *)interiorView;
@end

#pragma mark -
@interface UIApplication (RSZStatusBar)
+ (void)showStatusBar;
+ (void)hideStatusBar;
@end

#pragma mark -
@interface RSZPresenter ()
+ (cancelable_block_t)submitNotification:(RSZNotification *)notification afterDelay:(NSTimeInterval)delay autoDismissal:(BOOL)autoDismiss finished:(BOOL *)finished;
@end

#pragma mark -
#pragma mark - Implementation
@implementation RSZPresenter

+ (void)setPresentingWindow:(UIWindow *)window
{
    NSAssert(window != nil, @"UIWindow can't be nil");

    NSOperationQueue *notificationQueue = [[NSOperationQueue alloc] init];
    notificationQueue.maxConcurrentOperationCount = 1;

    [self setWindow:window];
    [self setNotificationQueue:notificationQueue];
}

+ (void)presentNotification:(RSZNotification *)notification
{
    RSZNotificationOperation *operation = [RSZNotificationOperation operationWithNotification:notification mainBlock:^(BOOL *finished){
        return [self submitNotification:notification afterDelay:0.0 autoDismissal:YES finished:finished];
    }];
    
    [[self notificationQueue] addOperation:operation];
}

+ (void)presentNotification:(RSZNotification *)notification autoDismissal:(BOOL)autoDismiss
{
    RSZNotificationOperation *operation = [RSZNotificationOperation operationWithNotification:notification mainBlock:^(BOOL *finished){
        return [self submitNotification:notification afterDelay:0.0 autoDismissal:autoDismiss finished:finished];
    }];
    [[self notificationQueue] addOperation:operation];
}

+ (void)presentNotification:(RSZNotification *)notification after:(NSTimeInterval)delay autoDismissal:(BOOL)autoDismiss
{
    RSZNotificationOperation *operation = [RSZNotificationOperation operationWithNotification:notification mainBlock:^(BOOL *finished){
        return [self submitNotification:notification afterDelay:delay autoDismissal:autoDismiss finished:finished];
    }];
    [[self notificationQueue] addOperation:operation];
}

+ (cancelable_block_t)submitNotification:(RSZNotification *)notification
                              afterDelay:(NSTimeInterval)delay
                           autoDismissal:(BOOL)autoDismiss
                                finished:(BOOL *)finished
{
    NSAssert([self window] != nil, @"setPresentingWindow was not called. "
            "You need to pass UIWindow instance to RSZPresenter before presenting notification. "
            "You can do this once in AppDelegate - didFinishLaunchingWithOptions");

    dispatch_queue_t queue = dispatch_get_main_queue();

    return dispatch_after_delay(delay, queue, ^{
        UIView *associatedView = notification.associatedView;
        [self setCollisionBoundsView:[UIView notificationBoundingViewForInteriorView:associatedView]];

        UIView *collisionBoundsView = [self collisionBoundsView];
        [collisionBoundsView addSubview:associatedView];

        notification.isBeingPresented = YES;
        [UIApplication hideStatusBar];

        [[self window] addSubview:collisionBoundsView];
        [self resetAnimatorForAssociatedView:associatedView collisionBoundsView:collisionBoundsView];

        if (autoDismiss) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHideNotificationDelay * NSEC_PER_SEC)), queue, ^{
                [self hideNotification:notification completion:^(BOOL success, BOOL isPresenting) {
                    *finished = (success && !isPresenting);
                }];
            });
        }
    });
}

+ (void)hideNotification:(RSZNotification *)notification
{
    [self hideNotification:notification completion:nil];
}

+ (void)hideNotification:(RSZNotification *)notification completion:(void (^)(BOOL success, BOOL isPresenting))completion
{
    if (notification.isBeingPresented) {
        CGRect frame = notification.associatedView.frame;
        frame.origin.y = -frame.size.height;

        [[self animator] removeAllBehaviors];
        [self setAnimator:nil];

        [UIView animateWithDuration:0.25
                         animations:^{
                             notification.associatedView.frame = frame;
                         }
                         completion:^(BOOL finished) {
                             notification.isBeingPresented = NO;
                             [notification.associatedView removeFromSuperview];
                             [[self collisionBoundsView]removeFromSuperview];
                             [self setCollisionBoundsView:nil];

                             [UIApplication showStatusBar];

                             if (completion) {
                                 completion(finished, NO);
                             }
                         }];
    }
}

@end

#pragma mark -
@implementation UIView (RSZBoundingView)

+ (UIView *)notificationBoundingViewForInteriorView:(UIView *)interiorView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect collFrame = CGRectMake(0, -interiorView.frame.size.height, screenBounds.size.width, 2*interiorView.frame.size.height-0.5);
    return [[UIView alloc] initWithFrame:collFrame];
}

@end

#pragma mark -
@implementation UIApplication (RSZStatusBar)

+ (void)showStatusBar
{
    UIApplication *application = [UIApplication sharedApplication];
    if (application.isStatusBarHidden) {
        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}


+ (void)hideStatusBar
{
    UIApplication *application = [UIApplication sharedApplication];
    if (!application.isStatusBarHidden) {
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

@end

#pragma mark -
@implementation RSZPresenter (RSZNotificationPhysics)

+ (void)resetAnimatorForAssociatedView:(UIView *)associatedView collisionBoundsView:(UIView *)boundsView
{
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:boundsView];
    
    [animator addBehavior:[self gravityBehaviorForView:associatedView]];
    [animator addBehavior:[self collisionBehaviorForView:associatedView]];
    [animator addBehavior:[self elasticityBehaviorForView:associatedView]];

    [self setAnimator:animator];
}

+ (UIGravityBehavior *)gravityBehaviorForView:(UIView *)view
{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[view]];
    gravity.gravityDirection = CGVectorMake(0, kGravityValue);
    return gravity;
}

+ (UICollisionBehavior *)collisionBehaviorForView:(UIView *)view
{
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[view]];
    collision.translatesReferenceBoundsIntoBoundary = TRUE;
    return collision;
}

+ (UIDynamicItemBehavior *)elasticityBehaviorForView:(UIView *)view
{
    UIDynamicItemBehavior *elasticityItem = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    elasticityItem.elasticity = 0.3;
    
    return elasticityItem;
}

@end

#pragma mark -
@implementation RSZPresenter (RSZAccessors)

+ (UIWindow *)window
{
    return objc_getAssociatedObject(self, kPresentingWindowKey);
}

+ (UIView *)collisionBoundsView
{
    return objc_getAssociatedObject(self, kCollisionBoundsViewKey);
}

+ (UIDynamicAnimator *)animator
{
    return objc_getAssociatedObject(self, kPresenterAnimatorKey);
}

+ (NSOperationQueue *)notificationQueue
{
    return objc_getAssociatedObject(self, kPresenterNotificationQueueKey);
}

+ (void)setWindow:(UIWindow *)window
{
    objc_setAssociatedObject(self, kPresentingWindowKey, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setCollisionBoundsView:(UIView *)view
{
    if (![self collisionBoundsView]) {
        objc_setAssociatedObject(self, kCollisionBoundsViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)setAnimator:(UIDynamicAnimator *)animator
{
    objc_setAssociatedObject(self, kPresenterAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)setNotificationQueue:(NSOperationQueue *)queue
{
    objc_setAssociatedObject(self, kPresenterNotificationQueueKey, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end