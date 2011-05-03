//
//  GTIOProfile.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfile.h"


@implementation GTIOProfile

@synthesize badges = _badges;
@synthesize reviewsOutfits = _reviewsOutfits;
@synthesize badgeImageURLs = _badgeImageURLs;
@synthesize outfits = _outfits;
@synthesize uid = _uid;
@synthesize auth = _auth;
@synthesize displayName = _displayName;
@synthesize firstName = _firstName;
@synthesize lastInitial = _lastInitial;
@synthesize gender = _gender;
@synthesize city = _city;
@synthesize state = _state;
@synthesize location = _location;
@synthesize aboutMe = _aboutMe;
@synthesize isAuthorizedUser = _isAuthorizedUser;
@synthesize userStats = _userStats;

- (void)dealloc {
	[_uid release];
	_uid = nil;
	[_auth release];
	_auth = nil;
	[_displayName release];
	_displayName = nil;
	[_firstName release];
	_firstName = nil;
	[_lastInitial release];
	_lastInitial = nil;
	[_gender release];
	_gender = nil;
	[_city release];
	_city = nil;
	[_state release];
	_state = nil;
	[_location release];
	_location = nil;
	[_aboutMe release];
	_aboutMe = nil;
	[_badgeImageURLs release];
	_badgeImageURLs = nil;
	[_isAuthorizedUser release];
	_isAuthorizedUser = nil;
	[_userStats release];
	_userStats = nil;

	[_outfits release];
	_outfits = nil;

	[_reviewsOutfits release];
	_reviewsOutfits = nil;

	[_badges release];
	_badges = nil;

	[super dealloc];
}

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			 @"uid", @"uid",
			 @"auth", @"auth",
			 @"displayName", @"displayName",
			 @"firstName", @"firstName",
			 @"lastInitial", @"lastInitial",
			 @"gender", @"gender",
			 @"city", @"city",
			 @"state", @"state",
			 @"location", @"location",
			 @"aboutMe", @"aboutMe",
			 @"badgeURLs", @"badgeImageURLs",
			 @"isAuthorizedUser", @"isAuthorizedUser",
			 @"userStats", @"userStats", nil];
}

+ (NSDictionary*)elementToRelationshipMappings {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"outfits", @"outfits",
			@"reviewsOutfits", @"reviewsOutfits",
			@"badges", @"badges", nil];
}

@end
