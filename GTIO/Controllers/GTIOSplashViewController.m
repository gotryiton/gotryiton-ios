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

@interface GTIOSplashViewController ()

@end

@implementation GTIOSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splash Image
    UIImageView *splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [splashImageView setFrame:CGRectOffset(splashImageView.frame, 0, -20)];
    [self.view addSubview:splashImageView];
    
    // Load Config
    [[GTIOConfigManager sharedManager] loadConfigFromWebUsingBlock:^(NSError *error, GTIOConfig *config) {
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
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/user/me" usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadObject = ^(id object) {
                        [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate) addTabBarToWindow];
                    };
                    loader.onDidFailWithError = ^(NSError *error) {
                        NSLog(@"Auth /user/me failed. User is not logged in.");
                        // TODO: go to view 1.9
                        GTIOSignInViewController *signInViewController = [[GTIOSignInViewController alloc] initWithNibName:nil bundle:nil];
                        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
                        [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate).window setRootViewController:navController];
                    };
                }];
            } else {
                // route to view 1.2
                if ([config.introScreens count] > 0) {
                    GTIOIntroScreensViewController *introScreensViewController = [[GTIOIntroScreensViewController alloc] initWithNibName:nil bundle:nil];
                    [((GTIOAppDelegate *)[UIApplication sharedApplication].delegate).window setRootViewController:introScreensViewController];
                } else {
                    // no intro screens route to view 1.9
                }
                
                [GTIOTrack postTrackUsingBlock:^(NSError *error, GTIOTrack *track) {
                    if (error) {
                        // Fail silently
                        NSLog(@"Failed to POST /track on splash view: %@", [error localizedDescription]);
                    }
                }];
            }
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)loadIntroScreensImages
{
    
}

@end
