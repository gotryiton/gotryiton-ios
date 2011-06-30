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
	NSString* const kGTIOBaseURLString = @"http://www.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"134143416622354";
#endif 

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_STAGING
	NSString* const kGTIOEnvironmentName = @"staging";
	NSString* const kGTIOBaseURLString = @"http://iphonedev.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"***REMOVED***";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"134143416622354";
#endif

#if GTIO_ENVIRONMENT == GTIO_ENVIRONMENT_PRODUCTION
	NSString* const kGTIOEnvironmentName = @"production";
	NSString* const kGTIOBaseURLString = @"http://i.gotryiton.com";
	NSString* const kGTIOJanRainEngageApplicationID = @"iligdiaplfgbmhcpebgf";
    NSString* const kGTIOFlurryAPIKey = @"***REMOVED***";
    NSString* const kGTIOFacebookAppID = @"126454074038555";
#endif

NSString* GTIORestResourcePath(NSString* string) {
	return [NSString stringWithFormat:@"/rest/v3%@", string];
	//return [NSString stringWithFormat:@"/rest%@", string];
}

NSUInteger const kGTIOPaginationLimit = 20;

RKObjectAttributeMapping* RKObjectAttributeMappingMake(NSString* keyPath, NSString* attribute) {
    return [RKObjectAttributeMapping mappingFromKeyPath:keyPath toKeyPath:attribute];
}