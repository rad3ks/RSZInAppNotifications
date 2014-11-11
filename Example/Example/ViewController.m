//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "ViewController.h"

@interface ViewController ()

- (IBAction)showRedNotification:(id)sender;
- (IBAction)showDelayedNotification:(id)sender;
- (IBAction)showNonAutoDismissalNotification:(id)sender;

- (void)showNotificationWithBackgroundColor:(UIColor *)backgroundColor afterDelay:(NSTimeInterval)delay autoDismiss:(BOOL)autoDismissal;

@end

@implementation ViewController

- (void)showRedNotification:(id)sender
{
    [self showNotificationWithBackgroundColor:[UIColor redColor] afterDelay:0.0 autoDismiss:YES];
}

- (void)showDelayedNotification:(id)sender
{
    [self showNotificationWithBackgroundColor:[UIColor blueColor] afterDelay:3.0 autoDismiss:YES];
}

- (void)showNonAutoDismissalNotification:(id)sender
{
    [self showNotificationWithBackgroundColor:[UIColor greenColor] afterDelay:0.0 autoDismiss:NO];
}

- (void)showNotificationWithBackgroundColor:(UIColor *)backgroundColor afterDelay:(NSTimeInterval)delay autoDismiss:(BOOL)autoDismissal
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    view.backgroundColor = backgroundColor;
    
    RSZNotification *notification = [RSZNotification notificationWithAssociatedView:view onTapBlock:^(RSZNotification *notification) {
        NSLog(@"Notification tapped");
    }];
    
    [RSZPresenter presentNotification:notification after:delay autoDismissal:autoDismissal];
}

@end
