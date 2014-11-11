//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import <Foundation/Foundation.h>
#import "GCD+Cancellation.h"
#import "RSZNotification.h"

typedef cancelable_block_t(^main_block_t)(BOOL *finished);

@interface RSZNotificationOperation : NSOperation

+ (RSZNotificationOperation *)operationWithNotification:(RSZNotification *)notification mainBlock:(main_block_t)mainBlock;

@end
