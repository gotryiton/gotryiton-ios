//
//  GTIOUser.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOUser.h"
#import "JSON.h"
#import "TTURLJSONResponse.h"
#import "GTIOTitleView.h"
#import "GTIOAnalyticsTracker.h"
#import "GTIOJanrainAuthenticationController.h"

// Constants (see GTIOEnvironment.m)
extern NSString* const kGTIOJanRainEngageApplicationID;
extern NSString* const kGTIOJanRainEngageTokenURLString;

NSString* const kGTIOTokenUserDefaultsKey = @"kGTIOTokenUserDefaultsKey";

// Notifications
NSString* const kGTIOUserDidLoginNotificationName = @"kGTIOUserDidLoginNotification";
NSString* const kGTIOUserDidLoginWithIncompleteProfileNotificationName = @"kGTIOUserDidLoginWithIncompleteProfileNotificationName";
NSString* const kGTIOUserDidLogoutNotificationName = @"kGTIOUserDidLogoutNotificationName";
NSString* const kGTIOUserDidCancelLoginNotificationName = @"kGTIOUserDidCancelLoginNotificationName";
NSString* const kGTIOUserDidUpdateProfileNotificationName = @"kUserProfileUpdatedNotification";

NSString* const kGTIOUserDidBeginLoginProcess = @"kGTIOUserDidBeginLoginProcess";
NSString* const kGTIOUserDidEndLoginProcess = @"kGTIOUserDidEndLoginProcess";

// Global current User instance
static GTIOUser* gCurrentUser = nil;

@implementation GTIOUser

@synthesize iphonePush = _iphonePush;
@synthesize aboutMe = _aboutMe;
@synthesize emailAlertSetting = _emailAlertSetting;
@synthesize loggedIn = _loggedIn;
@synthesize UID = _UID;
@synthesize username = _username;
@synthesize gender = _gender;
@synthesize city = _city;
@synthesize state = _state;
@synthesize email = _email;
@synthesize deviceToken = _deviceToken;
@synthesize services = _services;
@synthesize eventTypes = _eventTypes;
@synthesize facebook = _facebook;
@synthesize profileIconURL = _profileIconURL;

+ (GTIOUser*)currentUser {
	if (nil == gCurrentUser) {
		gCurrentUser = [[GTIOUser alloc] init];
	}
	
	return gCurrentUser;
}

+ (NSString*)uniqueIdentifier {
	NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"GTIOUserIdentifier"];
	if (nil == uid) {
		uid = [[NSProcessInfo processInfo] globallyUniqueString];
		[[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"GTIOUserIdentifier"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return uid;
}

+ (NSDictionary*)paramsByAddingCurrentUserIdentifier:(NSDictionary*)params {
	NSMutableDictionary* copy = [[params mutableCopy] autorelease];
	if ([[GTIOUser currentUser] isLoggedIn]) {
		[copy setValue:[GTIOUser currentUser].token forKey:@"gtioToken"];
	} else {
		[copy setValue:[GTIOUser uniqueIdentifier] forKey:@"uniqueId"];
	}
	return [[copy copy] autorelease];
}

+ (RKObjectLoader*)voteForOutfit:(NSString*)outfitID look:(NSInteger)look reasons:(NSArray*)reasons delegate:(NSObject<RKObjectLoaderDelegate>*)delegate {
	NSString* vote = [NSString stringWithFormat:@"wear%d", look];
	NSString* reasonsString = nil;
    if (reasons) {
        reasonsString = [NSString stringWithFormat:@"[%@]", [reasons componentsJoinedByString:@","]];
    }
	NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
							vote, @"vote",
							reasonsString, @"reasons", nil];
	params = [self paramsByAddingCurrentUserIdentifier:params];
    NSDictionary* trackParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 vote, @"vote", nil];
    [[GTIOAnalyticsTracker sharedTracker] trackVote:trackParams];
	NSString* path = [NSString stringWithFormat:@"/vote/%@", outfitID];
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:GTIORestResourcePath(path) delegate:delegate];
	loader.method = RKRequestMethodPOST;
	loader.params = params;
	[loader send];
    return loader;
}

- (id)init {
	if (self = [super init]) {
		_loggedIn = NO;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_UID);
	TT_RELEASE_SAFELY(_username);
	TT_RELEASE_SAFELY(_gender);
	TT_RELEASE_SAFELY(_city);
	TT_RELEASE_SAFELY(_state);
	TT_RELEASE_SAFELY(_email);
	TT_RELEASE_SAFELY(_emailAlertSetting);
	TT_RELEASE_SAFELY(_aboutMe);
	TT_RELEASE_SAFELY(_deviceToken);
	TT_RELEASE_SAFELY(_services);
	TT_RELEASE_SAFELY(_eventTypes);
    TT_RELEASE_SAFELY(_facebook);
	[super dealloc];
}

