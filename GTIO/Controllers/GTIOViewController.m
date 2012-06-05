//
//  GTIOViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

@interface GTIOViewController ()

@property (nonatomic, copy) NSString *navigationTitle;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *topShadow;

@end

@implementation GTIOViewController

@synthesize navigationTitle = _navigationTitle, leftButton = _leftButton, rightButton = _rightButton, topShadow = _topShadow;

-(id)initWithTitle:(NSString *)title leftNavBarButton:(UIButton *)leftButton rightNavBarButton:(UIButton *)rightButton
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _navigationTitle = title;
        _rightButton = rightButton;
        _leftButton = leftButton;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:18.0]];
    [titleLabel setText:self.navigationTitle];
    [titleLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
    [titleLabel sizeToFit];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    // need to shift the label down a bit because of the design
    UIView *titleView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, titleLabel.bounds.size.width, titleLabel.bounds.size.height + 9 }];
    [titleLabel setFrame:(CGRect){ 0, 9, titleLabel.bounds.size }];
    [titleView addSubview:titleLabel];
    [self.navigationItem setTitleView:titleView];
    
    self.topShadow = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 3 }];
    [self.topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:self.topShadow];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.leftButton]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.topShadow];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
