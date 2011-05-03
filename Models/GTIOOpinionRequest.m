//
//  GTIOOpinionRequest.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOpinionRequest.h"
#import "GTIOPhoto.h"

@implementation GTIOOpinionRequest

@synthesize photos = _photos;
@synthesize shareWithContacts = _shareWithContacts;
@synthesize shareOnFacebook = _shareOnFacebook;
@synthesize shareOnTwitter = _shareOnTwitter;
@synthesize alertMeWithFeedback = _alertMeWithFeedback;
@synthesize isPrivate = _isPrivate;
@synthesize contactEmails = _contactEmails;
@synthesize whereYouAreGoing = _whereYouAreGoing;
@synthesize tellUsMoreAboutIt = _tellUsMoreAboutIt;

- (id)init {
	if (self = [super init]) {
		_photos = [[NSMutableArray alloc] init];
		_contactEmails = [[NSMutableArray alloc] init];
		_shareWithContacts = NO;
		_shareOnFacebook = NO;
		_shareOnTwitter = NO;
		_alertMeWithFeedback = NO;
		_isPrivate = NO;
	}
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_photos);
	TT_RELEASE_SAFELY(_contactEmails);
	TT_RELEASE_SAFELY(_whereYouAreGoing);
	TT_RELEASE_SAFELY(_tellUsMoreAboutIt);

	[super dealloc];
}

#pragma mark NSCoding methods

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_contactEmails forKey:@"contactEmails"];
	[coder encodeBool:_shareWithContacts forKey:@"shareWithContacts"];
	[coder encodeBool:_shareOnFacebook forKey:@"shareOnFacebook"];
	[coder encodeBool:_shareOnTwitter forKey:@"shareOnTwitter"];
	[coder encodeBool:_alertMeWithFeedback forKey:@"alertMeWithFeedback"];
}

- (id)initWithCoder:(NSCoder *)coder {    	
    if (self = [self init]) {
        _contactEmails = [[coder decodeObjectForKey:@"contactEmails"] retain];
		self.shareWithContacts = [coder decodeBoolForKey:@"shareWithContacts"];
		self.shareOnFacebook = [coder decodeBoolForKey:@"shareOnFacebook"];
		self.shareOnTwitter = [coder decodeBoolForKey:@"shareOnTwitter"];
		self.alertMeWithFeedback = [coder decodeBoolForKey:@"alertMeWithFeedback"];
    }   
	
    return self;
}

- (BOOL)canAddAnotherPhoto {
	return [self.photos count] < 4;
}

- (BOOL)isValid {
	return (([self.photos count] > 0 && [self.photos count] <= 4) &&
			(nil != self.whereYouAreGoing) &&
			(0 != [self.tellUsMoreAboutIt length]));
}

- (NSArray*)validationErrors {
	NSMutableArray* validationErrors = [NSMutableArray arrayWithCapacity:3];
	if (0 == [self.photos count]) {
		[validationErrors addObject:@"include at least one photo"];
	}
	
	if (nil == self.whereYouAreGoing) {
		[validationErrors addObject:@"tell us where you're going"];
	}
	
	if (0 == [self.tellUsMoreAboutIt length]) {
		[validationErrors addObject:@"tell us more about your outfit"];
	}
	
	return [NSArray arrayWithArray:validationErrors];
}

- (NSString*)validationErrorsSummary {
	NSArray* validationErrors = [self validationErrors];
	NSMutableArray* errorsWithHyphens = [NSMutableArray arrayWithCapacity:[validationErrors count]];
	for (NSString* message in validationErrors) {
		[errorsWithHyphens addObject:[NSString stringWithFormat:@"- %@", message]];
	}
	
	return [errorsWithHyphens componentsJoinedByString:@"\n"];
}

- (NSArray*)whereYouAreGoingChoices {
	return [[GTIOUser currentUser].eventTypes valueForKeyPath:@"type"];
}

- (NSNumber*)indexForEventType:(NSString*)type {
	return [[[GTIOUser currentUser].eventTypes objectWithValue:type forKey:@"type"] valueForKeyPath:@"id"];
}

- (BOOL)wasBlurAppliedToAnyPhoto {
	for (GTIOPhoto* photo in _photos) {
		if ([photo blurApplied]) {
			return YES;
		}
	}
	
	return NO;
}

- (NSDictionary*)infoDict {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self isPrivate] ? @"true" : @"false", @"private",
            [self shareOnFacebook] ? @"true" : @"false", @"facebookShare",
            [NSString stringWithFormat:@"%d", [[self photos] count]], @"photoCount",
            [self shareOnTwitter] ? @"true" : @"false", @"shareOnTwitter",
			[self shareWithContacts] ? @"true" : @"false", @"shareWithContacts",
			[self wasBlurAppliedToAnyPhoto] ? @"true" : @"false", @"blurMask",
            nil];
}

@end
