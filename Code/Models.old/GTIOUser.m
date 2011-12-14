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
#import "GTIOAnalyticsTracker.h"
#import "GTIOJanrainAuthenticationController.h"
#import "NSObject_Additions.h"
#import "GTIONotification.h"
#import "GTIOBadge.h"
#import "GTIOAppStatusAlertButton.h"
#import "GTIOGlobalVariableStore.h"
#import "GTIOChangeItReason.h"

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

NSString* const kGTIONotificationsUpdatedNotificationName = @"kGTIONotificationsUpdatedNotification";
NSString* const kGTIOToDoBadgeUpdatedNotificationName = @"kGTIOToDoBadgeUpdatedNotification";

// Global current User instance
static GTIOUser* gCurrentUser = nil;

@interface GTIOUser (Private)

- (void)clearToken;

@end

@implementation GTIOUser

@synthesize iphonePush = _iphonePush;
@synthesize alertActivity = _alertActivity;
@synthesize alertStylistActivity = _alertStylistActivity;
@synthesize alertStylistAdd = _alertStylistAdd;
@synthesize alertNewsletter = _alertNewsletter;
@synthesize istyleCount = _istyleCount;
@synthesize stylistsCount = _stylistsCount;
@synthesize aboutMe = _aboutMe;
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
@synthesize location = _location;
@synthesize badges = _badges;
@synthesize alert = _alert;
@synthesize showAlmostDoneScreen = _showAlmostDoneScreen;
@synthesize auth = _auth;
@synthesize notifications = _notifications;
@synthesize todosBadge = _todosBadge;
@synthesize isFacebookConnected = _isFacebookConnected;
@synthesize bornIn = _bornIn;
@synthesize stylistsQuickLook = _stylistsQuickLook;

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOOutfitVoteNotification object:outfitID];
    return loader;
}

+ (RKObjectMapping*)userMapping {
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[GTIOUser class]];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.uid", @"UID")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.displayName", @"username")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.gender", @"gender")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.city", @"city")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.state", @"state")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.email", @"email")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.profileIcon", @"profileIconURL")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.aboutMe", @"aboutMe")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.iphonePush", @"iphonePush")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.alertActivity", @"alertActivity")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.alertStylistActivity", @"alertStylistActivity")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.alertStylistAdd", @"alertStylistAdd")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.alertNewsletter", @"alertNewsletter")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.services", @"services")]; // service?
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.gtioToken", @"token")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.isFacebookConnected", @"isFacebookConnected")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.location", @"location")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.stylistsCount", @"stylistsCount")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.istyleCount", @"istyleCount")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.showAlmostDoneScreen", @"showAlmostDoneScreen")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.bornIn", @"bornIn")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"user.auth", @"auth")];
    [userMapping addAttributeMapping:RKObjectAttributeMappingMake(@"todosBadge", @"todosBadge")];
    [userMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"user.stylistsQuickLook" toKeyPath:@"stylistsQuickLook" withMapping:[GTIOStylistsQuickLook qlMapping]]];
    
    // TODO: duplicated
    RKObjectMapping* badgeMapping = [RKObjectMapping mappingForClass:[GTIOBadge class]];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"type", @"type")];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"since", @"since")];
    [badgeMapping addAttributeMapping:RKObjectAttributeMappingMake(@"imgURL", @"imgURL")];
    
    RKObjectMapping* notificationMapping = [GTIONotification notificationMapping];
    [userMapping mapRelationship:@"notifications" withMapping:notificationMapping];
    
    RKObjectMapping* buttonMapping = [RKObjectMapping mappingForClass:[GTIOAppStatusAlertButton class]];
    [buttonMapping addAttributeMapping:RKObjectAttributeMappingMake(@"title", @"title")];
    [buttonMapping addAttributeMapping:RKObjectAttributeMappingMake(@"url", @"url")];
    
    RKObjectMapping* alertMapping = [RKObjectMapping mappingForClass:[GTIOAppStatusAlert class]];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"title", @"title")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"message", @"message")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"cancelButtonTitle", @"cancelButtonTitle")];
    [alertMapping addAttributeMapping:RKObjectAttributeMappingMake(@"id", @"alertID")];
    [alertMapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"buttons" toKeyPath:@"buttons" withMapping:buttonMapping]];
    
    RKObjectMapping* changeItReasonsMapping = [RKObjectMapping mappingForClass:[GTIOChangeItReason class]];
    [changeItReasonsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"id", @"reasonID")];
    [changeItReasonsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"display", @"display")];
    [changeItReasonsMapping addAttributeMapping:RKObjectAttributeMappingMake(@"text", @"text")];
    //[provider setMapping:changeItReasonsMapping forKeyPath:@"global_changeItReasons"];
    [userMapping mapKeyPath:@"global_changeItReasons" toRelationship:@"changeItReasons" withMapping:changeItReasonsMapping];
    
    RKObjectMapping* eventTypesMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [eventTypesMapping addAttributeMapping:RKObjectAttributeMappingMake(@"", @"eventType")];
    //[provider setMapping:eventTypesMapping forKeyPath:@"global_eventTypes"];
    [userMapping mapKeyPath:@"global_eventTypes" toRelationship:@"eventTypes" withMapping:eventTypesMapping];
    
    [userMapping mapRelationship:@"alert" withMapping:alertMapping];
    [userMapping mapKeyPath:@"user.badges" toRelationship:@"badges" withMapping:badgeMapping];
    userMapping.setDefaultValueForMissingAttributes = NO;
    userMapping.setNilForMissingRelationships = NO;
    
    return userMapping;
}

