//
//  GTIOProfile.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 Two Toasters. All rights reserved.
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
@synthesize profileIconURL = _profileIconURL;
@synthesize isAuthorizedUser = _isAuthorizedUser;
@synthesize userStats = _userStats;
@synthesize stylistRequestAlertsEnabled = stylistRequestAlertsEnabled;
@synthesize activeStylist = _activeStylist;
@synthesize stylistRelationship = _stylistRelationship;

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
    
    [_stylistRequestAlertsEnabled release];
    _stylistRequestAlertsEnabled = nil;
    [_activeStylist release];
    _activeStylist = nil;
    
    [_stylistRelationship release];
    _stylistRelationship = nil;

	[super dealloc];
}

@end
