//
//  GTIOUser.m
//  GTIO
//
//  Created by Scott Penrose on 5/11/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOUser.h"

#import <RestKit/RestKit.h>

#import "GTIOConfigManager.h"

NSString * const kGTIOAuthTokenKey = @"GTIOAuthTokenKey";

@interface GTIOUser ()

@property (nonatomic, copy) GTIOLoginHandler loginHandler;
@property (nonatomic, strong) NSString *facebookAuthResourcePath;
@property (nonatomic, strong) NSString *janrainAuthResourcePath;

- (void)saveTokenToUserDefaults:(NSString *)authToken;
- (void)authWithFacebookWithLoginHandler:(GTIOLoginHandler)loginHandler;

@end

@implementation GTIOUser

@synthesize userID = _userID, name = _name, icon = _icon, birthYear = _birthYear, location = _location, aboutMe = _aboutMe, city = _city, state = _state, gender = _gender, service = _service, auth = _auth, isNewUser = _isNewUser, hasCompleteProfile = _hasCompleteProfile;
@synthesize facebook = _facebook, facebookAuthResourcePath = _facebookAuthResourcePath;
@synthesize loginHandler = _loginHandler;
@synthesize janrain = _janrain, janrainAuthResourcePath = _janrainAuthResourcePath;

+ (GTIOUser *)currentUser
{
    static GTIOUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
        user.janrain = [JREngage jrEngageWithAppId:kGTIOJanRainEngageApplicationID andTokenUrl:nil delegate:user];
    });
    return user;
}

#pragma mark - Auth

- (BOOL)isLoggedIn
{
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kGTIOAuthTokenKey];
    if ([authToken length] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)logOut
{
    // Remove auth token
    // Remove all data... user=[[self alloc] init]?
}

#pragma mark - AuthToken

- (void)saveTokenToUserDefaults:(NSString *)authToken
{
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:kGTIOAuthTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        loader.params = params;
        loader.method = RKRequestMethodPOST;
        loader.targetObject = self;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            NSLog(@"Loaded user");
            // Save token to user defaults
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

- (void)fbDidNotLogin:(BOOL)cancelled
{
//    if (!cancelled) {
        if (self.loginHandler) {
            NSError *error = [[NSError alloc] init];
            self.loginHandler(nil, error);
        }
//    }
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    
}


- (void)fbDidLogout
{
    
}

- (void)fbSessionInvalidated
{
    
}

#pragma mark - janrain

- (void)signInWithJanrainForProvider:(NSString *)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.janrainAuthResourcePath = @"/user/auth/janrain";
    self.loginHandler = loginHandler;
    [_janrain showAuthenticationDialogForProvider:providerName];
}

- (void)signUpWithJanrainForProvider:(NSString *)providerName WithLoginHandler:(GTIOLoginHandler)loginHandler
{
    self.janrainAuthResourcePath = @"/user/signup/janrain";
    self.loginHandler = loginHandler;
    [_janrain showAuthenticationDialogForProvider:providerName];
}

#pragma mark - JREngageDelegate methods

- (void)jrAuthenticationDidSucceedForUser:(NSDictionary*)auth_info forProvider:(NSString*)provider
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:self.janrainAuthResourcePath usingBlock:^(RKObjectLoader *loader) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [auth_info valueForKey:@"token"], @"janrain_token",
                                nil];
        loader.params = params;
        loader.method = RKRequestMethodPOST;
        loader.targetObject = self;
        
        loader.onDidLoadObjects = ^(NSArray *objects) {
            NSLog(@"Loaded user");
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

@end