+ (NSString*)appVersionString {
	NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    return versionString;
}

- (id)init {
	if (self = [super init]) {
		_loggedIn = NO;
	}
	
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_showAlmostDoneScreen);
	TT_RELEASE_SAFELY(_UID);
	TT_RELEASE_SAFELY(_username);
	TT_RELEASE_SAFELY(_gender);
	TT_RELEASE_SAFELY(_city);
	TT_RELEASE_SAFELY(_state);
	TT_RELEASE_SAFELY(_email);
	TT_RELEASE_SAFELY(_aboutMe);
	TT_RELEASE_SAFELY(_deviceToken);
	TT_RELEASE_SAFELY(_services);
	TT_RELEASE_SAFELY(_eventTypes);
    TT_RELEASE_SAFELY(_facebook);
    TT_RELEASE_SAFELY(_notifications);
    TT_RELEASE_SAFELY(_todosBadge);
    TT_RELEASE_SAFELY(_iphonePush);
    TT_RELEASE_SAFELY(_alertActivity);
    TT_RELEASE_SAFELY(_alertStylistActivity);
    TT_RELEASE_SAFELY(_alertStylistAdd);
    TT_RELEASE_SAFELY(_alertNewsletter);
    TT_RELEASE_SAFELY(_stylistsCount);
    TT_RELEASE_SAFELY(_istyleCount);
    TT_RELEASE_SAFELY(_isFacebookConnected);
    TT_RELEASE_SAFELY(_bornIn);
    TT_RELEASE_SAFELY(_auth);
	[super dealloc];
}

- (void)digestProfileInfo:(NSDictionary*)profileInfo {
    RKObjectMappingOperation* operation = [RKObjectMappingOperation mappingOperationFromObject:profileInfo toObject:self withMapping:[GTIOUser userMapping]];
//    operation.objectFactory = [[RKObjectMapper new] autorelease];
    NSError* error = nil;
    if (![operation performMapping:&error]) {
        NSLog(@"Error: %@", error);
        GTIOErrorMessage(error);
    }
    
    // TODO: clean this crap up.
    if ([[profileInfo valueForKey:@"user.isNewUser"] boolValue]) {
        TTOpenURL(@"gtio://analytics/trackUserDidLoginForTheFirstTime");
    }
    
    if ([GTIOUser currentUser].token != nil) {
        self.loggedIn = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidUpdateProfileNotificationName object:self];
}

- (void)setEventTypes:(NSArray*)eventTypes {
    eventTypes = [eventTypes valueForKey:@"eventType"];
    [eventTypes retain];
    [_eventTypes release];
    _eventTypes = eventTypes;
}

- (NSArray*)changeItReasons {
    return [GTIOGlobalVariableStore sharedStore].changeItReasons;
}

- (void)setChangeItReasons:(NSArray*)reasons {
    [GTIOGlobalVariableStore sharedStore].changeItReasons = reasons;
}

- (void)setTodosBadge:(NSNumber*)number {
    if ([number isKindOfClass:[NSString class]]) {
        number = [NSNumber numberWithInt:[number intValue]];
    }
    [number retain];
    [_todosBadge release];
    _todosBadge = number;
    [UIApplication sharedApplication].applicationIconBadgeNumber = [_todosBadge intValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOToDoBadgeUpdatedNotificationName object:self];
}

- (void)setNotifications:(NSArray*)notifications {
    [notifications retain];
    [_notifications release];
    _notifications = notifications;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIONotificationsUpdatedNotificationName object:self];
}

- (void)setAlert:(GTIOAppStatusAlert*)alert {
    [alert retain];
    [_alert release];
    _alert = alert;
    [_alert show];
}

- (void)markNotificationAsSeen:(GTIONotification*)note {
    NSMutableArray* seenIDs = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationIDs"] mutableCopy] autorelease];
    if (nil == seenIDs) {
        seenIDs = [NSMutableArray array];
    }
    if (![seenIDs containsObject:note.notificationID]) {
        [seenIDs addObject:note.notificationID];
        [[NSUserDefaults standardUserDefaults] setObject:seenIDs forKey:@"notificationIDs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIONotificationsUpdatedNotificationName object:self];
    }
}

-(BOOL)hasSeenNotification:(GTIONotification*)note {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationIDs"] containsObject:note.notificationID];
}


- (NSUInteger)numberOfUnseenNotifications {
    NSUInteger count = 0;
    for (GTIONotification* notification in self.notifications) {
        if (![self hasSeenNotification:notification]) {
            count++;
        }
    }
    return count;
}

- (void)didStartLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidBeginLoginProcess object:self];
}