- (void)didStartLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidBeginLoginProcess object:self];
}

- (void)didStopLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidEndLoginProcess object:self];
}

- (void)loginWithFacebook {
    [self didStartLogin];
    _facebook = [[Facebook alloc] initWithAppId:kGTIOFacebookAppID];
    NSArray* permissions = [NSArray arrayWithObjects:@"publish_stream", @"offline_access", @"email", @"user_birthday", nil];
    [_facebook authorize:permissions delegate:self];
}

- (void)loginWithJanRain {
    [self didStartLogin];
	if (NO == self.isLoggedIn) {
		[GTIOJanrainAuthenticationController showAuthenticationDialog];
	}
}

- (void)clearUserData {	
	self.UID = nil;
	self.token = nil;
	self.username = nil;
	self.gender = nil;
	self.city = nil;
	self.state = nil;
	self.email = nil;
	self.emailAlertSetting = nil;
	self.services = nil;
	self.iphonePush = NO;
	self.loggedIn = NO;
    self.profileIconURL = nil;

}

- (void)logout {
	TTURLRequest* request = [TTURLRequest requestWithURL:[self.logoutURL absoluteString] delegate:self];
	request.response = [[[TTURLJSONResponse alloc] init] autorelease];
	[request sendSynchronously];
	[self clearUserData];
}

- (void)resumeSession {
	if (self.token) {
		TTURLRequest* request = [TTURLRequest requestWithURL:[self.loadProfileURL absoluteString] delegate:self];
		request.cachePolicy = TTURLRequestCachePolicyNone;
		request.response = [[[TTURLJSONResponse alloc] init] autorelease];
		[request sendSynchronously];
	}
}

- (void)digestProfileInfo:(NSDictionary*)profileInfo {
	if (profileInfo && [profileInfo isKindOfClass:[NSDictionary class]]) {
		if ([[profileInfo valueForKey:@"response"] isEqualToString:@"error"]) {
				NSLog(@"Error Logging In: %@", profileInfo);
				return;
		}
		if ([profileInfo valueForKey:@"user"]) {
			profileInfo = [profileInfo valueForKey:@"user"];
		}
		self.UID = [profileInfo objectForKey:@"uid"];
		self.username = [profileInfo objectForKey:@"displayName"];
		self.gender = [profileInfo objectForKey:@"gender"];
		self.city = [profileInfo objectForKey:@"city"];
		self.state = [profileInfo objectForKey:@"state"];
		self.email = [profileInfo objectForKey:@"email"];
        self.profileIconURL = [profileInfo objectForKey:@"profileIcon"];
		self.emailAlertSetting = [NSNumber numberWithInt:[[profileInfo objectForKey:@"emailPreference"] intValue]]; // comes back as a string
		self.aboutMe = [profileInfo objectForKey:@"about"];
		self.iphonePush = [[profileInfo objectForKey:@"iphonePush"] boolValue]; // comes back as string
		self.services = [profileInfo objectForKey:@"service"];
		
		// Reauthentication requests do not include the token back
		NSString* gtioToken = [profileInfo objectForKey:@"gtioToken"];
		if (gtioToken) {
			self.token = gtioToken;
		}		
		
		// Track new user logins
		if ([[profileInfo objectForKey:@"isNewUser"] boolValue]) {
			TTOpenURL(@"gtio://analytics/trackUserDidLoginForTheFirstTime");
		}
		
		if ([[profileInfo objectForKey:@"requiredFinishProfile"] boolValue]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidLoginWithIncompleteProfileNotificationName object:self];
		} else {
			self.loggedIn = YES;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidUpdateProfileNotificationName object:self];
	}
}


- (NSString*)firstName {
    NSArray* parts = [self.username componentsSeparatedByString:@" "];
    return [parts objectAtIndex:0];
}

- (NSString*)lastInitial {
	NSArray* parts = [self.username componentsSeparatedByString:@" "];
	if ([parts count] >= 2) {
        if ([parts lastObject]) {
            return [[parts lastObject] substringToIndex:1];
        }
	}
	return @"";
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* profileInfo = response.rootObject;
	[self digestProfileInfo:profileInfo];
}

- (void)setLoggedIn:(BOOL)loggedIn {
	if (_loggedIn != loggedIn) {
		_loggedIn = loggedIn;
		
		// Post login/logout Notifications
		if (loggedIn) {
			TTOpenURL(@"gtio://analytics/trackUserDidLogin");
			[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidLoginNotificationName object:self];
		} else {
			TTOpenURL(@"gtio://analytics/trackUserDidLogout");
			[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidLogoutNotificationName object:self];
		}
	}
}

- (NSString*)token {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kGTIOTokenUserDefaultsKey];
}

