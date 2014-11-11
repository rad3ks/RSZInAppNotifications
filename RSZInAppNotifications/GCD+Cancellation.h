//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import <Foundation/Foundation.h>

typedef void(^cancelable_block_t)(BOOL cancel);

static cancelable_block_t dispatch_after_delay(NSTimeInterval delay, dispatch_queue_t queue, dispatch_block_t block) {
	if (block == nil) {
		return nil;
    }
    
	__block cancelable_block_t cancelableBlock = nil;
	__block dispatch_block_t originalBlock = [block copy];
    
    cancelable_block_t delayBlock = ^(BOOL cancel) {
        if (cancel == NO && originalBlock) {
            dispatch_async(queue, originalBlock);
        }

        originalBlock = nil;
        cancelableBlock = nil;
    };
    
    cancelableBlock = [delayBlock copy];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), queue, ^{
        if (cancelableBlock) {
            cancelableBlock(NO);
        }
    });
    
    return cancelableBlock;
}

static void cancel_block(cancelable_block_t block) {
	if (block == nil)
        return;
    
	block(YES);
}