//
//  GTIOEnvironment.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOEnvironment.h"

/**
 * Go Try It On Build Environments
 *
 * These settings determine what server environment the client
 * is communicating with
 */

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
	NSString* const kGTIOEnvironmentName = @"development";
	NSString* const kGTIOBaseURLString = @"http://gtio-dev.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"134143416622354";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString* const kGTIOHTTPAuthUsername = @"tt";
    NSString* const kGTIOHTTPAuthPassword = @"toast";
#endif 

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
	NSString* const kGTIOEnvironmentName = @"staging";
	NSString* const kGTIOBaseURLString = @"http://stage.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"134143416622354";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString* const kGTIOHTTPAuthUsername = @"tt";
    NSString* const kGTIOHTTPAuthPassword = @"toast";
#endif

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_PRODUCTION
	NSString* const kGTIOEnvironmentName = @"production";
	NSString* const kGTIOBaseURLString = @"http://i.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"iligdiaplfgbmhcpebgf";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"126454074038555";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelError;
    NSUInteger const kGTIOLogLevel = RKLogLevelError;
    NSString* const kGTIOHTTPAuthUsername = nil;
    NSString* const kGTIOHTTPAuthPassword = nil;
#endif

NSString* GTIORestResourcePath(NSString* string) {
	return [NSString stringWithFormat:@"/rest/v4%@", string];
}

NSUInteger const kGTIOPaginationLimit = 20;

NSString* const kGTIOFacebookAuthToken = @"kGTIOFacebookAuthToken";
NSString* const kGTIOFacebookExpirationToken = @"kGTIOFacebookExpirationToken";

NSString* const kGTIOOutfitVoteNotification = @"kGTIOOutfitVoteNotification";

NSString* const kGTIOSuggestionMadeNotification = @"kGTIOSuggestionMadeNotification";
NSString* const kGTIOProductNotificationKey = @"product";
NSString* const kGTIOProductWebViewController = @"webViewController";

RKObjectAttributeMapping* RKObjectAttributeMappingMake(NSString* keyPath, NSString* attribute) {
    return [RKObjectAttributeMapping mappingFromKeyPath:keyPath toKeyPath:attribute];
}

UIAlertView* errorAlertView = nil;

@interface GTIOErrorDelegate : NSObject
@end

@implementation GTIOErrorDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    errorAlertView = nil;
    [self autorelease];
}

@end

void GTIOErrorMessage(NSError* error) {
    if (errorAlertView) {
        // Already showing connection failure alert, don't show again.
        return;
    }
    RKReachabilityObserver* observer = [RKObjectManager sharedManager].client.reachabilityObserver;
    if (![observer isNetworkReachable]) {
        errorAlertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"no internet connection found!" delegate:[GTIOErrorDelegate new] cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    } else {
        errorAlertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"GO TRY IT ON central isn't responding right now." delegate:[GTIOErrorDelegate new] cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    }
    [errorAlertView show];
}

void GTIOAlert(NSString* message) {
    [[[[UIAlertView alloc] initWithTitle:@"GO TRY IT ON" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}