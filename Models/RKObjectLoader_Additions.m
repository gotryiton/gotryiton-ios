//
//  RKObjectLoader_Additions.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

- (void)didFinishLoad:(RKResponse*)response {
	_response = [response retain];
	
	if ([_delegate respondsToSelector:@selector(request:didLoadResponse:)]) {
		[_delegate request:self didLoadResponse:response];
	}
	
	if (NO == [self encounteredErrorWhileProcessingRequest:response]) {
		// TODO: When other mapping formats are supported, unwind this assumption...
		if ([response isSuccessful] && [response isJSON]) {
			NSError* error = [self errorForSuccessfulResponse:response];
			if (error) {
				[self didFailLoadWithError:error];
				return;
			}
			[self performSelectorInBackground:@selector(processLoadModelsInBackground:) withObject:response];
		} else {
			NSLog(@"Encountered unexpected response code: %d (MIME Type: %@)", response.statusCode, response.MIMEType);
			if ([_delegate respondsToSelector:@selector(objectLoaderDidLoadUnexpectedResponse:)]) {
				[(NSObject<RKObjectLoaderDelegate>*)_delegate objectLoaderDidLoadUnexpectedResponse:self];
			}
			[self responseProcessingSuccessful:NO withError:nil];
		}
	}
}


@end
