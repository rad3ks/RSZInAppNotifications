//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "RSZNotificationOperation.h"
#import "RSZNotification.h"
#import "RSZPresenter.h"

#import <objc/runtime.h>

const char * kNotificationOperationKey = "notificationOperation";

@interface RSZNotificationOperation ()
@property (nonatomic, strong) RSZNotification *notification;
@property (nonatomic, strong) main_block_t mainBlock;
@property (nonatomic, strong) cancelable_block_t cancelableBlock;
@end

@implementation RSZNotificationOperation
@synthesize finished = _finished;

+ (instancetype)operationWithNotification:(RSZNotification *)notification mainBlock:(main_block_t)mainBlock
{
    NSAssert(notification != nil, @"InternatNotification can't be nil");
    NSAssert(mainBlock != nil, @"mainBlock can't be nil");
    return [[self alloc] initWithNotification:notification mainBlock:mainBlock];
}

- (instancetype)initWithNotification:(RSZNotification *)notification mainBlock:(main_block_t)mainBlock
{
    self = [super init];
    if (self) {
        self.notification = notification;
        self.mainBlock = mainBlock;
        objc_setAssociatedObject(self.notification, kNotificationOperationKey, self, OBJC_ASSOCIATION_ASSIGN);
    }
    return self;
}

- (void)main
{
    _finished = NO;
    self.cancelableBlock = self.mainBlock(&_finished);
    while (!_finished) {}
}

- (void)cancel
{
    if (self.cancelableBlock != nil) {
        cancel_block(self.cancelableBlock);
    }
    
    [RSZPresenter hideNotification:self.notification completion:^(BOOL success, BOOL isPresenting) {
        _finished = YES;
    }];
}

@end
