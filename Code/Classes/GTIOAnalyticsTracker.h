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
 * the flurry api interface to provide page & event tracking
 */
@interface GTIOAnalyticsTracker : NSObject {}

/**
 * Return the shared tracker instance
 */
+ (GTIOAnalyticsTracker*)sharedTracker;

/**
 * Called when a /analytics/eventName url is opened
 */
- (void)dispatchEventWithName:(NSString*)eventName;

/**
 * Fire off flurry event with name (global parameters are added)
 */
- (void)logEvent:(NSString*)eventName;

/**
 * Fire off flurry event with name and parameters
 */
- (void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)params;

#pragma mark Application Lifecycle
- (NSString*)applicationVersionString;
- (void)trackAppDidFinishLaunching;
- (void)trackAppDidBecomeActive;

#pragma mark User Authentication
- (void)trackUserDidLoginForTheFirstTime;
- (void)trackUserDidLogin;
- (void)trackUserDidLogout;

#pragma mark User Actions
- (void)trackUserDidAddStylists:(NSNumber*)count;
- (void)trackOpinionRequestSubmittedWithInfoDict:(NSDictionary*)info;

#pragma mark Page Views
- (void)trackViewControllerDidAppear:(Class)class;

#pragma mark Simon's Aditions
- (void)trackVote:(NSDictionary*)info;
- (void)trackSearchListPageViewWithQuery:(NSString*)query;

@end
