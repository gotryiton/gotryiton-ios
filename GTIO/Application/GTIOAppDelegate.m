//
//  GTIOAppDelegate.m
//  GTIO
//
//  Created by Scott Penrose on 5/1/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <RestKit/RestKit.h>
#import "TestFlight.h"

#import "GTIOAppDelegate.h"

#import "GTIOSplashViewController.h"

#import "GTIOFeedViewController.h"
#import "GTIOExploreLooksViewController.h"
#import "GTIOCameraViewController.h"
#import "GTIOCameraTabBarPlaceholderViewController.h"
#import "GTIOStyleViewController.h"
#import "GTIOMeViewController.h"

#import "GTIOAppearance.h"
#import "GTIOMappingProvider.h"

#import "GTIOTrack.h"
#import "GTIOUser.h"
#import "GTIOAuth.h"
#import "GTIORouter.h"

#import "JREngage.h"

@interface GTIOAppDelegate ()

@property (nonatomic, strong) GTIOSplashViewController *splashViewController;

@property (nonatomic, strong) GTIOCameraViewController *cameraViewController;

@property (nonatomic, strong) UIImageView *tab1ImageView;
@property (nonatomic, strong) UIImageView *tab2ImageView;
@property (nonatomic, strong) UIImageView *tab3ImageView;
@property (nonatomic, strong) UIImageView *tab4ImageView;
@property (nonatomic, strong) UIImageView *tab5ImageView;

@property (nonatomic, strong) NSArray *tabBarViewControllers;

- (void)setupTabBar;
- (void)setupRestKit;

@end

@implementation GTIOAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize splashViewController = _splashViewController;
@synthesize cameraViewController = _cameraViewController;
@synthesize tab1ImageView = _tab1ImageView, tab2ImageView = _tab2ImageView, tab3ImageView = _tab3ImageView, tab4ImageView = _tab4ImageView, tab5ImageView = _tab5ImageView;
@synthesize tabBarViewControllers = _tabBarViewControllers;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG == 0
    [TestFlight takeOff:@"01429fe002e0a4e8b7055610f04fa766_OTE1MjMyMDEyLTA1LTE4IDA5OjU0OjUxLjA3MzA3Mw"];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"\n*****\nGTIO Started in %@ mode.\n*****", kGTIOEnvironmentName);
    
    // List all fonts on iPhone
#if DEBUG
    [self listAllFonts];
#endif
    
    // Appearance setup
    [GTIOAppearance setupAppearance];
    
    // Customize Tab bar
    [self setupTabBar];
    
    // RestKit
    [self setupRestKit];
    
    // Initialize Janrain
    [GTIOUser currentUser].janrain = [JREngage jrEngageWithAppId:kGTIOJanRainEngageApplicationID andTokenUrl:nil delegate:[GTIOUser currentUser]];
    
//    [self.window setRootViewController:self.tabBarController];
    self.splashViewController = [[GTIOSplashViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:self.splashViewController];
    
    // Setup camera
    self.cameraViewController = [[GTIOCameraViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [GTIOTrack postTrackAndVisitWithID:kGTIOTrackAppResumeFromBackground handler:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[GTIOUser currentUser].facebook handleOpenURL:url]; 
}

#pragma mark - FontHelper

- (void)listAllFonts
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

#pragma mark - RestKit

- (void)setupRestKit
{
//    RKLogConfigureByName("RestKit/*", kGTIOLogLevel);
//    RKLogConfigureByName("RestKit/Network", kGTIONetworkLogLevel)
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace)
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:kGTIOBaseURLString];
    [objectManager setMappingProvider:[[GTIOMappingProvider alloc] init]];
    [objectManager setAcceptMIMEType:kGTIOAcceptHeader];
    [objectManager setSerializationMIMEType:RKMIMETypeJSON];
    
    // Headers
    [objectManager.client setValue:@"142" forHTTPHeaderField:kGTIOTrackingHeaderKey];
    
    NSString *authToken = [[GTIOAuth alloc] init].token;
    if ([authToken length] > 0) {
        [[RKObjectManager sharedManager].client.HTTPHeaders setObject:authToken forKey:kGTIOAuthenticationHeaderKey];
    }
//#warning test code
//    [[RKObjectManager sharedManager].client.HTTPHeaders setObject:@"f8c3ff8684d637f21a016444c3d1bd31" forKey:kGTIOAuthenticationHeaderKey];
    
    // Auth for dev/staging
    [objectManager.client setAuthenticationType:RKRequestAuthenticationTypeHTTPBasic];
    [objectManager.client setUsername:@"tt"];
    [objectManager.client setPassword:@"toast"];
    
    // Routes
    RKObjectRouter *router = objectManager.router;
    [router routeClass:[GTIOTrack class] toResourcePath:@"/track" forMethod:RKRequestMethodPOST];
}

#pragma mark - UITabBarController

- (void)addTabBarToWindow
{
    [self.window setRootViewController:self.tabBarController];
}

