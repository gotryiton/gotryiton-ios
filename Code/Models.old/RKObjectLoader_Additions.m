//
//  RKObjectLoader_Additions.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKObjectLoader_Additions.h"

@interface RKObjectLoader (PrivateAdditions)

- (BOOL)encounteredErrorWhileProcessingRequest:(RKResponse*)response;
- (void)responseProcessingSuccessful:(BOOL)successful withError:(NSError*)error;

@end

@implementation RKObjectLoader (Additions)

- (NSError*)errorForSuccessfulResponse:(RKResponse*)response {
	NSDictionary* json = [response bodyAsJSON];
	if ([[json valueForKey:@"response"] isEqualToString:@"error"]) {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  [json valueForKey:@"message"], NSLocalizedDescriptionKey,
								  nil];
		NSError* error = [NSError errorWithDomain:@"com.gotryiton.ErrorDomain" code:0 userInfo:userInfo];
		return error;
	}
	return nil;
}

@end
