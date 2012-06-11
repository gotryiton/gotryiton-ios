//
//  GTIOSplashViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOSplashViewController.h"

#import <RestKit/RestKit.h>

#import "GTIOTrack.h"
#import "GTIOUser.h"
#import "GTIOConfig.h"

#import "GTIOConfigManager.h"
#import "GTIOAppDelegate.h"

#import "GTIOIntroScreensViewController.h"
#import "GTIOSignInViewController.h"

#import "GTIOQuickAddViewController.h"

@interface GTIOSplashViewController ()

- (void)displaySignInViewController;

@end

@implementation GTIOSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splash Image
    UIImageView *splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [splashImageView setFrame:CGRectOffset(splashImageView.frame, 0, -20)];
    [self.view addSubview:splashImageView];
    
    // Load Config
    [[GTIOConfigManager sharedManager] loadConfigFromWebUsingBlock:^(GTIOConfig *config, NSError *error) {
        if (error) {
            NSLog(@"Error loading config");
            // TODO: Do we fail here or what?
        } else {
            // Check for user auth header
            BOOL authToken = NO;
            if ([[RKObjectManager sharedManager].client.HTTPHeaders objectForKey:kGTIOAuthenticationHeaderKey]) {
                authToken = YES;
            }
            if (authToken) {
                // stay on splash till /user/me comes back
                // TODO: Do we need to track here?
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/user/me" usingBlock:^(RKObjectLoader *loader) {
                    loader.targetObject = [GTIOUser currentUser];
                    loader.onDidLoadObject = ^(id object) {
                        [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
                    };
                    loader.onDidFailWithError = ^(NSError *error) {
                        NSLog(@"Auth /user/me failed. User is not logged in.");
                        [self displaySignInViewController];
                    };
                }];
            } else {
                // route to view 1.2
                if ([config.introScreens count] > 0) {
                    GTIOIntroScreensViewController *introScreensViewController = [[GTIOIntroScreensViewController alloc] initWithNibName:nil bundle:nil];
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:introScreensViewController];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:navController];
                } else {
                    [self displaySignInViewController];
                }
                
                [GTIOTrack postTrackAndVisitWithID:kGTIOTrackAppLaunch handler:nil];
            }
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Next Page Helpers

- (void)displaySignInViewController
{
    GTIOSignInViewController *signInViewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
    [[UIApplication sharedApplication].keyWindow setRootViewController:navController];
}

@end
