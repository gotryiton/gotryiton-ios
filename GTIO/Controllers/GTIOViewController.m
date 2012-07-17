//
//  GTIOViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

@interface GTIOViewController ()

@property (nonatomic, strong) UIView *topShadow;
@property (nonatomic, strong) UIImageView *statusBarBackgroundImageView;

@end

@implementation GTIOViewController

@synthesize topShadow = _topShadow;
@synthesize statusBarBackgroundImageView = _statusBarBackgroundImageView;
@synthesize leftNavigationButton = _leftNavigationButton, rightNavigationButton = _rightNavigationButton;


- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    self.topShadow = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 3 }];
    [self.topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:self.topShadow];
    
    _statusBarBackgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){ { 0, - (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height) }, { self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height } }];
    [_statusBarBackgroundImageView setImage:[UIImage imageNamed:@"status-bar-bg.png"]];
    [self.view addSubview:_statusBarBackgroundImageView];
}

- (void)viewDidUnload
{
    self.topShadow = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"green-pattern-nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.topShadow];
    
    if (self.navigationController.navigationBarHidden) {
        [_statusBarBackgroundImageView setFrame:(CGRect){ { 0, -[UIApplication sharedApplication].statusBarFrame.size.height }, { self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height } }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helpers

- (void)useTitleView:(UIView *)titleView
{
    [self.navigationItem setTitleView:titleView];
}

- (void)setLeftNavigationButton:(UIButton *)leftNavigationButton
{
    _leftNavigationButton = leftNavigationButton;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_leftNavigationButton]];
}

- (void)setRightNavigationButton:(UIButton *)rightNavigationButton
{
    _rightNavigationButton = rightNavigationButton;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNavigationButton]];
}

@end
