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
    [FlurryAPI logEvent:eventName withParameters:parameters];
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
    [FlurryAPI setUserID:[GTIOUser currentUser].UID];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidRegisterOniPhoneEventName];
}

- (void)trackUserDidLogin {
    [FlurryAPI setUserID:[GTIOUser currentUser].UID];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidLoginOniPhoneEventName];
}

- (void)trackUserDidLogout {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidLogoutOniPhoneEventName];
}

#pragma mark Opinion Request

- (void)trackUserDidViewGetStarted {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidViewGetStartedEventName];
}

- (void)trackUserDidViewTellUsAboutIt {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidViewTellUsAboutItEventName];
}

- (void)trackUserDidViewShare {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidViewShareEventName];
}

#pragma mark Other Screens

- (void)trackUserDidViewLogin {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidViewLoginEventName];
}

- (void)trackUserDidViewPhotoGuidelines {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidViewPhotoGuidelinesEventName];
}

#pragma mark User Actions
- (void)trackUserDidAddStylists:(NSNumber*)count {
    [self logEvent:kUserAddedStylistsEventName withParameters:[NSDictionary dictionaryWithObject:count forKey:@"count"]];
}

- (void)trackUserDidApplyBlurMask {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidApplyBlurMaskEventName];
}

- (void)trackUserDidTouchCreateMyOutfitPage {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidTouchCreateMyOutfitPageEventName];
}

- (void)trackUserDidTouchGiveAnOpinionFromHomepage {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDidTouchGiveAnOpinionFromHomePageEventName];
}

- (void)trackUserDidTouchGetAnOpinionFromHomepage {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kUserDiDTouchGetAnOpinionFromHomePageEventName];
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
//	TTOpenURL(@"gtio://analytics/trackReviewSubmitted");

- (void)trackReviewSubmitted {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kReviewSubmitted];
}

- (void)trackShareViaSMS {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitShareSMS];
}

- (void)trackShareViaEmail {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitShareEmail];
}

- (void)trackVote:(NSDictionary*)info {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kVoteSubmitted withParameters:info];
}

- (void)trackRecentListPageView {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kRecentListPageView];
}


- (void)trackPopularListPageView {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kPopularListPageView];
}

- (void)trackSearchListPageViewWithQuery:(NSString*)query {
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            query, @"query", nil];
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kSearch withParameters:params];
}

- (void)trackListRefresh {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kAnyListRefresh];
}

- (void)trackWhyChangeSubmitted {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kWhyChangeSubmitted];
}

- (void)trackWhyChangeSkipped {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kWhyChangeSkipped];
}

- (void)trackOutfitEditButtonPressed {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitEdit];
}

- (void)trackOutfitDeleteButtonPressed {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitDelete];
}

- (void)trackMakeOutfitPublicWasPressed {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitPublic];
}

- (void)trackMakeOutfitPrivateWasPressed {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kOutfitPrivate];
}

- (void)trackFlagReview {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kReviewFlag];
}

- (void)trackAgreeWithReview {
    [[GTIOAnalyticsTracker sharedTracker] logEvent:kReviewAgree];
}

@end











