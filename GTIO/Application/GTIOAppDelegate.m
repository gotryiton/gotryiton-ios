//
//  GTIOAppDelegate.m
//  GTIO
//
//  Created by Scott Penrose on 5/1/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GTIOAppDelegate.h"

#import "GTIOFeedViewController.h"
#import "GTIOExploreLooksViewController.h"
#import "GTIOCameraViewController.h"
#import "GTIOShopViewController.h"
#import "GTIOMeViewController.h"

#import "TTTAttributedLabel.h"

@interface GTIOAppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIImageView *tab1ImageView;
@property (nonatomic, strong) UIImageView *tab2ImageView;
@property (nonatomic, strong) UIImageView *tab3ImageView;
@property (nonatomic, strong) UIImageView *tab4ImageView;
@property (nonatomic, strong) UIImageView *tab5ImageView;

@end

@implementation GTIOAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize tab1ImageView = _tab1ImageView, tab2ImageView = _tab2ImageView, tab3ImageView = _tab3ImageView, tab4ImageView = _tab4ImageView, tab5ImageView = _tab5ImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Customize Tab bar
    [self setupTabBar];
    
    // List all fonts on iPhone
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }

    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"UI-Tab-BG.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"ui.empty.pixel.png"]];
    
    [self.window setRootViewController:self.tabBarController];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UITabBarController

- (void)setupTabBar
{
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    [self.tabBarController setDelegate:self];
    NSArray *viewControllers = [NSArray arrayWithObjects:
                                [[GTIOFeedViewController alloc] initWithNibName:nil bundle:nil],
                                [[GTIOExploreLooksViewController alloc] initWithNibName:nil bundle:nil],
                                [[GTIOCameraViewController alloc] initWithNibName:nil bundle:nil],
                                [[GTIOShopViewController alloc] initWithNibName:nil bundle:nil],
                                [[GTIOMeViewController alloc] initWithNibName:nil bundle:nil],
                                nil];
    [self.tabBarController setViewControllers:viewControllers];
    
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
    
    if ([viewController isKindOfClass:[GTIOFeedViewController class]]) {
        [self.tab1ImageView setImage:[UIImage imageNamed:@"UI-Tab-1-ON.png"]];
    } else if ([viewController isKindOfClass:[GTIOExploreLooksViewController class]]) {
        [self.tab2ImageView setImage:[UIImage imageNamed:@"UI-Tab-2-ON.png"]];
    } else if ([viewController isKindOfClass:[GTIOCameraViewController class]]) {
        [self.tab3ImageView setImage:[UIImage imageNamed:@"UI-Tab-3-ON.png"]];
    } else if ([viewController isKindOfClass:[GTIOShopViewController class]]) {
        [self.tab4ImageView setImage:[UIImage imageNamed:@"UI-Tab-4-ON.png"]];
    } else if ([viewController isKindOfClass:[GTIOMeViewController class]]) {
        [self.tab5ImageView setImage:[UIImage imageNamed:@"UI-Tab-5-ON.png"]];
    }
}

@end
