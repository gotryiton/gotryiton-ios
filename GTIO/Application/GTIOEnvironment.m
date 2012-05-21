//
//  GTIOEnvironment.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOEnvironment.h"

#import <RestKit/RestKit.h>

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
