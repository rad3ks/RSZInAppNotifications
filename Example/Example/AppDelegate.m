//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "AppDelegate.h"
#import "RSZPresenter.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RSZPresenter setPresentingWindow:self.window];
    return YES;
}

@end