- (void)selectTabAtIndex:(GTIOTabBarTab)tab
{
    [self.tabBarController setSelectedIndex:tab];
    [self tabBarController:self.tabBarController didSelectViewController:[self.tabBarViewControllers objectAtIndex:tab]];
}

- (void)setupTabBar
{
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    [self.tabBarController setDelegate:self];
    
    UINavigationController *meNavigationController = [[UINavigationController alloc] initWithRootViewController:[[GTIOMeViewController alloc] initWithNibName:nil bundle:nil]];
    UINavigationController *feedNavController = [[UINavigationController alloc] initWithRootViewController:[[GTIOFeedViewController alloc] initWithNibName:nil bundle:nil]];
    UINavigationController *styleNavController = [[UINavigationController alloc] initWithRootViewController:[[GTIOStyleViewController alloc] initWithNibName:nil bundle:nil]];
    
    self.tabBarViewControllers = [NSArray arrayWithObjects:
                                feedNavController,
                                [[GTIOExploreLooksViewController alloc] initWithNibName:nil bundle:nil],
                                [[GTIOCameraTabBarPlaceholderViewController alloc] initWithNibName:nil bundle:nil],
                                styleNavController,
                                meNavigationController,
                                nil];
    [self.tabBarController setViewControllers:self.tabBarViewControllers];
    
    for(UIView *view in self.tabBarController.view.subviews) {
        if(![view isKindOfClass:[UITabBar class]]) {
            [view setFrame:(CGRect){ view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480 }];
        }
    }
    
    self.tab1ImageView = [[UIImageView alloc] init];
    self.tab2ImageView = [[UIImageView alloc] init];
    self.tab3ImageView = [[UIImageView alloc] init];
    self.tab4ImageView = [[UIImageView alloc] init];
    self.tab5ImageView = [[UIImageView alloc] init];
    
    NSArray *tabImageViews = [NSArray arrayWithObjects:self.tab1ImageView, self.tab2ImageView, self.tab3ImageView, self.tab4ImageView, self.tab5ImageView, nil];
    
    [tabImageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = obj;
        [imageView setFrame:(CGRect){ idx * 64, 0, 64, 49 }];
        [imageView setImage:[UIImage imageNamed:@"UI-Tab-1-OFF.png"]];
        [imageView setUserInteractionEnabled:NO];
        [self.tabBarController.tabBar addSubview:imageView];
    }];
        
    [self.tabBarController.delegate tabBarController:self.tabBarController didSelectViewController:self.tabBarController.selectedViewController];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.tab1ImageView setImage:[UIImage imageNamed:@"UI-Tab-1-OFF.png"]];
    [self.tab2ImageView setImage:[UIImage imageNamed:@"UI-Tab-2-OFF.png"]];
    [self.tab3ImageView setImage:[UIImage imageNamed:@"UI-Tab-3-OFF.png"]];
    [self.tab4ImageView setImage:[UIImage imageNamed:@"UI-Tab-4-OFF.png"]];
    [self.tab5ImageView setImage:[UIImage imageNamed:@"UI-Tab-5-OFF.png"]];
    
    if ([viewController isKindOfClass:[UINavigationController class]] && 
        [((UINavigationController *)viewController).viewControllers count] > 0) {
        
        UINavigationController *navController = (UINavigationController *)viewController;
        UIViewController *rootViewController = [navController.viewControllers objectAtIndex:0];
        
        if ([rootViewController isKindOfClass:[GTIOFeedViewController class]]) {
            [self.tab1ImageView setImage:[UIImage imageNamed:@"UI-Tab-1-ON.png"]];
        } else if ([rootViewController isKindOfClass:[GTIOMeViewController class]]) {
            [self.tab5ImageView setImage:[UIImage imageNamed:@"UI-Tab-5-ON.png"]];
        } else if ([rootViewController isKindOfClass:[GTIOStyleViewController class]]) {
            [self.tab4ImageView setImage:[UIImage imageNamed:@"UI-Tab-4-ON.png"]];
        }
    } else if ([viewController isKindOfClass:[GTIOExploreLooksViewController class]]) {
        [self.tab2ImageView setImage:[UIImage imageNamed:@"UI-Tab-2-ON.png"]];
    } else if ([viewController isKindOfClass:[GTIOCameraViewController class]]) {
        [self.tab3ImageView setImage:[UIImage imageNamed:@"UI-Tab-3-ON.png"]];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL shouldSelect = YES;
    
    if ([viewController isKindOfClass:[GTIOCameraTabBarPlaceholderViewController class]]) {
        shouldSelect = NO;
        [self.cameraViewController setDismissHandler:^(UIViewController *viewController) {
            [viewController dismissModalViewControllerAnimated:YES];
        }];
        [self.cameraViewController setFlashOn:NO];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.cameraViewController];
        [navController setNavigationBarHidden:YES animated:NO];
        [self.tabBarController presentModalViewController:navController animated:YES];
    }
    
    return shouldSelect;
}

@end
