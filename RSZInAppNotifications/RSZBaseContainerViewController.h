//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^on_embedded_segue_block_t)(UIViewController *controller);

@interface RSZBaseContainerViewController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@property (nonatomic, strong) on_embedded_segue_block_t onEmbeddedSegue;

@end
