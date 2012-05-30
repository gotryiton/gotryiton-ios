//
//  GTIOEnvironment.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

/** Go Try It On Build Environments
 *
 *  Environment can be set as a build setting by defining a GCC Preprocessor Macro
 *  value within the Xcode Configuration. Defaults to production when not
 *  defined.
 */
#define GTIO_ENVIRONMENT_DEVELOPMENT 1
#define GTIO_ENVIRONMENT_STAGING 2
#define GTIO_ENVIRONMENT_PRODUCTION 3

// The environment we are running within (i.e. staging/production)
extern NSString * const kGTIOEnvironmentName;
extern NSString * const kGTIOBaseURLString;

// JanRain  (used for authentication via Engage)
extern NSString * const kGTIOJanRainEngageApplicationID;
extern NSString * const kGTIOJanRainProviderAol;
extern NSString * const kGTIOJanRainProviderGoogle;
extern NSString * const kGTIOJanRainProviderTwitter;
extern NSString * const kGTIOJanRainProviderYahoo;

// Facebook
extern NSString * const kGTIOFacebookAppID;

// Logging
extern NSUInteger const kGTIONetworkLogLevel;
extern NSUInteger const kGTIOLogLevel;

// RestKit Auth
extern NSString * const kGTIOHTTPAuthUsername;
extern NSString * const kGTIOHTTPAuthPassword;

// RestKit 
extern NSString * const kGTIOAcceptHeader;
extern NSString * const kGTIOAuthenticationHeaderKey;
extern NSString * const kGTIOTrackingHeaderKey;

// JSON Param Serialization Helper
id GTIOJSONParams(id obj);