//
//  GTIOEnvironment.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

/**
 * Go Try It On Build Environments
 *
 * Environment can be set as a build setting by defining a GCC Preprocessor Macro
 * value within the Xcode Configuration. Defaults to production when not
 * defined.
 */
#define GTIO_ENVIRONMENT_DEVELOPMENT 1
#define GTIO_ENVIRONMENT_STAGING 2
#define GTIO_ENVIRONMENT_PRODUCTION 3

#ifndef GTIO_ENVIRONMENT
#define GTIO_ENVIRONMENT GTIO_ENVIRONMENT_PRODUCTION
#endif

/**
 * General Constants
 */

// The name of the environment we are running within (i.e. staging/production)
extern NSString* const kGTIOEnvironmentName;

// The base URL of the remote server we are talking to
extern NSString* const kGTIOBaseURLString;

/**
 * JanRain Engage
 */

// The JanRain application ID (used for authentication via Engage)
extern NSString* const kGTIOJanRainEngageApplicationID;

// The JanRain token URL to hit during authentication
extern NSString* const kGTIOJanRainEngageTokenURLString;


// The Flurry API Key
extern NSString* const kGTIOFlurryAPIKey;

NSString* GTIORestResourcePath(NSString* string);
