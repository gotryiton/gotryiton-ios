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
	SEL selector = NSSelectorFromString(eventName);
	[self performSelector:selector];
}

#pragma mark Application Lifecycle

- (NSString*)applicationVersionString {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
}

- (void)trackAppDidFinishLaunching {
    [FlurryAPI logEvent:kAppDidFinishLaunchingEventName];
}

- (void)trackAppDidBecomeActive {
    [FlurryAPI logEvent:kAppDidBecomeActiveEventName];
}

#pragma mark User Authentication

- (void)trackUserDidLoginForTheFirstTime {
    [FlurryAPI setUserID:[GTIOUser currentUser].UID];
    [FlurryAPI logEvent:kUserDidRegisterOniPhoneEventName];
}

- (void)trackUserDidLogin {
    [FlurryAPI setUserID:[GTIOUser currentUser].UID];
    [FlurryAPI logEvent:kUserDidLoginOniPhoneEventName];
}

- (void)trackUserDidLogout {
    [FlurryAPI logEvent:kUserDidLogoutOniPhoneEventName];
}

#pragma mark Opinion Request

- (void)trackUserDidViewGetStarted {
    [FlurryAPI logEvent:kUserDidViewGetStartedEventName];
}

- (void)trackUserDidViewTellUsAboutIt {
    [FlurryAPI logEvent:kUserDidViewTellUsAboutItEventName];
}

- (void)trackUserDidViewShare {
    [FlurryAPI logEvent:kUserDidViewShareEventName];
}

#pragma mark Other Screens

- (void)trackUserDidViewHomepage {
    [FlurryAPI logEvent:kUserDidViewHomepageEventName];
}

- (void)trackUserDidViewSettings {
    [FlurryAPI logEvent:kUserDidViewSettingsTabEventName];
}

- (void)trackUserDidViewLogin {
    [FlurryAPI logEvent:kUserDidViewLoginEventName];
}

- (void)trackUserDidViewContacts {
    [FlurryAPI logEvent:kUserDidViewAddFromContactsEventName];
}

- (void)trackUserDidViewPhotoGuidelines {
    [FlurryAPI logEvent:kUserDidViewPhotoGuidelinesEventName];
}

#pragma mark User Actions
- (void)trackUserDidApplyBlurMask {
    [FlurryAPI logEvent:kUserDidApplyBlurMaskEventName];
}

- (void)trackUserDidTouchCreateMyOutfitPage {
    [FlurryAPI logEvent:kUserDidTouchCreateMyOutfitPageEventName];
}

- (void)trackUserDidAddContact {
    [FlurryAPI logEvent:kUserDidAddContactEventName];
}

- (void)trackUserDidRemoveContact {
    [FlurryAPI logEvent:kUserDidRemoveContactEventName];
}

- (void)trackUserDidTouchGiveAnOpinionFromHomepage {
    [FlurryAPI logEvent:kUserDidTouchGiveAnOpinionFromHomePageEventName];
}

- (void)trackUserDidTouchGetAnOpinionFromHomepage {
    [FlurryAPI logEvent:kUserDiDTouchGetAnOpinionFromHomePageEventName];
}

- (void)trackOpinionRequestSubmittedWithInfoDict:(NSDictionary*)info {
    [FlurryAPI logEvent:kUserDidSubmitOutfitWithParametersEventName withParameters:info];
}

#pragma mark Page Views

- (void)trackViewControllerDidAppear:(Class)class {
    NSDictionary* info = [NSDictionary dictionaryWithObject:NSStringFromClass(class) forKey:@"ControllerClass"];
    [FlurryAPI logEvent:kControllerDidAppearEventName withParameters:info];
}

#pragma mark Simon's Aditions
//	TTOpenURL(@"gtio://analytics/trackReviewSubmitted");

- (void)trackOutfitPageView {
    
    [FlurryAPI logEvent:kOutfitPageView];
}

- (void)trackReviewSubmitted {
    [FlurryAPI logEvent:kReviewSubmitted];
}

- (void)trackShareViaSMS {
    [FlurryAPI logEvent:kOutfitShareSMS];
}

- (void)trackShareViaEmail {
    [FlurryAPI logEvent:kOutfitShareEmail];
}

- (void)trackVote:(NSDictionary*)info {
    [FlurryAPI logEvent:kVoteSubmitted withParameters:info];
}

- (void)trackRecentListPageView {
    [FlurryAPI logEvent:kRecentListPageView];
}


- (void)trackPopularListPageView {
    [FlurryAPI logEvent:kPopularListPageView];
}

- (void)trackSearchListPageViewWithQuery:(NSString*)query {
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            query, @"query", nil];
    [FlurryAPI logEvent:kSearch withParameters:params];
}

- (void)trackProfilePageView {
    [FlurryAPI logEvent:kProfilePageView];
}

- (void)trackMyProfilePageView {
    [FlurryAPI logEvent:kMyProfilePageView];
}

- (void)trackListRefresh {
    [FlurryAPI logEvent:kAnyListRefresh];
}

- (void)trackOutfitRefresh {
    [FlurryAPI logEvent:kOutfitRefresh];
}

- (void)trackDescriptionExpanded {
    [FlurryAPI logEvent:kOutfitDescriptionExpand];
}

- (void)trackFullscreen {
    [FlurryAPI logEvent:kOutfitFullScreen];
}

- (void)trackWhyChangeSubmitted {
    [FlurryAPI logEvent:kWhyChangeSubmitted];
}

- (void)trackWhyChangeSkipped {
    [FlurryAPI logEvent:kWhyChangeSkipped];
}

- (void)trackOutfitEditButtonPressed {
    [FlurryAPI logEvent:kOutfitEdit];
}

- (void)trackOutfitDeleteButtonPressed {
    [FlurryAPI logEvent:kOutfitDelete];
}

- (void)trackMakeOutfitPublicWasPressed {
    [FlurryAPI logEvent:kOutfitPublic];
}

- (void)trackMakeOutfitPrivateWasPressed {
    [FlurryAPI logEvent:kOutfitPrivate];
}

- (void)trackFlagReview {
    [FlurryAPI logEvent:kReviewFlag];
}

- (void)trackAgreeWithReview {
    [FlurryAPI logEvent:kReviewAgree];
}

@end
