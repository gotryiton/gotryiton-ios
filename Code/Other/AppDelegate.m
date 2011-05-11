//
//  AppDelegate.m
//  GTIO
//
//  Created by Blake Watters on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Three20/Three20.h>
#import "AppDelegate.h"
#import "GTIOLauncherViewController.h"
#import "GTIOWelcomeViewController.h"
#import "GTIOLoginViewController.h"

#import <TWTAlertViewDelegate.h>
#import <TWTBundledAssetsURLCache.h>
#import "GTIOOpinionRequestSession.h"
#import "GTIOStyleSheet.h"
#import "GTIOUser.h"
#import "GTIOExternalURLHelper.h"
#import "GTIOAnalyticsTracker.h"
#import "GTIOMessageComposer.h"
#import "GTIOReachabilityObserver.h"
#import "GTIOOutfit.h"
#import "GTIOProfile.h"
#import "GTIOReview.h"
#import "GTIOBadge.h"
#import "GTIOLoadingOverlayManager.h"
#import "GTIOChangeItReason.h"
#import "GTIOVotingResultSet.h"
#import "GTIOAppStatusAlert.h"
#import "GTIOAppStatusAlertButton.h"
#import "Facebook.h"

@interface AppDelegate (Private)

- (void)viewRemoteNotification:(NSDictionary*)aps;

@end

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@implementation AppDelegate

@synthesize window = _window;

