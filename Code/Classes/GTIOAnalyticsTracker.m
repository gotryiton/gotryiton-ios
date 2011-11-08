//
//  GTIOAnalyticsTracker.m
//  GoTryItOn
//
//  Created by Blake Watters on 10/6/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOAnalyticsTracker.h"
#import "GTIOUser.h"
#import "GTIOAnalyticsEvents.h"

static GTIOAnalyticsTracker* gSharedTracker = nil;

@implementation GTIOAnalyticsTracker

+ (GTIOAnalyticsTracker*)sharedTracker {
	if (nil == gSharedTracker) {
		gSharedTracker = [[GTIOAnalyticsTracker alloc] init];
	}
	return gSharedTracker;
}

- (void)dispatchEventWithName:(NSString*)eventName {
	TTDINFO(@"URL dispatching analytics event: %@", eventName);
    if ([self respondsToSelector:NSSelectorFromString(eventName)]) {
        [self performSelector:NSSelectorFromString(eventName)];
    } else {
        [self logEvent:eventName];
    }
}

#pragma mark Event Logging Methods

- (void)logEvent:(NSString*)eventName {
    [self logEvent:eventName withParameters:[NSDictionary dictionary]];
}

- (void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)params {
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [parameters setObject:[NSNumber numberWithBool:[[GTIOUser currentUser] isLoggedIn]] forKey:kUserLoggedInParameterName];
    [FlurryAnalytics logEvent:eventName withParameters:parameters];
}

#pragma mark Application Lifecycle

- (NSString*)applicationVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

- (void)trackAppDidFinishLaunching {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kAppDidFinishLaunchingEventName];
}

- (void)trackAppDidBecomeActive {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kAppDidBecomeActiveEventName];
}

#pragma mark User Authentication

- (void)trackUserDidLoginForTheFirstTime {
    [FlurryAnalytics setUserID:[GTIOUser currentUser].UID];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidRegisterOniPhoneEventName];
}

- (void)trackUserDidLogin {
    [FlurryAnalytics setUserID:[GTIOUser currentUser].UID];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidLoginOniPhoneEventName];
}

- (void)trackUserDidLogout {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidLogoutOniPhoneEventName];
}

#pragma mark User Actions
- (void)trackUserDidAddStylists:(NSNumber*)count {
    [self logEvent:kUserAddedStylistsEventName withParameters:[NSDictionary dictionaryWithObject:count forKey:@"count"]];
}

- (void)trackOpinionRequestSubmittedWithInfoDict:(NSDictionary*)info {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidSubmitOutfitWithParametersEventName withParameters:info];
}

#pragma mark Page Views

- (void)trackViewControllerDidAppear:(Class)class {
    NSDictionary* info = [NSDictionary dictionaryWithObject:NSStringFromClass(class) forKey:@"ControllerClass"];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kControllerDidAppearEventName withParameters:info];
}

#pragma mark Simon's Aditions

- (void)trackVote:(NSDictionary*)info {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kVoteSubmitted withParameters:info];
}

- (void)trackSearchListPageViewWithQuery:(NSString*)query {
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            query, @"query", nil];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kSearch withParameters:params];
}

@end











