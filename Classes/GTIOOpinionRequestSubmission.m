//
//  GTIOOpinionRequestSubmission.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOpinionRequestSubmission.h"
#import "TTURLJSONResponse.h"
#import "GTIOUser.h"
#import "GTIOPhoto.h"
#import "UIImage+Manipulation.h"

@implementation GTIOOpinionRequestSubmission

@synthesize opinionRequest = _opinionRequest;
@synthesize delegate = _delegate;
@synthesize outfitURL = _outfitURL;
@synthesize photosAdded = _photosAdded;
@synthesize totalPhotos = _totalPhotos;
@synthesize sid = _sid;

+ (GTIOOpinionRequestSubmission*)submissionWithOpinionRequest:(GTIOOpinionRequest*)opinionRequest delegate:(NSObject<GTIOOpinionRequestSubmissionDelegate>*)delegate {
	return [[[self alloc] initWithOpinionRequest:opinionRequest delegate:delegate] autorelease];
}

- (id)initWithOpinionRequest:(GTIOOpinionRequest*)opinionRequest delegate:(NSObject<GTIOOpinionRequestSubmissionDelegate>*)delegate {
	if (self = [self init]) {
		_opinionRequest = [opinionRequest retain];
		_delegate = [delegate retain];
	}
	
	return self;
}

- (void)dealloc {
	[_delegate release];
	[_opinionRequest release];
	[_outfitURL release];
	[_sid release];
	
	[super dealloc];
}

- (void)send {
	GTIOUser* user = [GTIOUser currentUser];
	NSString* URLString = [NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/upload/")];
	_request = [TTURLRequest requestWithURL:URLString delegate:self];
	_request.httpMethod = @"POST";
	_request.response = [[[TTURLJSONResponse alloc] init] autorelease];
	
	NSString* privateValue = self.opinionRequest.isPrivate ? @"-1" : @"1";
	NSString* facebookValue = self.opinionRequest.shareOnFacebook ? @"1" : @"0";
	NSString* twitterValue = self.opinionRequest.shareOnTwitter ? @"1" : @"0";
	
	[_request.parameters setValue:user.token forKey:@"gtioToken"];
	[_request.parameters setValue:self.opinionRequest.tellUsMoreAboutIt forKey:@"description"];
	[_request.parameters setValue:[self.opinionRequest.whereYouAreGoing stringValue] forKey:@"event"];
	[_request.parameters setValue:privateValue forKey:@"public"];
	[_request.parameters setValue:facebookValue forKey:@"updateFacebook"];
	[_request.parameters setValue:twitterValue forKey:@"updateTwitter"];
	
	if (_opinionRequest.shareWithContacts) {
		[_request.parameters setValue:[self.opinionRequest.contactEmails componentsJoinedByString:@", "] forKey:@"shareEmails"];
	}
	
	// Add the files & outfit details
	NSArray* photos = self.opinionRequest.photos;
	for (GTIOPhoto* photo in photos) {
		NSUInteger number = [photos indexOfObject:photo] + 1;
		NSString* fileParam = [NSString stringWithFormat:@"image%d", number];
		NSString* brandsParam = [NSString stringWithFormat:@"outfit%dBrands", number];
		
		// Scale image down to a max heigh tof 560px right before submission
		UIImage* image = photo.image;
		float scaleFactor = 560.0/image.size.height;
		UIImage* scaledImage = [image imageWithScale:scaleFactor];
		
		[_request.parameters setValue:scaledImage forKey:fileParam];
		[_request.parameters setValue:photo.brandsYouAreWearing forKey:brandsParam];
	}
	
	// Let's do this thing!
	[_request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* responseData = response.rootObject;
//	GTIOUser* user = [GTIOUser currentUser];
	
	if ([[responseData objectForKey:@"response"] isEqualToString:@"error"]) {
		NSString* errorMessage = [responseData objectForKey:@"error"];		
		[_delegate submission:self didFailWithErrorMessage:errorMessage];
	} else {		
		_photosAdded = [[responseData objectForKey:@"photosAdded"] intValue];
		_totalPhotos = [[responseData objectForKey:@"totalPhotos"] intValue];
		_sid = [[responseData objectForKey:@"sid"] retain];
		//NSString* URLString = [NSString stringWithFormat:@"%@/?page=profile&o=%@&gtioToken=%@", kGTIOBaseURLString, _sid, user.token];
		NSString* URLString = [NSString stringWithFormat:@"gtio://profile/look/%@", _sid];
		_outfitURL = [[NSURL URLWithString:URLString] retain];
		
		[_delegate submissionDidSucceed:self];
	}
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
	[_delegate submission:self didFailWithErrorMessage:[error localizedDescription]];
}

@end
