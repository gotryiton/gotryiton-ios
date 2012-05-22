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

#import "GTIOUser.h"
#import "GTIOTrack.h"

#import "GTIOProgressHUD.h"

@interface GTIOSignInViewController ()

@property (nonatomic, strong) GTIOButton *facebookButton;
@property (nonatomic, strong) GTIOButton *returningUserButton;

@property (nonatomic, assign, getter = isTracked) BOOL tracked;

@end

@implementation GTIOSignInViewController

@synthesize facebookButton = _facebookButton, returningUserButton = _returningUserButton;
@synthesize tracked = _tracked;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
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
                NSLog(@"Logged in");
                // TODO: new user go to 1.7
                // existing user Go to View 8.1
                [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
            }
        }];
    }];
    [self.view addSubview:self.facebookButton];
    
    self.returningUserButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeReturningUser];
    [self.returningUserButton setFrame:(CGRect){ { (self.view.frame.size.width - self.returningUserButton.frame.size.width) / 2, 300 }, self.returningUserButton.frame.size }];
    [self.returningUserButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.returningUserButton setTapHandler:^(id sender) {
        GTIOReturningUsersViewController *returningUsersViewController = [[GTIOReturningUsersViewController alloc] initWithNibName:nil bundle:nil];
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
    [signUpLabel setLinkAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], (NSString *)kCTUnderlineStyleAttributeName,
                                    [UIColor gtio_linkColor].CGColor, (NSString *)kCTForegroundColorAttributeName,
                                    nil]];
    [signUpLabel setText:@"or, sign up with another provider"];
    NSRange linkRange = [signUpLabel.text rangeOfString:@"sign up with another provider" options:NSCaseInsensitiveSearch];
    [signUpLabel addLinkToURL:[NSURL URLWithString:@"gtio://signUpWithAnotherProvider"] withRange:linkRange];
    [self.view addSubview:signUpLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookButton = nil;
    self.returningUserButton = nil;
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

#pragma mark - TTTAttributedLabel

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"Link selected");
}

@end
