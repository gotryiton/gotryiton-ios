//
//  GTIOUser.m
//  GTIO
//
//  Created by Scott Penrose on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOUser.h"
#import "GTIOConfigManager.h"
#import "GTIOAuth.h"

#import "UAirship.h"

@interface GTIOUser ()

@property (nonatomic, copy) GTIOLoginHandler loginHandler;
@property (nonatomic, strong) NSString *facebookAuthResourcePath;
@property (nonatomic, strong) NSString *janrainAuthResourcePath;

@end

@implementation GTIOUser

+ (GTIOUser *)currentUser
{
    static GTIOUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    NSLog(@"User token: %@", [[GTIOAuth alloc] init].token);
    return user;
}

+ (GTIOUserProfile *)currentUserProfile
{
    GTIOUserProfile *userProfile = [[GTIOUserProfile alloc] init];
    userProfile.profileLocked = [NSNumber numberWithBool:NO];
    return userProfile;
}

#pragma mark - Update

- (void)updateCurrentUserWithFields:(NSDictionary*)updateFields withTrackingInformation:(NSDictionary*)trackingInfo andLoginHandler:(GTIOLoginHandler)loginHandler
{
    NSString *updateUserResourcePath = [NSString stringWithFormat:@"/user/%@/update", self.userID];
    self.loginHandler = loginHandler;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:updateUserResourcePath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                updateFields, @"user",
                                trackingInfo, @"track",
                                nil];

        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            // Find user object
            GTIOUser *user = nil;
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOUser class]]) {
                    user = object;
                    break;
                }
            }
            
            // Populate self with returned User values
            if (user) {
                [self populateWithUser:user];
                [self updateUrbanAirshipAliasWithUserID:user.userID];
            }
            
            if (self.loginHandler) {
                self.loginHandler(user, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"Error Response: %@", [loader.response bodyAsString]);
            if (self.loginHandler) {
                self.loginHandler(nil, error);
            }
        };
    }];
}

#pragma mark - Auth

- (BOOL)isLoggedIn
{
    NSString *authToken = [[GTIOAuth alloc] init].token;
    return [authToken length] > 0;
}

- (void)logOutWithLogoutHandler:(GTIOLogoutHandler)logoutHandler
{
    [GTIOAuth removeToken];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/user/logout" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            if (logoutHandler) {
                logoutHandler(response);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

#pragma mark - Facebook

- (void)signUpWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.facebookAuthResourcePath = @"/user/signup/facebook";
    [self authWithFacebookWithLoginHandler:loginHandler];    
}

- (void)signInWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.facebookAuthResourcePath = @"/user/auth/facebook";
    [self authWithFacebookWithLoginHandler:loginHandler];
}

- (void)connectToFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.facebookAuthResourcePath = @"/user/facebook-connect";
    [self authWithFacebookWithLoginHandler:loginHandler];
}

- (void)authWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.loginHandler = loginHandler;
    self.facebook = [[Facebook alloc] initWithAppId:kGTIOFacebookAppID andDelegate:self];
    NSString *permissionsString = [[GTIOConfigManager sharedManager] config].facebookPermissions;
    NSArray *permissions = [permissionsString componentsSeparatedByString:@","];
    [self.facebook authorize:permissions];
}

#pragma mark - FBSessionDelegate

- (void)fbDidLogin
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.facebookAuthResourcePath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.facebook.accessToken, @"fb_token",
                                nil];
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            // Find user object
            GTIOUser *user = nil;
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOUser class]]) {
                    user = object;
                    break;
                }
            }
            
            // Populate self with returned User values
            if (user) {
                [self populateWithUser:user];
                [self updateUrbanAirshipAliasWithUserID:user.userID];
            }
            
            if (self.loginHandler) {
                self.loginHandler(self, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (self.loginHandler) {
                self.loginHandler(nil, error);
            }
        };
    }];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    if (!cancelled) {
        if (self.loginHandler) {
            NSError *error = [[NSError alloc] init];
            self.loginHandler(nil, error);
        }
    }
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    // Required for FBSessionDelegate
}


- (void)fbDidLogout
{
    // Required for FBSessionDelegate    
}

- (void)fbSessionInvalidated
{
    // Required for FBSessionDelegate
}

#pragma mark - Helpers

