//
//  GTIOReturningUsersViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOReturningUsersViewController.h"

@interface GTIOReturningUsersViewController ()

@property (nonatomic, strong) GTIOButton *facebookButton;
@property (nonatomic, strong) GTIOButton *aolButton;
@property (nonatomic, strong) GTIOButton *googleButton;
@property (nonatomic, strong) GTIOButton *twitterButton;
@property (nonatomic, strong) GTIOButton *yahooButton;

@end

@implementation GTIOReturningUsersViewController

@synthesize facebookButton = _facebookButton, aolButton = _aolButton, googleButton = _googleButton, twitterButton = _twitterButton, yahooButton = _yahooButton;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-return-bg.png"]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -64)];
    [self.view addSubview:backgroundImageView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"login-nav.png"] forBarMetrics:UIBarMetricsDefault];

    self.facebookButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFacebookSignInButton];
    [self.facebookButton setFrame:(CGRect){ {(self.view.frame.size.width - self.facebookButton.frame.size.width) / 2, 80 }, self.facebookButton.frame.size }];
    [self.facebookButton setTapHandler:^(id sender) {
        NSLog(@"Facebook button touched");
    }];
    [self.view addSubview:self.facebookButton];
    
    self.aolButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeAOLButton];
    [self.aolButton setFrame:(CGRect){ {(self.view.frame.size.width - self.aolButton.frame.size.width) / 2, 145 }, self.aolButton.frame.size }];
    [self.view addSubview:self.aolButton];
    
    self.googleButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeGoogleButton];
    [self.googleButton setFrame:(CGRect){ {(self.view.frame.size.width - self.googleButton.frame.size.width) / 2, self.aolButton.frame.origin.y + self.aolButton.frame.size.height }, self.googleButton.frame.size }];
    [self.view addSubview:self.googleButton];
    
    self.twitterButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeTwitterButton];
    [self.twitterButton setFrame:(CGRect){ {(self.view.frame.size.width - self.twitterButton.frame.size.width) / 2, self.googleButton.frame.origin.y + self.googleButton.frame.size.height }, self.twitterButton.frame.size }];
    [self.view addSubview:self.twitterButton];
    
    self.yahooButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeYahooButton];
    [self.yahooButton setFrame:(CGRect){ {(self.view.frame.size.width - self.yahooButton.frame.size.width) / 2, self.twitterButton.frame.origin.y + self.twitterButton.frame.size.height }, self.yahooButton.frame.size }];
    [self.view addSubview:self.yahooButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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
