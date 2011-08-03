//
//  GTIOProfile.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/14/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "GTIOStylistRelationship.h"
#import "GTIOExtraProfileRow.h"

@interface GTIOProfile : NSObject {
	NSString* _uid;
	NSNumber* _auth;
	NSString* _displayName;
	NSString* _firstName;
	NSString* _lastInitial;
	NSString* _gender;
	NSString* _city;
	NSString* _state;
	NSString* _location;
	NSString* _aboutMe;
    NSString* _profileIconURL;
	NSNumber* _isAuthorizedUser;
    
    
	NSArray* _userStats;
	NSArray* _badgeImageURLs;
	
	NSArray* _outfits;
	NSArray* _reviewsOutfits;
	NSArray* _badges;
    
    // People I Style:
    NSNumber* _stylistRequestAlertsEnabled;
    NSNumber* _activeStylist;
    
    NSString* _featuredText;
    
    GTIOStylistRelationship* _stylistRelationship;
    NSNumber* _isBranded;
    
    GTIOExtraProfileRow* _extraProfileRow;
    
    NSArray* _stylists;
}

@property (nonatomic, copy) NSArray *badges;
@property (nonatomic, copy) NSArray *reviewsOutfits;
@property (nonatomic, copy) NSArray *badgeImageURLs;
@property (nonatomic, copy) NSArray *outfits;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, retain) NSNumber *auth;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastInitial;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic, copy) NSString *profileIconURL;
@property (nonatomic, retain) NSNumber *isAuthorizedUser;
@property (nonatomic, copy) NSArray *userStats;
@property (nonatomic, retain) NSArray* stylists;

@property (nonatomic, retain) NSNumber* stylistRequestAlertsEnabled;
@property (nonatomic, retain) NSNumber* activeStylist;

@property (nonatomic, retain) GTIOStylistRelationship* stylistRelationship;

@property (nonatomic, copy) NSString* featuredText;
@property (nonatomic, retain) NSNumber* isBranded;
@property (nonatomic, retain) GTIOExtraProfileRow* extraProfileRow;

@property (nonatomic, readonly) NSString* genderPronoun;

@end
