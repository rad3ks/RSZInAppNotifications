//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "RSZNotification.h"
#import "RSZNotificationOperation.h"

#import <objc/runtime.h>

extern const char * kNotificationOperationKey;

@interface RSZNotification ()

@property (nonatomic, strong) on_tap_block_t onTapBlock;

- (instancetype)initWithView:(UIView *)view onTapAction:(on_tap_block_t)onTapBlock;
- (void)setOnTapAction:(on_tap_block_t)onTapBlock;
- (void)associatedViewTapped:(UITapGestureRecognizer *)recognizer;
- (void)associatedViewSwiped:(UISwipeGestureRecognizer *)recognizer;

@end

@implementation RSZNotification

+ (instancetype)notificationWithAssociatedView:(UIView *)view onTapBlock:(on_tap_block_t)onTapBlock
{
    return [[self alloc] initWithView:view onTapAction:onTapBlock];
}

- (instancetype)initWithView:(UIView *)view onTapAction:(on_tap_block_t)onTapBlock
{
    self = [super init];
    if (self) {
        _associatedView = view;
        _associatedView.frame = CGRectMake(view.frame.origin.x,
                                           view.frame.origin.y,
                                           CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                           CGRectGetHeight(view.frame));
        [self setOnTapAction:onTapBlock];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(associatedViewTapped:)];
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(associatedViewSwiped:)];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [view addGestureRecognizer:tapRecognizer];
        [view addGestureRecognizer:swipeRecognizer];
    }
    return self;
}

- (void)setOnTapAction:(on_tap_block_t)onTapBlock
{
    if (onTapBlock != nil) {
        typeof(self) weakSelf = self;
        self.onTapBlock = ^(RSZNotification *notification) {
            RSZNotificationOperation *operation = objc_getAssociatedObject(weakSelf, kNotificationOperationKey);
            [operation cancel];
            onTapBlock(notification);
        };
    }
}

- (void)associatedViewTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.onTapBlock != nil) {
        self.onTapBlock(self);
    }
}

- (void)associatedViewSwiped:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        RSZNotificationOperation *operation = objc_getAssociatedObject(self, kNotificationOperationKey);
        [operation cancel];
    }
}

@end
