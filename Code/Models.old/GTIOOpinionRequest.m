//
//  GTIOOpinionRequest.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
//
//  manages data to submit a look or looks to GTIO see [GTIOOpinionRequestSession](GTIOOpinionRequestSession)
//

#import "GTIOOpinionRequest.h"
#import "GTIOPhoto.h"

@implementation GTIOOpinionRequest

@synthesize photos = _photos;
@synthesize isPublic = _isPublic;
@synthesize shareWithStylists = _shareWithStylists;
@synthesize contactEmails = _contactEmails;
@synthesize whereYouAreGoing = _whereYouAreGoing;
@synthesize tellUsMoreAboutIt = _tellUsMoreAboutIt;

- (id)init {
	if (self = [super init]) {
		_photos = [[NSMutableArray alloc] init];
		_contactEmails = [[NSMutableArray alloc] init];
		_isPublic = YES;
		_shareWithStylists = YES;
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
	[coder encodeBool:_isPublic forKey:@"isPublic"];
	[coder encodeBool:_shareWithStylists forKey:@"shareWithStylists"];
}

- (id)initWithCoder:(NSCoder *)coder {    	
    if (self = [self init]) {
        _contactEmails = [[coder decodeObjectForKey:@"contactEmails"] retain];
		self.isPublic = [coder decodeBoolForKey:@"isPublic"];
		self.shareWithStylists = [coder decodeBoolForKey:@"shareWithStylists"];
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
    GTIOUser* user = [GTIOUser currentUser];
	return [user.eventTypes valueForKeyPath:@"type"];
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
            [self isPublic] ? @"true" : @"false", @"public",
            [self shareWithStylists] ? @"true" : @"false", @"shareWithStylists",
            [NSString stringWithFormat:@"%d", [[self photos] count]], @"photoCount",
			[self wasBlurAppliedToAnyPhoto] ? @"true" : @"false", @"blurMask",
            nil];
}

@end