- (void)populateWithUser:(GTIOUser *)user
{
    self.userID = user.userID;
    self.name = user.name;
    self.icon = user.icon;
    self.birthYear = user.birthYear;
    self.location = user.location;
    self.aboutMe = user.aboutMe;
    self.city = user.city;
    self.state = user.state;
    self.gender = user.gender;
    self.service = user.service;
    self.auth = user.auth;
    self.isNewUser = user.isNewUser;
    self.hasCompleteProfile = user.hasCompleteProfile;
    self.url = user.url;
    self.email = user.email;
    self.isFacebookConnected = user.isFacebookConnected;
    self.badge = user.badge;
    self.userDescription = user.userDescription;
    self.button = user.button;
}

#pragma mark - janrain

- (void)signInWithJanrainForProvider:(NSString *)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.janrainAuthResourcePath = @"/user/auth/janrain";
    self.loginHandler = loginHandler;
    [self.janrain showAuthenticationDialogForProvider:providerName];
}

- (void)signUpWithJanrainForProvider:(NSString *)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.janrainAuthResourcePath = @"/user/signup/janrain";
    self.loginHandler = loginHandler;
    [self.janrain showAuthenticationDialogForProvider:providerName];
}

#pragma mark - JREngageDelegate methods

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.janrainAuthResourcePath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [auth_info valueForKey:@"token"], @"janrain_token",
                                nil];
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            NSLog(@"Loaded user");
            
            // Find user object
            GTIOUser *user = nil;
            for (id object in objects) {
                if ([object isKindOfClass:[GTIOUser class]]) {
                    user = object;
                    break;
                }
            }
            
            // Populate self with returned User values
            if (user) {
                [self populateWithUser:user];
                [self updateUrbanAirshipAliasWithUserID:user.userID];
            }
            
            if (self.loginHandler) {
                self.loginHandler(self, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"Failed to load user");
            if (self.loginHandler) {
                self.loginHandler(nil, error);
            }
        };
    }];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider
{
    if (self.loginHandler) {
        self.loginHandler(nil, error);
    }
}

- (void)jrAuthenticationDidNotComplete
{
    if (self.loginHandler) {
        self.loginHandler(nil, [NSError errorWithDomain:JREngageErrorDomain code:JRAuthenticationCanceledError userInfo:nil]);
    }
}

- (void)loadUserIconsWithCompletionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *userIconResourcePath = @"/user/icons";
    
    BOOL authToken = NO;
    if ([[RKObjectManager sharedManager].client.HTTPHeaders objectForKey:kGTIOAuthenticationHeaderKey]) {
        authToken = YES;
    }
    if (authToken) {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:userIconResourcePath usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *objects) {
                if (completionHandler) {
                    completionHandler(objects, nil);
                }
            };
            loader.onDidFailWithError = ^(NSError *error) {
                if (completionHandler) {
                    completionHandler(nil, error);
                }
            };
        }];
    } else {
        NSLog(@"no auth token");
    }
}

- (void)loadQuickAddUsersWithCompletionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *quickAddPath = @"/user/quick-add";
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:quickAddPath usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {                
            if (completionHandler) {
                completionHandler(objects, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

- (void)followUsers:(NSArray *)userIDs fromScreen:(NSString *)screenTag completionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *followPath = @"/users/follow-many";
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:followPath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSDictionary dictionaryWithObject:screenTag forKey:@"screen"], @"track",
                                userIDs, @"users",
                                nil];
        loader.params = GTIOJSONParams(params);
        loader.method = RKRequestMethodPOST;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {                
            if (completionHandler) {
                completionHandler(objects, nil);
            }
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

- (void)loadUserProfileWithUserID:(NSString *)userID completionHandler:(GTIOCompletionHandler)completionHandler
{
    NSString *userProfilePath = [NSString stringWithFormat:@"/user/%@/profile", userID];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:userProfilePath usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadResponse = ^(RKResponse *response) {
            NSDictionary *parsedBody = [[response bodyAsString] objectFromJSONString];
            RKObjectMappingProvider* provider = [RKObjectManager sharedManager].mappingProvider;
            NSDictionary *userProfile = [NSDictionary dictionaryWithObject:parsedBody forKey:@"userProfile"];
            RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:userProfile mappingProvider:provider];
            RKObjectMappingResult* result = [mapper performMapping];
            if (completionHandler) {
                completionHandler([result asCollection], nil);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        };
    }];
}

#pragma mark - Push Notifications

- (void)updateUrbanAirshipAliasWithUserID:(NSString *)userID
{
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGTIOPushNotificationDeviceTokenUserDefaults];
    
    if (deviceToken && [userID length] > 0) {
        [[UAirship shared] registerDeviceToken:deviceToken withAlias:userID];
    } else {
        NSLog(@"No device token or user id to register for push");
    }
}

@end
