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
#import "GTIOUniqueNameSplashViewController.h"
#import "GTIOConnectViewController.h"
#import "GTIOMeViewController.h"

#import "GTIOAppearance.h"
#import "GTIOMappingProvider.h"

#import "GTIOTrack.h"
#import "GTIOUser.h"
#import "GTIOAuth.h"
#import "GTIORouter.h"
#import "GTIONotificationManager.h"

#import "JREngage.h"
#import "UAirship.h"
#import "UAPush.h"
#import "FlurryAnalytics.h"
#import "BPXLUUIDHandler.h"

@interface GTIOAppDelegate ()

@property (nonatomic, strong) GTIOSplashViewController *splashViewController;

@property (nonatomic, strong) GTIOCameraViewController *cameraViewController;

@property (nonatomic, strong) UIViewController *lastSelectedController;

@property (nonatomic, strong) UIImageView *tab1ImageView;
@property (nonatomic, strong) UIImageView *tab2ImageView;
@property (nonatomic, strong) UIImageView *tab3ImageView;
@property (nonatomic, strong) UIImageView *tab4ImageView;
@property (nonatomic, strong) UIImageView *tab5ImageView;

@property (nonatomic, strong) NSArray *tabBarViewControllers;

@property (nonatomic, strong) NSDate *dateAppDidBecomeInactive;

- (void)setupTabBar;
- (void)setupRestKit;

@end

@implementation GTIOAppDelegate

#if DEBUG

- (void)triggerMemoryWarning {
    NSLog(@"Triggering Memory Warning");
    [[UIApplication sharedApplication] performSelector:@selector(_performMemoryWarning)];
}

#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if DEBUG == 0
    [TestFlight takeOff:@"01429fe002e0a4e8b7055610f04fa766_OTE1MjMyMDEyLTA1LTE4IDA5OjU0OjUxLjA3MzA3Mw"];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"\n*****\nGTIO Started in %@ mode.\n*****", kGTIOEnvironmentName);
    
    // List all fonts on iPhone
#if DEBUG
//    [self listAllFonts];
     // [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    
    // Simulate memory warnings.
    //    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(triggerMemoryWarning) userInfo:nil repeats:YES];
    
#endif
    
    // Appearance setup
    [GTIOAppearance setupAppearance];
    
    // RestKit
    [self setupRestKit];

    // Customize Tab bar
    [self setupTabBar];
    
    // Initialize Janrain
    [GTIOUser currentUser].janrain = [JREngage jrEngageWithAppId:kGTIOJanRainEngageApplicationID andTokenUrl:nil delegate:[GTIOUser currentUser]];
    
//    [self.window setRootViewController:self.tabBarController];
    self.splashViewController = [[GTIOSplashViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:self.splashViewController];
    
    // Setup camera
    self.cameraViewController = [[GTIOCameraViewController alloc] initWithNibName:nil bundle:nil];
    
    // Notification Management
    [GTIONotificationManager sharedManager];
    
    // UrbanAirship
    [self setupUrbanAirshipWithLaunchOptions:launchOptions];
    
    // Flurry
    [FlurryAnalytics startSession:kGTIOFlurryAnalyticsKey];
    
    // Handle notification
    NSDictionary *notificationUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationUserInfo) {
        [self handleNotificationUserInfo:notificationUserInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTab:) name:kGTIOChangeSelectedTabNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTabBarToWindow:) name:kGTIOAddTabBarToWindowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeTabBarViews:) name:kGTIOTabBarViewsResize object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUniqueNameModalScreen) name:kGTIOShouldShowUniqueNameModalView object:nil];
    
    [self.window makeKeyAndVisible];
    

    NSString *deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:kGTIOYozioAnalyticsURL, kGTIOYozioAnalyticsKey, deviceName];
    [NSURLConnection connectionWithRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    self.dateAppDidBecomeInactive = [NSDate date];
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

    // Reset the badge number back to zero.
    application.applicationIconBadgeNumber = 0;
    
    // Test if the app has been inactive for a long time
    if(self.dateAppDidBecomeInactive) {
        NSTimeInterval secondsAppHasBeenInactive = [[NSDate date] timeIntervalSinceDate:self.dateAppDidBecomeInactive];
        
        NSLog(@"Seconds app has been inactive: %f (min: %.2f)", secondsAppHasBeenInactive, secondsAppHasBeenInactive/60.0f);
        
        if(secondsAppHasBeenInactive > kGTIOSecondsInactiveBeforeRefresh) {
                        
            // pop the navigation controllers back to their root view
            for(id controller in self.tabBarViewControllers) {
                if([controller isKindOfClass:[UINavigationController class]]) {
                    [(UINavigationController*)controller popToRootViewControllerAnimated:NO];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAppReturningFromInactiveStateNotification object:nil];
            
            // find the selected root view controller and notify it to load
            switch (self.tabBarController.selectedIndex) {
                case 0:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOFeedControllerShouldRefresh object:nil];
                    break;
                case 1:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOExploreLooksControllerShouldRefresh object:nil];
                    break;
                case 2:
                    // load all in background
                    
                    break;
                case 3:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOStyleControllerShouldRefresh object:nil];
                    break;
                case 4:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOMeControllerShouldRefresh object:nil];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [UAirship land];
}