- (void)setToken:(NSString *)token {
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:kGTIOTokenUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isRegisteredWithFacebook {
	return [self.services containsObject:@"Facebook"];
}

- (BOOL)isRegisteredWithTwitter {
	return [self.services containsObject:@"Twitter"];
}

#pragma mark URL's

- (NSString*)deviceTokenURLEncoded {
	return [self.deviceToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL*)profileURL {
	NSString* string = [NSString stringWithFormat:@"%@/?page=profile&gtioToken=%@", kGTIOBaseURLString, self.token];
	return [NSURL URLWithString:string];
}

- (NSURL*)profileURLForOutfitID:(NSString*)outfitID {
	NSString* string = [NSString stringWithFormat:@"%@/?page=profile&gtioToken=%@&o=%@", kGTIOBaseURLString, self.token, outfitID];
	return [NSURL URLWithString:string];
}

- (NSURL*)updateProfileURL {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/user/")]];
}

- (NSURL*)getAnOpinionURL {
	NSString* string = [NSString stringWithFormat:@"%@/?page=recent&gtioToken=%@", kGTIOBaseURLString, self.token];
	return [NSURL URLWithString:string];
}

- (NSURL*)getAnOpinionURLForOutfitID:(NSString*)outfitID {
	NSString* string = [NSString stringWithFormat:@"%@/?page=recent&gtioToken=%@&o=%@", kGTIOBaseURLString, self.token, outfitID];
	return [NSURL URLWithString:string];
}

- (NSURL*)loadProfileURL {
	NSString* loadProfileURL = [NSString stringWithFormat:@"%@%@?gtioToken=%@", kGTIOBaseURLString, GTIORestResourcePath(@"/user"), self.token];
	if (self.deviceToken) {
		loadProfileURL = [loadProfileURL stringByAppendingFormat:@"&deviceToken=%@", [self deviceTokenURLEncoded]];
	}
	return [NSURL URLWithString:loadProfileURL];
}

- (NSURL*)logoutURL {
	NSString* string = [NSString stringWithFormat:@"%@%@?gtioToken=%@", kGTIOBaseURLString, GTIORestResourcePath(@"/logout"), self.token];
	return [NSURL URLWithString:string];
}

// Returns the token URL used for authentication with JanRain as a URL. The Device ID needed for push
// notifications is interpolated into the query params when present.
// See the app delegate for population of deviceToken value
- (NSURL*)authURL {
	NSString* authURL = [NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/auth/")];
	return [NSURL URLWithString:authURL];
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Profile Info: %@", [response bodyAsString]);
    [self digestProfileInfo:[response bodyAsJSON]];
    [self didStopLogin];
}

- (void)request:(RKRequest*)request didFailLoadWithError:(NSError*)error {
    [self didStopLogin];
    [self clearUserData];
}

#pragma mark FBSessionDelegate

- (void)fbDidLogin {
    NSLog(@"Logged in: %@", [_facebook accessToken]);
    NSString* url = [NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/auth")];
    RKRequest* request = [RKRequest requestWithURL:[NSURL URLWithString:url] delegate:self];
    request.method = RKRequestMethodPOST;
    request.params = [NSDictionary dictionaryWithObjectsAndKeys:[_facebook accessToken], @"fbToken", nil];
    
    [request send];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    [self didStopLogin];
    [self clearUserData];
	[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidCancelLoginNotificationName object:self];	
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    [self clearUserData];
    [self setLoggedIn:NO];
}

#pragma mark JRAuthenticateDelegate

- (void)jrAuthenticationDidReachTokenUrl:(NSString*)tokenUrl withResponse:(NSURLResponse*)response andPayload:(NSData*)tokenUrlPayload forProvider:(NSString*)provider {
	SBJsonParser* jsonParser = [SBJsonParser new];
    NSString* tokenUrlPayloadString = [[[NSString alloc] initWithData:tokenUrlPayload encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary* profileInfo = (NSDictionary*) [jsonParser objectWithString:tokenUrlPayloadString];
    [self digestProfileInfo:profileInfo];
	[jsonParser release];
    [self didStopLogin];
}

- (void)jrEngageDialogDidFailToShowWithError:(NSError*)error {
    [self didStopLogin];
	[self clearUserData];
}

- (void)jrAuthenticationDidFailWithError:(NSError*)error forProvider:(NSString*)provider {
    [self didStopLogin];
    [self clearUserData];
}

- (void)jrAuthenticationCallToTokenUrl:(NSString*)tokenUrl didFailWithError:(NSError*)error forProvider:(NSString*)provider {
    [self didStopLogin];
	[self clearUserData];
}

- (void)jrAuthenticationDidNotComplete {
    [self didStopLogin];
	[self clearUserData];
	[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidCancelLoginNotificationName object:self];	
}

@end
