//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "RSZBaseContainerViewController.h"

@interface RSZBaseContainerViewController ()
@property (nonatomic, weak) IBOutlet UIView *contentSubview;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@end

@implementation RSZBaseContainerViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.topSpaceConstraint.constant = (UIApplication.sharedApplication.isStatusBarHidden) ? 20 : 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEmbeddedSegueIdentifier]) {
        if (self.onEmbedSegue != nil) {
            self.onEmbedSegue(segue.destinationViewController);
        }
    }
}

@end
