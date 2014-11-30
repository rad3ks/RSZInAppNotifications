//  Copyright (c) 2014 Radosław Szeja. All rights reserved.

#import "RSZBaseContainerViewController.h"

@interface RSZBaseContainerViewController ()
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topLayoutSpace;
@property (nonatomic, strong) UIViewController *rootViewController;
@end

@implementation RSZBaseContainerViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.topLayoutSpace == nil) {
        self.containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.containerView.clipsToBounds = YES;

        [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:self.containerView];

        self.topLayoutSpace = [NSLayoutConstraint constraintWithItem:self.containerView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.topLayoutGuide
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:20.0];
        [self.view addConstraint:self.topLayoutSpace];

        NSDictionary *views = @{@"containerView": self.containerView};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[containerView]|"
                                                                          options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                                                                          metrics:nil
                                                                            views:views]];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.bottomLayoutGuide
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:0.0]];
    }

    [self addRootViewController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.topLayoutSpace.constant = 20.0f - self.topLayoutGuide.length;
}

- (void)setContainerView:(UIView *)containerView
{
    _containerView = containerView;
    [self addRootViewController];
}

- (void)addRootViewController
{
    if (self.rootViewController && ![self.rootViewController.parentViewController isEqual:self]) {
        if (self.containerView == nil) {
            self.containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }

        [self addChildViewController:self.rootViewController];
        [self.containerView addSubview:self.rootViewController.view];
        [self.rootViewController didMoveToParentViewController:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ContainerEmbedsSegue"]) {
        self.rootViewController = segue.destinationViewController;
        [self.rootViewController.view setNeedsLayout];

        if (self.onEmbeddedSegue != nil) {
            self.onEmbeddedSegue(self.rootViewController);
        }
    }
}


@end
