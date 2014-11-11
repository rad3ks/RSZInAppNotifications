//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RSZNotification;

@interface RSZPresenter : NSObject

+ (void)setPresentingWindow:(UIWindow *)window;

+ (void)presentNotification:(RSZNotification *)notification;
+ (void)presentNotification:(RSZNotification *)notification autoDismissal:(BOOL)autoDismiss;
+ (void)presentNotification:(RSZNotification *)notification after:(NSTimeInterval)delay autoDismissal:(BOOL)autoDismiss;

+ (void)hideNotification:(RSZNotification *)notification;
+ (void)hideNotification:(RSZNotification *)notification completion:(void (^)(BOOL success, BOOL isPresenting))completion;

@end