- (void)didStopLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidEndLoginProcess object:self];
}

- (void)loginWithFacebook {
    [self didStartLogin];
    _facebook = [[Facebook alloc] initWithAppId:kGTIOFacebookAppID andDelegate:self];
    NSArray* permissions = [NSArray arrayWithObjects:@"publish_stream", @"offline_access", @"email", @"user_birthday", @"user_location", nil];
    [_facebook authorize:permissions];
}

- (BOOL)resumeFacebookSession {
    _facebook = [[Facebook alloc] initWithAppId:kGTIOFacebookAppID andDelegate:self];
    _facebook.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:kGTIOFacebookAuthToken];
    _facebook.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:kGTIOFacebookExpirationToken];
    return [_facebook isSessionValid];
}

- (void)loginWithJanRain {
    [self didStartLogin];
    TTOpenURL(@"gtio://analytics/trackUserDidViewLoginOtherProviders");
	if (NO == self.isLoggedIn) {
		[GTIOJanrainAuthenticationController showAuthenticationDialog];
	}
}

- (void)clearUserData {	
	self.UID = nil;
	[self clearToken];
	self.username = nil;
	self.gender = nil;
	self.city = nil;
	self.state = nil;
	self.email = nil;
	self.services = nil;
	self.iphonePush = nil;
    self.alertActivity = nil;
    self.alertStylistActivity = nil;
    self.alertStylistAdd = nil;
    self.alertNewsletter = nil;
	self.loggedIn = NO;
    self.profileIconURL = nil;
    self.notifications = nil;
    self.todosBadge = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notificationIDs"];
}

- (void)logout {
    NSString* path = [NSString stringWithFormat:@"%@?gtioToken=%@", GTIORestResourcePath(@"/logout"), self.token];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:nil];
    
    [loader sendSynchronously];
    
	[self clearUserData];
}

- (void)resumeSession {
    RKObjectMapping* userMapping = [GTIOUser userMapping];
    
    NSString* path = [NSString stringWithFormat:@"%@?iphoneAppVersion=%@&gtioToken=%@", GTIORestResourcePath(@"/auth"), [GTIOUser appVersionString], self.token];
    if (self.deviceToken) {
        path = [path stringByAppendingFormat:@"&deviceToken=%@", [self deviceTokenURLEncoded]];
    }
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:path delegate:self];
    loader.targetObject = self;
    loader.objectMapping = userMapping;
    
    [loader send];
}

- (NSString*)displayName {
    return _username;
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

- (void)clearToken {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kGTIOTokenUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setToken:(NSString *)token {
    if (nil != token) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:kGTIOTokenUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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

- (void)handleLoginFailedButTokenNotInvalid {
    self.loggedIn = YES;
}

#pragma mark RKRequestDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Objects: %@", objects);
    NSLog(@"Quick Look: %@", self.stylistsQuickLook);
    //NSLog(@"Log: %@", [objectLoader.response bodyAsString]);
    [self didStopLogin];
    
    if (self.UID) {
        self.loggedIn = YES;
    } else if ([self.auth boolValue] == false) {
        [self didStopLogin];
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidLogoutNotificationName object:self];
    } else {
        // unknown state.
        [self handleLoginFailedButTokenNotInvalid];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidUpdateProfileNotificationName object:self];
}

- (void)objectLoader:(RKObjectLoader*)loader didFailWithError:(NSError*)error {
    GTIOErrorMessage(error);    
    [self didStopLogin];
//    [self clearUserData];
//    self.loggedIn = YES;
    [self handleLoginFailedButTokenNotInvalid];
}

#pragma mark FBSessionDelegate

- (void)fbDidLogin {
    GTIOAnalyticsEvent(kUserAddedFacebook);
    NSString* url = GTIORestResourcePath(@"/auth");
    
    [[NSUserDefaults standardUserDefaults] setValue:[_facebook accessToken] forKey:kGTIOFacebookAuthToken];
    [[NSUserDefaults standardUserDefaults] setValue:[_facebook expirationDate] forKey:kGTIOFacebookExpirationToken];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[_facebook accessToken], @"fbToken",
//                            [self deviceTokenURLEncoded], @"deviceToken",
                            [GTIOUser appVersionString], @"iphoneAppVersion", nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
    
    RKObjectMapping* userMapping = [GTIOUser userMapping];
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderWithResourcePath:url delegate:self];
    loader.targetObject = self;
    loader.params = params;
    loader.method = RKRequestMethodPOST;
    loader.objectMapping = userMapping;
    
    [loader send];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    [self didStopLogin];
    [self clearUserData];
	[[NSNotificationCenter defaultCenter] postNotificationName:kGTIOUserDidCancelLoginNotificationName object:self];	
    if (cancelled == NO) {
        GTIOAlert(@"Login Failed");
    }
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
