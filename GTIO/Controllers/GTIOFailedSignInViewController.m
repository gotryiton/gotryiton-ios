//
//  GTIOFailedSignInViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOFailedSignInViewController.h"

@interface GTIOFailedSignInViewController ()

@property (nonatomic, strong) GTIOButton *tryAgainButton;
@property (nonatomic, strong) GTIOButton *createUserButton;
@property (nonatomic, strong) GTIOButton *emailSupportButton;

@end

@implementation GTIOFailedSignInViewController

@synthesize tryAgainButton = _tryAgainButton, createUserButton = _newUserButton, emailSupportButton = _emailSupportButton;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-fail-bg.png"]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -64)];
    [self.view addSubview:backgroundImageView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"login-nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    GTIOButton *backButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeBack tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    
    self.tryAgainButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeTryAgain];
    [self.tryAgainButton setFrame:(CGRect){ {(self.view.frame.size.width - self.tryAgainButton.frame.size.width) / 2, 144 }, self.tryAgainButton.frame.size }];
    [self.tryAgainButton setTapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.tryAgainButton];
    
    self.createUserButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeNewUser];
    [self.createUserButton setFrame:(CGRect){ {(self.view.frame.size.width - self.createUserButton.frame.size.width) / 2, self.tryAgainButton.frame.origin.y + self.tryAgainButton.frame.size.height }, self.createUserButton.frame.size }];
    [self.createUserButton setTapHandler:^(id sender) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.createUserButton];
    
    self.emailSupportButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeEmailSupport];
    [self.emailSupportButton setFrame:(CGRect){ {(self.view.frame.size.width - self.emailSupportButton.frame.size.width) / 2, self.createUserButton.frame.origin.y + self.createUserButton.frame.size.height }, self.emailSupportButton.frame.size }];
    [self.view addSubview:self.emailSupportButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tryAgainButton = nil;
    self.createUserButton = nil;
    self.emailSupportButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
