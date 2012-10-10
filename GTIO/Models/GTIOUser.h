//
//  GTIOUser.h
//  GTIO
//
//  Created by Scott Penrose on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Facebook.h"
#import "JREngage.h"
#import <RestKit/RestKit.h>
#import "GTIOBadge.h"
#import "GTIOButton.h"
#import "GTIOButtonAction.h"
#import "GTIOUserProfile.h"

@class GTIOUser;

typedef void(^GTIOLoginHandler)(GTIOUser *user, NSError *error);
typedef void(^GTIOLogoutHandler)(RKResponse *response);


@interface GTIOUser : NSObject <FBSessionDelegate, JREngageDelegate, RKRequestDelegate>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uniqueName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSURL *icon;
@property (nonatomic, strong) NSNumber *birthYear;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *aboutMe;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSNumber *auth;
@property (nonatomic, strong) NSNumber *isNewUser;
@property (nonatomic, strong) NSNumber *hasCompleteProfile;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *isFacebookConnected;
@property (nonatomic, strong) GTIOBadge *badge;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) GTIOButton *button;
@property (nonatomic, strong) GTIOButtonAction *action;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL showUniqueNameScreen;

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) JREngage *janrain;

/** The current user that is logged in
 */
+ (GTIOUser *)currentUser;
+ (GTIOUserProfile *)currentUserProfile;
- (void)populateWithUser:(GTIOUser *)user;

/** Returns whether current user is authed
 */
- (BOOL)isLoggedIn;

/** Logs current user out of GTIO
 */
- (void)logOutWithLogoutHandler:(GTIOLogoutHandler)logoutHandler;

/** Update current user
 */
- (void)updateCurrentUserWithFields:(NSDictionary*)updateFields withTrackingInformation:(NSDictionary*)trackingInfo andLoginHandler:(GTIOLoginHandler)loginHandler;

/** UrbanAirship alias
 */
- (void)updateUrbanAirshipAliasWithUserID:(NSString *)userID;

/** Sign up/in or connect with Facebook
 */
- (void)signUpWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler;
- (void)signInWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler;
- (void)connectToFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler;

/** Sign up/in with janrain
 */
- (void)signUpWithJanrainForProvider:(NSString*)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler;
- (void)signInWithJanrainForProvider:(NSString*)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler;

/** User Icons from API
 */
- (void)loadUserIconsWithCompletionHandler:(GTIOCompletionHandler)completionHandler;

/** Follow / Quick Add Functionality
 */
- (void)loadQuickAddUsersWithCompletionHandler:(GTIOCompletionHandler)completionHandler;
- (void)followUsers:(NSArray *)userIDs fromScreen:(NSString *)screenTag completionHandler:(GTIOCompletionHandler)completionHandler;

/** Load user by user ID
 */
- (void)loadUserProfileWithUserID:(NSString *)userID completionHandler:(GTIOCompletionHandler)completionHandler;


/** Load user by user ID
 */
- (void)refreshUserProfileWithUserID:(NSString *)userID completionHandler:(GTIOCompletionHandler)completionHandler;


@end
