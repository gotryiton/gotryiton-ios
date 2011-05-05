//
//  GTIOUser.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "JREngage.h"
#import <RestKit/RestKit.h>
#import "Facebook.h"

//////////////////////////////////////////////////////////////////////
// Notifications

/**
 * Posted when the User has logged in to Go Try It On
 */
extern NSString* const kGTIOUserDidLoginNotificationName;

/**
 * Posted when the User has logged in to Go Try It On with an incomplete User profile
 */
extern NSString* const kGTIOUserDidLoginWithIncompleteProfileNotificationName;

/**
 * Posted when the User has logged out of Go Try It On
 */
extern NSString* const kGTIOUserDidLogoutNotificationName;

/**
 * Posted when the User has canceled a login
 */
extern NSString* const kGTIOUserDidCancelLoginNotificationName;

/**
 * Posted when the profile data is processed
 */
NSString* const kGTIOUserDidUpdateProfileNotificationName;

/**
 * Posted when the login process starts and stops
 */
extern NSString* const kGTIOUserDidBeginLoginProcess;
extern NSString* const kGTIOUserDidEndLoginProcess;

//////////////////////////////////////////////////////////////////////

@interface GTIOUser : NSObject <JREngageDelegate, FBSessionDelegate> {
	BOOL _loggedIn;	
	NSString* _token;
	NSString* _UID;
	NSString* _username;
	NSString* _gender;
	NSString* _city;
	NSString* _state;
	NSString* _email;
	NSNumber* _emailAlertSetting;
	NSString* _aboutMe;
	BOOL _iphonePush;
	NSString* _deviceToken;
	NSArray* _services;
	NSArray* _eventTypes;
    
    Facebook* _facebook;
}

@property (nonatomic, assign) BOOL iphonePush;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* UID;
@property (nonatomic, copy) NSString* username;

@property (nonatomic, readonly) Facebook* facebook;

/**
 * Either 'male' or 'female'
 */
@property (nonatomic, copy) NSString* gender;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* deviceToken;

/**
 * The list of services this account is associated with. Returned
 * as an array of string names (i.e. Google, Facebook, Twitter, etc)
 */
@property (nonatomic, retain) NSArray* services;

/**
 * A list of possible event types and their ids. keys are 'id' and 'type'
 */
@property (nonatomic, retain) NSArray* eventTypes;

@property (nonatomic, readonly) NSString* firstName;
@property (nonatomic, readonly) NSString* lastInitial;

/**
 * User service registration accessors
 */

// Is the User registered with Facebook?
@property (nonatomic, readonly) BOOL isRegisteredWithFacebook;

// Is the User registered with Twitter?
@property (nonatomic, readonly) BOOL isRegisteredWithTwitter;

/**
 * Server Side URL's
 */

// Web Profile URL
@property (nonatomic, readonly) NSURL* profileURL;

// Web Recent Looks URL
@property (nonatomic, readonly) NSURL* getAnOpinionURL;

// URL to REST Service for updating profile
@property (nonatomic, readonly) NSURL* updateProfileURL;

// URL to the REST Service for authenticating through JanRain Engage
@property (nonatomic, readonly) NSURL* authURL;

// URL to the REST Service for loading profile data
@property (nonatomic, readonly) NSURL* loadProfileURL;

// URL to the REST Service to logout;
@property (nonatomic, readonly) NSURL* logoutURL;

/*
 * Email Alerts: 
 * "outfit alerts only" = 2
 * "outfit alerts + site news" = 1 
 * "no emails" = 0
 */
@property (nonatomic, retain) NSNumber* emailAlertSetting;

/**
 * The current User of the application
 */
+ (GTIOUser*)currentUser;

/**
 * Used to identify the device (used when a user is not logged in)
 */
+ (NSString*)uniqueIdentifier;

/**
 * Adds either the authToken or uniqueIdentifier and returns a new dictionary.
 */
+ (NSDictionary*)paramsByAddingCurrentUserIdentifier:(NSDictionary*)params;

/**
 * Votes for a perticular outfit, identified by outfitID.
 * look - the look index which look you want to vote for. (0 is change it (or wear none)), or 1,2,3,4 for that look.
 * reasons - this is an array of reason IDs (this will only ever not be nil if the look is change-it.
 * delegate - the object loader delegate to call with the response/error.
 */
+ (RKObjectLoader*)voteForOutfit:(NSString*)outfitID look:(NSInteger)look reasons:(NSArray*)reasons delegate:(NSObject<RKObjectLoaderDelegate>*)delegate;

/**
 * Begin the login process with Facebook (preferred)
 */
- (void)loginWithFacebook;

/**
 * Begin the login process using JanRain Engage
 */
- (void)loginWithJanRain;

/**
 * Resumes a current session via a persisted token
 */
- (void)resumeSession;

/**
 * Log out from the system and clear all profile data
 */
- (void)logout;

/**
 * Update the profile data with a dictionary of information
 */
- (void)digestProfileInfo:(NSDictionary*)profileInfo;

// Web profile URL for a specific outfit
- (NSURL*)profileURLForOutfitID:(NSString*)outfitID;

// Web URL for Recent Looks identifying a specific outfit
- (NSURL*)getAnOpinionURLForOutfitID:(NSString*)outfitID;

/**
 * Return the deviceToken URL encoded
 */
- (NSString*)deviceTokenURLEncoded;

@end
