//
//  GTIOUser.h
//  GTIO
//
//  Created by Scott Penrose on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "Facebook.h"
#import "JREngage.h"

@class GTIOUser;

typedef void(^GTIOCompletionHandler)(NSArray *loadedObjects, NSError *error);
typedef void(^GTIOLoginHandler)(GTIOUser *user, NSError *error);

@interface GTIOUser : NSObject <FBSessionDelegate, JREngageDelegate>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
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

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) JREngage *janrain;

/** The current user that is logged in
 */
+ (GTIOUser *)currentUser;

/** Returns whether current user is authed
 */
- (BOOL)isLoggedIn;

/** Logs current user out of GTIO
 */
- (void)logOut;

/** Update current user
 */
- (void)updateCurrentUserWithFields:(NSDictionary*)updateFields withTrackingInformation:(NSDictionary*)trackingInfo andLoginHandler:(GTIOLoginHandler)loginHandler;

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
- (void)loadUserIconsWithUserID:(NSString*)userID andCompletionHandler:(GTIOCompletionHandler)completionHandler;

@end
