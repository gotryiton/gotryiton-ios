//
//  GTIOReturningUsersViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOReturningUsersViewController.h"
#import "GTIOAlmostDoneViewController.h"
#import "GTIOFailedSignInViewController.h"
#import "GTIOQuickAddViewController.h"

#import "GTIOAppDelegate.h"

#import "GTIOProgressHUD.h"

@interface GTIOReturningUsersViewController ()

@property (nonatomic, strong) GTIOUIButton *facebookButton;
@property (nonatomic, strong) GTIOUIButton *aolButton;
@property (nonatomic, strong) GTIOUIButton *googleButton;
@property (nonatomic, strong) GTIOUIButton *twitterButton;
@property (nonatomic, strong) GTIOUIButton *yahooButton;

@property (nonatomic, assign, getter = isReturningUser) BOOL returningUser;

- (void)directUserToAppropriateScreenAfterSignIn:(GTIOUser*)user WithError:(NSError*)error;

@end

@implementation GTIOReturningUsersViewController

@synthesize facebookButton = _facebookButton, aolButton = _aolButton, googleButton = _googleButton, twitterButton = _twitterButton, yahooButton = _yahooButton;
@synthesize returningUser = _returningUser, loginHandler = _loginHandler;

- (id)initForReturningUsers:(BOOL)returning 
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _returningUser = returning;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initForReturningUsers:YES];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"login-nav.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *backgroundImageResourcePath = (self.returningUser) ? @"login-return-bg.png" : @"login-janrain-new-bg.png";
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed
                                                                           :backgroundImageResourcePath]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -64)];
    [self.view addSubview:backgroundImageView];

    GTIOUIButton *backButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeBackBottomMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
    
    __block id blockSelf = self;
    __block BOOL blockReturningUser = self.returningUser;
    
    GTIOLoginHandler loginHandler = ^(GTIOUser *user, NSError *error) {
        [blockSelf directUserToAppropriateScreenAfterSignIn:user WithError:error];
    };
    
    if (_returningUser) {
        self.facebookButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFacebookSignIn];
        [self.facebookButton setFrame:(CGRect){ {(self.view.frame.size.width - self.facebookButton.frame.size.width) / 2, 80 }, self.facebookButton.frame.size }];
        [self.facebookButton setTapHandler:^(id sender) {
            [[GTIOUser currentUser] signInWithFacebookWithLoginHandler:^(GTIOUser *user, NSError *error) {
                [blockSelf directUserToAppropriateScreenAfterSignIn:user WithError:error];
            }];
        }];
        [self.view addSubview:self.facebookButton];
    }
    
    double signinOptionsTableYPos = (self.returningUser) ? 145.0 : 116.0;
    
    self.aolButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeAOL];
    [self.aolButton setFrame:(CGRect){ { (self.view.frame.size.width - self.aolButton.frame.size.width) / 2, signinOptionsTableYPos }, self.aolButton.frame.size }];
    [self.aolButton setTapHandler:^(id sender) {
        if (blockReturningUser) {
            [[GTIOUser currentUser] signInWithJanrainForProvider:kGTIOJanRainProviderAol WithLoginHandler:loginHandler];
        } else {
            [[GTIOUser currentUser] signUpWithJanrainForProvider:kGTIOJanRainProviderAol WithLoginHandler:loginHandler];
        }
    }];
    [self.view addSubview:self.aolButton];
    
    self.googleButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeGoogle];
    [self.googleButton setFrame:(CGRect){ {(self.view.frame.size.width - self.googleButton.frame.size.width) / 2, self.aolButton.frame.origin.y + self.aolButton.frame.size.height }, self.googleButton.frame.size }];
    [self.googleButton setTapHandler:^(id sender) {
        if (blockReturningUser) {
            [[GTIOUser currentUser] signInWithJanrainForProvider:kGTIOJanRainProviderGoogle WithLoginHandler:loginHandler];
        } else {
            [[GTIOUser currentUser] signUpWithJanrainForProvider:kGTIOJanRainProviderGoogle WithLoginHandler:loginHandler];
        }
    }];
    [self.view addSubview:self.googleButton];
    
    self.twitterButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeTwitter];
    [self.twitterButton setFrame:(CGRect){ {(self.view.frame.size.width - self.twitterButton.frame.size.width) / 2, self.googleButton.frame.origin.y + self.googleButton.frame.size.height }, self.twitterButton.frame.size }];
    [self.twitterButton setTapHandler:^(id sender) {
        if (blockReturningUser) {
            [[GTIOUser currentUser] signInWithJanrainForProvider:kGTIOJanRainProviderTwitter WithLoginHandler:loginHandler];
        } else {
            [[GTIOUser currentUser] signUpWithJanrainForProvider:kGTIOJanRainProviderTwitter WithLoginHandler:loginHandler];
        }
    }];
    [self.view addSubview:self.twitterButton];
    
    self.yahooButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeYahoo];
    [self.yahooButton setFrame:(CGRect){ {(self.view.frame.size.width - self.yahooButton.frame.size.width) / 2, self.twitterButton.frame.origin.y + self.twitterButton.frame.size.height }, self.yahooButton.frame.size }];
    [self.yahooButton setTapHandler:^(id sender) {
        if (blockReturningUser) {
            [[GTIOUser currentUser] signInWithJanrainForProvider:kGTIOJanRainProviderYahoo WithLoginHandler:loginHandler];
        } else {
            [[GTIOUser currentUser] signUpWithJanrainForProvider:kGTIOJanRainProviderYahoo WithLoginHandler:loginHandler];
        }
    }];
    [self.view addSubview:self.yahooButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookButton = nil;
    self.aolButton = nil;
    self.googleButton = nil;
    self.twitterButton = nil;
    self.yahooButton = nil;
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

#pragma mark - 

- (void)directUserToAppropriateScreenAfterSignIn:(GTIOUser *)user WithError:(NSError *)error 
{
    if (error) {
        GTIOFailedSignInViewController *failedSignInViewController = [[GTIOFailedSignInViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:failedSignInViewController animated:YES];
    } else {
        if ([user.isNewUser boolValue]) {
            if ([user.hasCompleteProfile boolValue]) {
                GTIOQuickAddViewController *quickAddViewController = [[GTIOQuickAddViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:quickAddViewController animated:YES];
            } else {
                GTIOAlmostDoneViewController *almostDone = [[GTIOAlmostDoneViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:almostDone animated:YES];
            }
        } else {
            if ([user.hasCompleteProfile boolValue]) {
                if (self.loginHandler) {
                    self.loginHandler(user, nil);
                } else {
                    [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
                }
            } else {
                GTIOAlmostDoneViewController *almostDone = [[GTIOAlmostDoneViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:almostDone animated:YES];
            }
        }
    }
}

@end
