//
//  GTIOEnvironment.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOEnvironment.h"

#import <RestKit/RestKit.h>
#import <RestKit/RKRequestSerialization.h>

/** Go Try It On Build Environments
 *
 *  These settings determine what server environment the client
 *  is communicating with
 */

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_DEVELOPMENT
    NSString * const kGTIOEnvironmentName = @"Development";
    NSString * const kGTIOBaseURLString = @"http://gtio-dev.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"125885160757300";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString * const kGTIOHTTPAuthUsername = @"tt";
    NSString * const kGTIOHTTPAuthPassword = @"toast";
#endif 

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
    NSString * const kGTIOEnvironmentName = @"Staging";
    NSString * const kGTIOBaseURLString = @"http://stage.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"125885160757300";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelTrace;
    NSUInteger const kGTIOLogLevel = RKLogLevelDebug;
    NSString* const kGTIOHTTPAuthUsername = @"tt";
    NSString* const kGTIOHTTPAuthPassword = @"toast";
#endif

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_PRODUCTION
    NSString * const kGTIOEnvironmentName = @"Production";
    NSString * const kGTIOBaseURLString = @"http://i.gotryiton.com";
    NSString * const kGTIOJanRainEngageApplicationID = @"iligdiaplfgbmhcpebgf";
    NSString * const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString * const kGTIOFacebookAppID = @"126454074038555";
    NSUInteger const kGTIONetworkLogLevel = RKLogLevelError;
    NSUInteger const kGTIOLogLevel = RKLogLevelError;
    NSString * const kGTIOHTTPAuthUsername = nil;
    NSString * const kGTIOHTTPAuthPassword = nil;
#endif

NSString * const kGTIOAcceptHeader = @"application/v4-json";
NSString * const kGTIOAuthenticationHeaderKey = @"Authentication";
NSString * const kGTIOTrackingHeaderKey = @"Tracking-Id";

/* janrain providers */
NSString * const kGTIOJanRainProviderAol = @"aol";
NSString * const kGTIOJanRainProviderGoogle = @"google";
NSString * const kGTIOJanRainProviderTwitter = @"twitter";
NSString * const kGTIOJanRainProviderYahoo = @"yahoo";

NSString * const kGTIOLooksUpdated = @"kGTIOLooksUpdated";

NSString * const kGTIOUserInfoButtonNameFollowing = @"following";
NSString * const kGTIOUserInfoButtonNameFollowers = @"followers";
NSString * const kGTIOUserInfoButtonNameStars = @"stars";
NSString * const kGTIOUserInfoButtonNameWebsite = @"website-button";
NSString * const kGTIOUserInfoButtonNameFollow = @"follow-button";
NSString * const kGTIOUserInfoButtonNameBannerAd = @"banner-ad";
NSString * const kGTIOUserInfoButtonNameAcceptRelationship = @"accept-relationship-button";
NSString * const kGTIOPostSideReviewsButton = @"post-side-reviews-button";
NSString * const kGTIOPostSideShopButton = @"post-side-shop-button";
NSString * const kGTIOPostDotOptionButton = @"post-dot-option-button";

int const kGTIOEmptyPostAlertTag = 0;
int const kGTIOEmptyDescriptionAlertTag = 1;

#pragma mark - JSON Params Serialization Helper

id GTIOJSONParams(id obj) {
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeJSON];
    NSError *error = nil;
    NSString *json = [parser stringFromObject:obj error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return [RKRequestSerialization serializationWithData:[json dataUsingEncoding:NSUTF8StringEncoding] MIMEType:RKMIMETypeJSON];
}