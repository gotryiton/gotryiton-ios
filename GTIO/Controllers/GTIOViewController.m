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
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation GTIOViewController

@synthesize navigationTitle = _navigationTitle, leftButton = _leftButton, rightButton = _rightButton, topShadow = _topShadow, italic = _italic, titleLabel = _titleLabel;

-(id)initWithTitle:(NSString *)title italic:(BOOL)italic leftNavBarButton:(UIButton *)leftButton rightNavBarButton:(UIButton *)rightButton
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _navigationTitle = title;
        _rightButton = rightButton;
        _leftButton = leftButton;
        _italic = italic;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    if (self.italic) {
        [_titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:18.0]];
    } else {
        [_titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLight size:18.0]];
    }
    [_titleLabel setText:self.navigationTitle];
    [_titleLabel setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
    [_titleLabel sizeToFit];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    // need to shift the label down a bit because of the design
    UIView *titleView = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height + 9 }];
    [_titleLabel setFrame:(CGRect){ 0, 9, _titleLabel.bounds.size }];
    [titleView addSubview:_titleLabel];
    [self.navigationItem setTitleView:titleView];
    
    self.topShadow = [[UIView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, 3 }];
    [self.topShadow setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top-shadow.png"]]];
    [self.view addSubview:self.topShadow];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.leftButton]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
}

- (void)useTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)useTitleView:(UIView *)titleView
{
    [self.navigationItem setTitleView:titleView];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
