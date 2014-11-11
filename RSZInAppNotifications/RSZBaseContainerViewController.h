//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import <UIKit/UIKit.h>

typedef void(^on_embed_segue_block_t)(UIViewController *controller);

NSString *const kEmbeddedSegueIdentifier = @"ContainerEmbedSegue";

@interface RSZBaseContainerViewController : UIViewController
@property (nonatomic, strong) on_embed_segue_block_t onEmbedSegue;
@end
