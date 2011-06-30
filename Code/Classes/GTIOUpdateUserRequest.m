//
//  GTIOUpdateUserRequest.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/30/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOUpdateUserRequest.h"


@implementation GTIOUpdateUserRequest

@synthesize error = _error;
@synthesize request = _request;
@synthesize delegate = _delegate;
@synthesize selector = _selector;

- (void)dealloc {
	TT_RELEASE_SAFELY(_request);
	TT_RELEASE_SAFELY(_delegate);
	TT_RELEASE_SAFELY(_error);

	[super dealloc];
}

+ (id)updateUser:(GTIOUser*)user delegate:(id)delegate selector:(SEL)selector {
	GTIOUpdateUserRequest* updateRequest = [[GTIOUpdateUserRequest new] autorelease];
	
	updateRequest.delegate = delegate;
	updateRequest.selector = selector;
	
	TTURLRequest* request = [TTURLRequest requestWithURL:[user.updateProfileURL absoluteString] delegate:updateRequest];
	[request setCachePolicy:TTURLRequestCachePolicyNone];
	request.response = [[TTURLDataResponse new] autorelease];
	[request setHttpMethod:@"POST"];
	[request.parameters setValue:user.token forKey:@"gtioToken"];
	[request.parameters setValue:user.firstName forKey:@"firstName"];
	[request.parameters setValue:user.lastInitial forKey:@"lastInitial"];
	[request.parameters setValue:user.city forKey:@"city"];
	[request.parameters setValue:user.state forKey:@"state"];
	[request.parameters setValue:user.gender forKey:@"gender"];
	[request.parameters setValue:user.email forKey:@"email"];
    [request.parameters setValue:user.profileIconURL forKey:@"profileIcon"];
	[request.parameters setValue:user.aboutMe forKey:@"aboutMe"];
	NSString* pushSetting = user.iphonePush ? @"1" : @"0";
	[request.parameters setValue:pushSetting forKey:@"iphonePush"];
    [request.parameters setValue:[user.bornIn stringValue] forKey:@"bornIn"];
	[request.parameters setValue:[user deviceTokenURLEncoded] forKey:@"deviceToken"];
	
	NSLog(@"User Params: %@", request.parameters);
	
	updateRequest.request = request;
	[updateRequest.request send];
	
	return updateRequest;
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	NSLog(@"User Name: %@", [GTIOUser currentUser].username);
//    NSLog(@"Response :%@", [[[NSString alloc] initWithData:[(TTURLDataResponse*)request.response data] encoding:NSUTF8StringEncoding] autorelease]);
	[_delegate performSelector:_selector withObject:self];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	self.error = error;
	[_delegate performSelector:_selector withObject:self];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
	[_delegate performSelector:_selector withObject:self];
}

@end