- (void)setupRestKit {
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:kGTIOBaseURLString];
    
    RKObjectMappingProvider* provider = [[[RKObjectMappingProvider alloc] init] autorelease];
    
    RKObjectMapping* buttonMapping = [RKObjectMapping mappingForClass:[GTIOAppStatusAlertButton class]];
    [buttonMapping addAttributeMapping:RKObjectAttributeMappingMake(@"title", @"title")];
    [buttonMapping addAttributeMapping:RKObjectAttributeMappingMake(@"url", @"url")];
    
    RKObjectMapping* alertMapping = [RKObjectMapping mappingForClass:[GTIOAppStatusAlert class]];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"title", @"title")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"message", @"message")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"cancelButtonTitle", @"cancelButtonTitle")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"id", @"alertID")];
    [alertMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"buttons" toKeyPath:@"buttons" objectMapping:buttonMapping]];
    [provider setMapping:alertMapping forKeyPath:@"alert"];
    
    
    
    
    objectManager.mappingProvider = provider;
    
    //	RKObjectMapper* mapper = objectManager.mapper;
    //	// Add our element to object mappings
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"outfits"];
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"outfit"];
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"recent"];
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"popular"];
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"search"];
    //	[mapper registerClass:[GTIOProfile class] forElementNamed:@"user"];
    //	[mapper registerClass:[GTIOOutfit class] forElementNamed:@"reviewsOutfits"];
    //	[mapper registerClass:[GTIOReview class] forElementNamed:@"reviews"];
    //	[mapper registerClass:[GTIOReview class] forElementNamed:@"review"];
    //	[mapper registerClass:[GTIOBadge class] forElementNamed:@"badges"];
    //	[mapper registerClass:[GTIOChangeItReason class] forElementNamed:@"global_changeitReasons"];
    //	[mapper registerClass:[GTIOVotingResultSet class] forElementNamed:@"votingResults"];
    //	[mapper registerClass:[GTIOAppStatusAlert class] forElementNamed:@"alert"];
    //	[mapper registerClass:[GTIOAppStatusAlertButton class] forElementNamed:@"buttons"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Initialize Flurry
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	[FlurryAPI startSession:kGTIOFlurryAPIKey];
    
	[TTStyleSheet setGlobalStyleSheet:[[[GTIOStyleSheet alloc] init] autorelease]];
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
	
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
	
	TTURLMap* map = navigator.URLMap;
	
	[map from:@"gtio://home" toSharedViewController:[GTIOLauncherViewController class]];
	[map from:@"gtio://welcome" toModalViewController:[GTIOWelcomeViewController class]];
	[map from:@"gtio://login" toModalViewController:[GTIOLoginViewController class]];
    
	[map from:@"gtio://loginWithJanRain" toObject:[GTIOUser currentUser] selector:@selector(loginWithJanRain)];
	[map from:@"gtio://loginWithFacebook" toObject:[GTIOUser currentUser] selector:@selector(loginWithFacebook)];
	[map from:@"gtio://logout" toObject:[GTIOUser currentUser] selector:@selector(logout)];
	
	// External URL's
	GTIOExternalURLHelper* externalURLHelper = [[GTIOExternalURLHelper alloc] init];

	// Convenience Helpers for SMS/E-mail
	[map from:@"gtio://looks/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitViewController")];
	[map from:@"gtio://looks" toViewController:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")];
	
	// Main external URL's. Not very pretty.
	[map from:@"gtio://external/showOutfitOnProfileTab/(showOutfitOnProfileTab:)" toObject:externalURLHelper];	
	[map from:@"gtio://external/showOutfitOnGiveAnOpinionTab/(showOutfitOnGiveAnOpinionTab:)" toObject:externalURLHelper];
	[map from:@"gtio://external/ensureLogin/showProfileTab" toObject:externalURLHelper selector:@selector(showOutfitOnProfileTab:)];
	[map from:@"gtio://external/ensureLogin/showOutfitOnProfileTab/(requireLoginAndShowOutfitOnProfileTab:)" toObject:externalURLHelper];
	[map from:@"gtio://external/ensureLogin/showGiveAnOpinionTab" toObject:externalURLHelper selector:@selector(showOutfitOnGiveAnOpinionTab:)];
	[map from:@"gtio://external/ensureLogin/showOutfitOnGiveAnOpinionTab/(requireLoginAndShowOutfitOnGiveAnOpinionTab:)" toObject:externalURLHelper];
	
	[map from:@"gtio://launching" toSharedViewController:NSClassFromString(@"GTIOLaunchingViewController")];
	[map from:@"gtio://settings" toSharedViewController:NSClassFromString(@"GTIOSettingsViewController")];
	[map from:@"gtio://contacts" toModalViewController:NSClassFromString(@"GTIOContactViewController")];
	[map from:@"gtio://photosPreview" toSharedViewController:NSClassFromString(@"GTIOPhotosPreviewViewController")];
	[map from:@"gtio://takeAPicture" toModalViewController:NSClassFromString(@"GTIOTakeAPictureViewController")];
	[map from:@"gtio://photoGuidelines" toViewController:NSClassFromString(@"GTIOPhotoGuidelinesViewController") transition:UIViewAnimationTransitionCurlDown];
	
	// Get an Opinion
	[map from:@"gtio://getAnOpinion" toModalViewController:NSClassFromString(@"GTIOGetAnOpinionViewController")];
	[map from:@"gtio://getAnOpinion/photosPreview" parent:@"gtio://getAnOpinion" toSharedViewController:NSClassFromString(@"GTIOPhotosPreviewViewController")];
	[map from:@"gtio://getAnOpinion/tellUsAboutIt/multiplePhotos" parent:@"gtio://getAnOpinion/photosPreview" toSharedViewController:NSClassFromString(@"GTIOTellUsAboutItViewController")];
	[map from:@"gtio://getAnOpinion/tellUsAboutIt" parent:@"gtio://getAnOpinion" toSharedViewController:NSClassFromString(@"GTIOTellUsAboutItViewController")];
	[map from:@"gtio://getAnOpinion/share" toViewController:NSClassFromString(@"GTIOShareViewController")];	
	
	// Give an Opinion
	[map from:@"gtio://giveAnOpinion" toViewController:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")];
	// Registered within the controller...
	
	// Profile view
	[map from:@"gtio://profile" toModalViewController:NSClassFromString(@"GTIOProfileViewController")];	
	[map from:@"gtio://profile/look/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitViewController")];
	
	[map from:@"gtio://profile/new" toModalViewController:NSClassFromString(@"GTIOEditProfileViewController") selector:@selector(initWithNewProfile)];
	[map from:@"gtio://profile/edit" toModalViewController:NSClassFromString(@"GTIOEditProfileViewController") selector:@selector(initWithEditProfile)];		
	[map from:@"gtio://profile/(initWithUserID:)" toViewController:NSClassFromString(@"GTIOProfileViewController")];
	[map from:@"gtio://user_looks/(initWithUserID:)" toViewController:NSClassFromString(@"GTIOUserOutfitsTableViewController")];
	[map from:@"gtio://user_reviews/(initWithUserID:)" toViewController:NSClassFromString(@"GTIOUserReviewsTableViewController")];
	
	// Get an Opinion session
	GTIOOpinionRequestSession* session = [GTIOOpinionRequestSession globalSession];
	[map from:@"gtio://getAnOpinion/start" toObject:session selector:@selector(start)];
	[map from:@"gtio://getAnOpinion/next" toObject:session selector:@selector(next)];
	[map from:@"gtio://getAnOpinion/cancel" toObject:session selector:@selector(cancel)];
	[map from:@"gtio://getAnOpinion/share/contacts" toObject:session selector:@selector(shareWithContacts)];
	
	[map from:@"gtio://getAnOpinion/photos/new" toObject:session selector:@selector(presentPhotoSourceActionSheetWithoutGuidelines)];
	[map from:@"gtio://getAnOpinion/photos/edit/(editPhoto:)" toObject:session selector:@selector(editPhoto:)];
	
	// step1/next for the current next
	// cancel will drop it anywhere
	// TODO: tellUsAboutIt (step2), takeAPicture (step1), share (step3). Considering centralizing navigation into the session to decouple controllers
	[map from:@"gtio://getAnOpinion/submit" toObject:session selector:@selector(submit)];
	
	// Analytics Tracking
	GTIOAnalyticsTracker* tracker = [GTIOAnalyticsTracker sharedTracker];
	[map from:@"gtio://analytics/(dispatchEventWithName:)" toObject:tracker];
	
	// Message composer
	GTIOMessageComposer* messageComposer = [[GTIOMessageComposer alloc] init];
	[map from:@"gtio://messageComposer/email/(emailComposerWithOutfitID:)/(subject:)/(body:)" toModalViewController:messageComposer];
	[map from:@"gtio://messageComposer/textMessage/(textMessageComposerWithOutfitID:)/(body:)" toModalViewController:messageComposer];
    
	//[map from:@"gtio://popViewController" toObject:session selector:@selector(popViewController)];
	[map from:@"gtio://popToRootViewController" toObject:session selector:@selector(popToRootViewController)];
	
	[map from:@"gtio://show_reviews/(initWithOutfitID:)" toViewController:NSClassFromString(@"GTIOOutfitReviewsController") transition:UIViewAnimationTransitionFlipFromRight];
	
	// Map loading urls
	[map from:@"gtio://loading" toObject:[GTIOLoadingOverlayManager sharedManager] selector:@selector(showLoading)];
	[map from:@"gtio://stopLoading" toObject:[GTIOLoadingOverlayManager sharedManager] selector:@selector(stopLoading)];
	
	// All other links open the web controller
	[map from:@"*" toViewController:[TTWebController class]];
	
    navigator.window = self.window;
    [self.window makeKeyAndVisible];
    
	[navigator openURLAction:
	 [[TTURLAction actionWithURLPath:@"gtio://launching"] applyAnimated:NO]];	
	
	// User Account housekeeping
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(userDidLoginWithIncompleteProfile:) 
												 name:kGTIOUserDidLoginWithIncompleteProfileNotificationName 
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:kGTIOUserDidLoginNotificationName object:nil];
	
	// Handle Launch Options
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
		NSDictionary* aps = [[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"];
		[self performSelector:@selector(viewRemoteNotification:) withObject:aps afterDelay:1.0];
	} else if ([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey]) {
		// Save the launch URL for dispatch after the session has been resumed
		NSURL* URL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		if (NO == [[URL absoluteString] isEqualToString:@"gtio://external/launch"]) {
			_launchURL = [URL retain];
		}
	}
	
	// Bring the reachability observer online
	[GTIOReachabilityObserver sharedObserver];
	
	// Register for Push Notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
	
    // Initialize RestKit
    [self setupRestKit];
	
	// Track app load
	TTOpenURL(@"gtio://analytics/trackAppDidFinishLaunching");
	
	// Load Profile data for User from Go Try It On
	GTIOUser* user = [GTIOUser currentUser];
	[user resumeSession];
	
    [[TTNavigator navigator] openURLAction:
     [[TTURLAction actionWithURLPath:@"gtio://home"] applyAnimated:NO]];
    if (![user isLoggedIn]) {
        [[TTNavigator navigator] openURLAction:
         [[TTURLAction actionWithURLPath:@"gtio://welcome"] applyAnimated:NO]];
    }
    
	if (_launchURL) {
		[[TTNavigator navigator] openURLAction:
		 [[TTURLAction actionWithURLPath:[_launchURL absoluteString]] applyAnimated:NO]];
		
		[_launchURL release];
		_launchURL = nil;
	}
	
	NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							versionString, @"iphoneAppVersion",
							nil];
	[[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/status") queryParams:params delegate:self];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	return YES;
//    // Initialize RestKit
//    // RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://restkit.org"];
//    
//    // Initialize Three20
//    TTNavigator* navigator = [TTNavigator navigator];
//    [navigator setPersistenceMode:TTNavigatorPersistenceModeAll];
//    TTURLMap* map = navigator.URLMap;
//    [map from:@"gtio://home" toSharedViewController:[GTIOLauncherViewController class]];
//    
//    
//    // Override point for customization after application launch.
//    navigator.window = self.window;
//    [self.window makeKeyAndVisible];
//    
//    if ([navigator restoreViewControllers] == nil) {
//        TTOpenURL(@"gtio://home");
//        // TODO: check to see if we are logged in.
//        // Present login if we are not.
//    }
//    
//    
//    return YES;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
    NSLog(@"dictionary: %@", dictionary);
    GTIOAppStatusAlert* alert = [dictionary objectForKey:@"alert"];
    if (alert) {
		[alert show];
	}
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	// Fail silently?
	return;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	// Special handling for the external launch URL: gtio://external/launch
	// If we are have been launched via gtio://external/launch and there is not a top view controller
	// we want to show the Home screen (gtio://home)
	if ([[URL absoluteString] isEqualToString:@"gtio://external/launch"]) {
		if (nil == [TTNavigator globalNavigator].topViewController) {
			[[TTNavigator navigator] openURLAction:
			 [TTURLAction actionWithURLPath:@"gtio://home"]];
			
			return YES;			
		}
	} else if ([[URL absoluteString] rangeOfString:@"fb"].location == 0) {
        Facebook* facebook = [GTIOUser currentUser].facebook;
        return [facebook handleOpenURL:URL];
    } else {
		if (![URL isEqual:_launchURL]) {
			[[TTNavigator navigator] openURLAction:
			 [TTURLAction actionWithURLPath:URL.absoluteString]];
			
			return YES;
		}
	}		
	
	return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	TTOpenURL(@"gtio://analytics/trackAppDidBecomeActive");
	if (_lastWentInactiveAt) {
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_lastWentInactiveAt];
		NSLog(@"Inactive for: %f seconds", interval);
		NSTimeInterval refreshInterval = 60*15;
		
		if (interval >= refreshInterval) {
			UIViewController* rootController = [[[[TTNavigator navigator] topViewController].navigationController viewControllers] objectAtIndex:0];
			NSLog(@"Root Controller: %@", rootController);
			if ([rootController isKindOfClass:NSClassFromString(@"GTIOEditProfileViewController")]) {
				[rootController dismissModalViewControllerAnimated:NO];
				rootController = [[[[TTNavigator navigator] topViewController].navigationController viewControllers] objectAtIndex:0];
			}
			if ([rootController isKindOfClass:NSClassFromString(@"GTIOGiveAnOpinionTableViewController")] ||
				[rootController isKindOfClass:NSClassFromString(@"GTIOProfileViewController")]) {
				[[[TTNavigator navigator] topViewController].navigationController popToRootViewControllerAnimated:NO];
                [(TTModelViewController*)rootController invalidateModel];
			}
		}
		
		[_lastWentInactiveAt release];
		_lastWentInactiveAt = nil;
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	_lastWentInactiveAt = [[NSDate date] retain];
}

#pragma mark User Login

- (void)userDidLoginWithIncompleteProfile:(NSNotification*)notification {
    // Wait for other navigations to finish
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
  	// Trigger display of the 'Almost Done' screen
	[[TTNavigator navigator] openURLAction:
	 [[TTURLAction actionWithURLPath:@"gtio://profile/new"] applyAnimated:YES]];
}

- (void)userDidLogin:(NSNotification*)note {
    UIViewController* home = TTOpenURL(@"gtio://home");
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    [home dismissModalViewControllerAnimated:YES];
}

#pragma mark Push Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {	
	GTIOUser* user = [GTIOUser currentUser];
	NSString* deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
	NSRange range = NSMakeRange(1, [deviceTokenString length] - 2);
	deviceTokenString = [deviceTokenString substringWithRange:range];
	user.deviceToken = deviceTokenString;
	NSLog(@"Sucessfully registered for push notifications. Device Token = %@", deviceTokenString);
	
	// By doing this in the background, we prevent a crash in the event that the app launches with a partially logged in user.
	[user performSelector:@selector(resumeSession) withObject:nil afterDelay:1.0];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"Unable to register for remote notifications: %@", [error localizedDescription]);
	GTIOUser* user = [GTIOUser currentUser];
	user.deviceToken = nil;
	
	// By doing this in the background, we prevent a crash in the event that the app launches with a partially logged in user.
	[user performSelector:@selector(resumeSession) withObject:nil afterDelay:1.0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {	
	NSDictionary* aps = [userInfo objectForKey:@"aps"];
	// If we multi task, and were already active, or we don't multitask, show alert
	if (([application respondsToSelector:@selector(applicationState)] 
         && UIApplicationStateActive == [application applicationState]) ||
		![application respondsToSelector:@selector(applicationState)]) {
		id alert = [aps objectForKey:@"alert"];
		NSString* message = nil;
		BOOL showViewButton = YES;
		if ([alert isKindOfClass:[NSString class]]) {
			message = alert;
		} else {
			message = [alert objectForKey:@"body"];
			if ([alert objectForKey:@"show-view"] != nil) {
				showViewButton = [[alert objectForKey:@"show-view"] boolValue];
			}
		}
		if (showViewButton) {
			TWTAlertViewDelegate* delegate = [[TWTAlertViewDelegate alloc] init];
			[delegate setTarget:self selector:@selector(viewRemoteNotification:) object:aps forButtonIndex:1];
			[[[[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" 
										 message:message 
										delegate:delegate
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:@"View", nil] autorelease] show];
			[delegate autorelease];
		} else {
			[[[[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" 
										 message:message 
										delegate:nil 
							   cancelButtonTitle:@"OK" 
							   otherButtonTitles:nil] autorelease] show];
		}
	} else {
		[self viewRemoteNotification:aps];
	}
}

- (void)viewRemoteNotification:(NSDictionary*)aps {
	// This gets called with the aps dictionary if the user taps the View button or the app is launched by a remote notification
	NSLog(@"View Remote Notification: %@", aps);
	// Let's assume that they will give us a tturl to open for now.
	NSString* url = [[aps objectForKey:@"loc-args"] objectForKey:@"url"];
	if (url) {
		TTOpenURL(@"gtio://home");
		TTOpenURL(url);
	}
}
#ifdef FRANK

// Frank Helpers. Login, Logout, open URL, etc. Anything that needs to modify state of the app.

- (void)franklyLogoutUser {
    [[GTIOUser currentUser] logout];
}

- (void)franklyOpenURL:(NSString*)URL {
    TTOpenURL(URL);
}

- (void)franklyLogin {
    GTIOUser* user = [GTIOUser currentUser];
    user.username = @"Jeremy E.";
    user.loggedIn = YES;
}

#endif

@end
