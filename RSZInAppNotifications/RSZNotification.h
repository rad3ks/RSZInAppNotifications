//  Copyright (c) 2014 Radosław Szeja. All rights reserved./

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RSZNotification;

typedef void(^on_tap_block_t)(RSZNotification *notification);


@interface RSZNotification : NSObject

@property (nonatomic, readonly) UIView *associatedView;
@property (nonatomic) BOOL isBeingPresented;

+ (instancetype)notificationWithAssociatedView:(UIView *)view onTapBlock:(on_tap_block_t)onTapBlock;

@end