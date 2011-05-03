//
//  GTIOAnalyticsTracker.h
//  GoTryItOn
//
//  Created by Blake Watters on 10/6/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * URL dispatchable analytics tracker. This wraps
 * the Google Analytics interface to provide page & event tracking
 */
@interface GTIOAnalyticsTracker : NSObject {

}

/**
 * Return the shared tracker instance
 */
+ (GTIOAnalyticsTracker*)sharedTracker;

// Application Lifecycle
- (void)trackAppDidFinishLaunching;
- (void)trackAppDidBecomeActive;

// User Authentication
- (void)trackUserDidLoginForTheFirstTime;
- (void)trackUserDidLogin;
- (void)trackUserDidLogout;

/**
 * User Navigation
 */

// Opinion Request
- (void)trackUserDidViewGetStarted;
- (void)trackUserDidViewTellUsAboutIt;
- (void)trackUserDidViewShare;

// Other Screens
- (void)trackUserDidViewHomepage;
- (void)trackUserDidViewSettings;
- (void)trackUserDidViewLogin;
- (void)trackUserDidViewContacts;
- (void)trackUserDidViewPhotoGuidelines;

/**
 * User Actions
 */
- (void)trackUserDidApplyBlurMask;
- (void)trackUserDidTouchCreateMyOutfitPage;
- (void)trackUserDidAddContact;
- (void)trackUserDidRemoveContact;
- (void)trackUserDidTouchGiveAnOpinionFromHomepage;
- (void)trackUserDidTouchGetAnOpinionFromHomepage;

/**
 * Track the successful submission of an opinion request to GTIO. This
 * action uses a special string for the label to pass information about
 * the configured settings on the opinion request. See the 
 * GTIOOpinionRequest infoDict method for more info
 */
- (void)trackOpinionRequestSubmittedWithInfoDict:(NSDictionary*)info;

- (void)trackViewControllerDidAppear:(Class)class;

- (void)trackVote:(NSDictionary*)info;

- (void)trackSearchListPageViewWithQuery:(NSString*)query;

@end
