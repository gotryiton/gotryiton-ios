//
//  GTIOSignInViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOSignInViewController.h"

#import "GTIOReturningUsersViewController.h"
#import "GTIOFailedSignInViewController.h"
#import "GTIOAppDelegate.h"
#import "GTIOAlmostDoneViewController.h"
#import "GTIOQuickAddViewController.h"

#import "GTIOPostALookViewController.h"

#import "GTIOTrack.h"

#import "GTIOProgressHUD.h"

@interface GTIOSignInViewController ()

@property (nonatomic, strong) GTIOButton *facebookButton;
@property (nonatomic, strong) GTIOButton *returningUserButton;

@property (nonatomic, assign, getter = isTracked) BOOL tracked;

@end

@implementation GTIOSignInViewController

@synthesize facebookButton = _facebookButton, returningUserButton = _returningUserButton;
@synthesize tracked = _tracked, loginHandler = _loginHandler;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-bg-logo.png"]];
    [backgroundImageView setFrame:CGRectOffset(backgroundImageView.frame, 0, -20)];
    [self.view addSubview:backgroundImageView];
    
    self.facebookButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeFacebookSignUp];
    [self.facebookButton setFrame:(CGRect){ { (self.view.frame.size.width - self.facebookButton.frame.size.width) / 2, 245 }, self.facebookButton.frame.size }];
    [self.facebookButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.facebookButton setTapHandler:^(id sender) {
        [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
        [[GTIOUser currentUser] signUpWithFacebookWithLoginHandler:^(GTIOUser *user, NSError *error) {
            if (error) {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
                GTIOFailedSignInViewController *failedSignInViewController = [[GTIOFailedSignInViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:failedSignInViewController animated:YES];
            } else {
                [GTIOProgressHUD hideHUDForView:self.view animated:YES];
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
        }];
    }];
    [self.view addSubview:self.facebookButton];
    
    self.returningUserButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeReturningUser];
    [self.returningUserButton setFrame:(CGRect){ { (self.view.frame.size.width - self.returningUserButton.frame.size.width) / 2, 300 }, self.returningUserButton.frame.size }];
    [self.returningUserButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.returningUserButton setTapHandler:^(id sender) {
        GTIOReturningUsersViewController *returningUsersViewController = [[GTIOReturningUsersViewController alloc] initForReturningUsers:YES];
        [returningUsersViewController setLoginHandler:self.loginHandler];
        [self.navigationController pushViewController:returningUsersViewController animated:YES];
    }];
    [self.view addSubview:self.returningUserButton];
    
    // Sign up with another provider
    TTTAttributedLabel *signUpLabel = [[TTTAttributedLabel alloc] initWithFrame:(CGRect){ 0, 372, self.view.frame.size.width, 20 }];
    [signUpLabel setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [signUpLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0f]];
    [signUpLabel setTextColor:[UIColor gtio_signInColor]];
    [signUpLabel setTextAlignment:UITextAlignmentCenter];
    [signUpLabel setBackgroundColor:[UIColor clearColor]];
    [signUpLabel setDataDetectorTypes:UIDataDetectorTypeLink];
    [signUpLabel setDelegate:self];    
    [signUpLabel setText:@"or, sign up with another provider" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange pinkRange = [[mutableAttributedString string] rangeOfString:@"sign up with another provider" options:NSCaseInsensitiveSearch];
        if (pinkRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor gtio_pinkTextColor].CGColor range:pinkRange];

        }        
        return mutableAttributedString;
    }];
    UIView *underline = [[UIView alloc] initWithFrame:(CGRect){ 91, signUpLabel.frame.size.height - 3.5, 154, 0.5 }];
    [underline setBackgroundColor:[UIColor gtio_pinkTextColor]];
    [underline setAlpha:0.50];
    [signUpLabel addSubview:underline];
    
    UIButton *signUpLink = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpLink setFrame:(CGRect){ 91, 0, 154, signUpLabel.frame.size.height }];
    [signUpLink addTarget:self action:@selector(loadReturningUsersViewController) forControlEvents:UIControlEventTouchUpInside];
    [signUpLabel addSubview:signUpLink];
    
    [self.view addSubview:signUpLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookButton = nil;
    self.returningUserButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)track
{
    if (!self.isTracked) {
        [GTIOTrack postTrackWithID:kGTIOTrackSignIn handler:nil];
        self.tracked = YES;
    }
}

- (void)loadReturningUsersViewController
{
    GTIOReturningUsersViewController *returningUsersViewController = [[GTIOReturningUsersViewController alloc] initForReturningUsers:NO];
    [returningUsersViewController setLoginHandler:self.loginHandler];
    [self.navigationController pushViewController:returningUsersViewController animated:YES];
}

@end