#pragma mark - Open URL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] hasPrefix:@"gtio"]) {
        [self openURL:url];
        return YES;
    } else if ([[url absoluteString] hasPrefix:@"fb"]) {
        return [[GTIOUser currentUser].facebook handleOpenURL:url];
    }
    
    return NO;
}

- (void)openURL:(NSURL *)URL
{
    [self.cameraViewController dismissModalViewControllerAnimated:YES];
    
    id viewController = [[GTIORouter sharedRouter] viewControllerForURL:URL fromExternal:YES];
    id selectedViewController = self.tabBarController.selectedViewController;
    [selectedViewController pushViewController:viewController animated:YES];
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
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace)
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace)
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:kGTIOBaseURLString];
    [objectManager setMappingProvider:[[GTIOMappingProvider alloc] init]];
    [objectManager setAcceptMIMEType:kGTIOAcceptHeader];
    [objectManager setSerializationMIMEType:RKMIMETypeJSON];
    
    // Network
    [RKClient sharedClient].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Headers
    [objectManager.client setValue:[BPXLUUIDHandler UUID] forHTTPHeaderField:kGTIOTrackingHeaderKey];

    NSString *authToken = [[GTIOAuth alloc] init].token;
    if ([authToken length] > 0) {
        [[RKObjectManager sharedManager].client.HTTPHeaders setObject:authToken forKey:kGTIOAuthenticationHeaderKey];
    }
//#warning test code
//    [[RKObjectManager sharedManager].client.HTTPHeaders setObject:@"dcb57bdb860926ef1d357e776246380d" forKey:kGTIOAuthenticationHeaderKey];
    
    // Auth for dev/staging
#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING || GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
    [objectManager.client setAuthenticationType:RKRequestAuthenticationTypeHTTPBasic];
    [objectManager.client setUsername:kGTIOHTTPAuthUsername];
    [objectManager.client setPassword:kGTIOHTTPAuthPassword];
#endif
    
    // Routes
    RKObjectRouter *router = objectManager.router;
    [router routeClass:[GTIOTrack class] toResourcePath:@"/track" forMethod:RKRequestMethodPOST];
}

#pragma mark - UrbanAirship

- (void)setupUrbanAirshipWithLaunchOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    NSMutableDictionary *configuration = [NSMutableDictionary dictionary];
    [configuration setValue:[NSNumber numberWithBool:kGTIOUAirshipAppStoreOrAdHocBuild] forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
    [configuration setValue:kGTIOUAirshipDevelopmentAppKey forKey:@"DEVELOPMENT_APP_KEY"];
    [configuration setValue:kGTIOUAirshipDevelopmentAppSecret forKey:@"DEVELOPMENT_APP_SECRET"];
    [configuration setValue:kGTIOUAirshipProductionAppKey forKey:@"PRODUCTION_APP_KEY"];
    [configuration setValue:kGTIOUAirshipProductionAppSecret forKey:@"PRODUCTION_APP_SECRET"];
    [takeOffOptions setValue:configuration forKey:UAirshipTakeOffOptionsAirshipConfigKey];
    
    [UAirship takeOff:takeOffOptions];
    // [UAirship setLogging:YES];
    
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{
    NSLog(@"APN device token: %@", deviceToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:kGTIOPushNotificationDeviceTokenUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error 
{
    NSLog(@"Failed To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    NSLog(@"Received remote notification: %@", userInfo);
    
    if (UIApplicationStateActive == application.applicationState) {
        // GET /notifications
        [[GTIONotificationManager sharedManager] refreshNotificationsWithCompletionHandler:nil];
    } else {
        // open URL
        [self handleNotificationUserInfo:userInfo];
    }
}

- (void)handleNotificationUserInfo:(NSDictionary *)userInfo
{
    NSString *URL = [[[userInfo objectForKey:@"aps"] objectForKey:@"loc-args"] objectForKey:@"url"];
    [self openURL:[NSURL URLWithString:URL]];
}

#pragma mark - UITabBarController

- (void)addTabBarToWindow:(NSNotification *)notification
{
    [self.window setRootViewController:self.tabBarController];
}

- (void)resizeTabBarViews:(NSNotification *)notification
{
    // Fix for the tab bar going opaque when you go to a view that hides it and back to a view that has the tab bar
    for(UIView *view in self.tabBarController.view.subviews) {
        if(![view isKindOfClass:[UITabBar class]]) {
            [view setFrame:(CGRect){ view.frame.origin.x, view.frame.origin.y, view.frame.size.width, self.window.frame.size.height }];
        }
    }
}

- (void)selectTab:(NSNotification *)notification
{
    GTIOTabBarTab tab = [[[notification userInfo] objectForKey:kGTIOChangeSelectedTabToUserInfo] integerValue];
    
    if ([self tabBarController:self.tabBarController shouldSelectViewController:[self.tabBarViewControllers objectAtIndex:tab]]) {
        [self.tabBarController setSelectedIndex:tab];
        [self tabBarController:self.tabBarController didSelectViewController:[self.tabBarViewControllers objectAtIndex:tab]];
    }
}

- (void)setupTabBar
{
    self.tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    [self.tabBarController setDelegate:self];
    
    UINavigationController *meNavigationController = [[UINavigationController alloc] initWithRootViewController:[[GTIOMeViewController alloc] initWithNibName:nil bundle:nil]];
    UINavigationController *feedNavController = [[UINavigationController alloc] initWithRootViewController:[[GTIOFeedViewController alloc] initWithNibName:nil bundle:nil]];
    UINavigationController *styleNavController = [[UINavigationController alloc] initWithRootViewController:[[GTIOConnectViewController alloc] initWithNibName:nil bundle:nil]];
    UINavigationController *looksNavController = [[UINavigationController alloc] initWithRootViewController:[[GTIOExploreLooksViewController alloc] initWithNibName:nil bundle:nil]];
    
    self.tabBarViewControllers = [NSArray arrayWithObjects:
                                feedNavController,
                                looksNavController,
                                [[GTIOCameraTabBarPlaceholderViewController alloc] initWithNibName:nil bundle:nil],
                                styleNavController,
                                meNavigationController,
                                nil];
    [self.tabBarController setViewControllers:self.tabBarViewControllers];
    
    for(UIView *view in self.tabBarController.view.subviews) {
        if(![view isKindOfClass:[UITabBar class]]) {
            [view setFrame:(CGRect){ view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height }];
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
    
    // start first time load & pretend that we're `returning` from inactive
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAppReturningFromInactiveStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldRefresh object:nil];
        
    [[GTIONotificationManager sharedManager] loadNotificationsIfNeeded];  
    
       
}

- (void)showUniqueNameModalScreen
{

    int viewsOfModalScreen = [[NSUserDefaults standardUserDefaults] integerForKey:kGTIOUniqueNameModalDialogFlag];
    if (viewsOfModalScreen < kGTIOUniqueNameModalDialogMaxViews) {
        if ([[GTIOUser currentUser].showUniqueNameScreen integerValue]>0){
             viewsOfModalScreen++;
            [[NSUserDefaults standardUserDefaults] setInteger:viewsOfModalScreen forKey:kGTIOUniqueNameModalDialogFlag];
            [[NSUserDefaults standardUserDefaults] synchronize];
            GTIOUniqueNameSplashViewController *uniqueNameViewController = [[GTIOUniqueNameSplashViewController alloc] initWithNibName:nil bundle:nil];
            [uniqueNameViewController setDismissHandler:^(UIViewController *viewController) {
               [viewController dismissViewControllerAnimated:YES completion:^{
                   [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldDoForcedRefresh object:nil];
               }];
            }];

            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:uniqueNameViewController];
            [self.tabBarController presentModalViewController:navController animated:YES];
     
        }
    }
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
        } else if ([rootViewController isKindOfClass:[GTIOConnectViewController class]]) {
            [self.tab4ImageView setImage:[UIImage imageNamed:@"UI-Tab-4-ON.png"]];
        } else if ([rootViewController isKindOfClass:[GTIOExploreLooksViewController class]]) {
            [self.tab2ImageView setImage:[UIImage imageNamed:@"UI-Tab-2-ON.png"]];
        }

        self.lastSelectedController = rootViewController;

    } else if ([viewController isKindOfClass:[GTIOCameraViewController class]]) {
        [self.tab3ImageView setImage:[UIImage imageNamed:@"UI-Tab-3-ON.png"]];

        self.lastSelectedController = viewController;
    }
    
    // Wait 1 second and then check for notifications so that we can let the page load.
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[GTIONotificationManager sharedManager] loadNotificationsIfNeeded];
    });

    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL shouldSelect = YES;
    
    if ([viewController isKindOfClass:[GTIOCameraTabBarPlaceholderViewController class]]) {
        
        [GTIOTrack postTrackWithID:kGTIOUserNavigatedToCameraTab handler:nil];

        shouldSelect = NO;
        [self.cameraViewController setDismissHandler:^(UIViewController *viewController) {
            [viewController dismissViewControllerAnimated:YES completion:^{
                [self.cameraViewController.postALookViewController reset];
            }];
        }];
        [self.cameraViewController setFlashOn:NO];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.cameraViewController];
        [navController setNavigationBarHidden:YES animated:NO];
        [self.tabBarController presentModalViewController:navController animated:YES];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {

        UINavigationController *navController = (UINavigationController *)viewController;
        UIViewController *rootViewController = [navController.viewControllers objectAtIndex:0];

        NSString *trackContollerId = nil;
       
        if ([rootViewController isKindOfClass:[GTIOFeedViewController class]]) {
            trackContollerId = kGTIOUserNavigatedToFeedTab;
            //if tab is in view already, scroll to top
            if ([navController.viewControllers count]==1 && [self.lastSelectedController isKindOfClass:[GTIOFeedViewController class]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOFeedControllerShouldScrollToTopNotification object:nil];
            }
        } else if ([rootViewController isKindOfClass:[GTIOExploreLooksViewController class]]) {
            trackContollerId = kGTIOUserNavigatedToExploreTab;
            //if tab is in view already, scroll to top
            if ([navController.viewControllers count]==1 && [self.lastSelectedController isKindOfClass:[GTIOExploreLooksViewController class]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOExploreControllerShouldScrollToTopNotification object:nil];
            }
        } else if ([rootViewController isKindOfClass:[GTIOMeViewController class]]) {
            trackContollerId = kGTIOUserNavigatedToMeTab;
            //if tab is in view already, scroll to top
            if ([navController.viewControllers count]==1 && [self.lastSelectedController isKindOfClass:[GTIOMeViewController class]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOMeControllerShouldScrollToTopNotification object:nil];
            }
        } else if ([rootViewController isKindOfClass:[GTIOConnectViewController class]]) {
            trackContollerId = kGTIOUserNavigatedToStyleTab;
            //if tab is in view already, scroll to top
            if ([navController.viewControllers count]==1 && [self.lastSelectedController isKindOfClass:[GTIOConnectViewController class]]){
                [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOStyleControllerShouldScrollToTopNotification object:nil];
            }
        } 


        if (![rootViewController isKindOfClass:[self.lastSelectedController class]]) {
            // track tab switching when user tabs on a tab
            [GTIOTrack postTrackWithID:trackContollerId handler:nil];
        } else if ([navController.viewControllers count]>1){
            // handle taps on the tab bar when tab is already selected
            [navController popToRootViewControllerAnimated:YES];
        }
            
    }
    
    return shouldSelect;
}

@end
