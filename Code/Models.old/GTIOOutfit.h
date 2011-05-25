//
//  GTIOOutfit.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/20/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Restkit/RestKit.h>
#import "GTIOVotingResultSet.h"
#import "GTIOStylistRelationship.h"

@interface GTIOOutfit : NSObject <TTScrollViewDataSource> {
	NSString* _outfitID;
	NSString* _uid;
	NSString* _name;
	NSString* _city;
	NSString* _state;
	NSString* _location;
	NSNumber* _timestamp;
	NSNumber* _isPublic;
	NSString* _descriptionString;
	NSString* _event;
	NSNumber* _eventId;
	NSString* _url;
	NSString* _method;
	NSNumber* _isMultipleOption;
	NSNumber* _photoCount;
	NSString* _imagePath;
	NSString* _mainImageUrl;
	NSString* _iphoneThumbnailUrl;
	UIImage*  _thumbnailImage;
	NSString* _smallThumbnailUrl;
    NSArray* _badges;
	// Reviews
	NSNumber* _reviewCount;
	NSString* _user;
	// Photos
	NSNumber* _isNew;
	
	NSArray* _reviews;
	NSString* _userReview;
	
	NSArray* _photos;
	
	GTIOVotingResultSet* _results;
    
    GTIOStylistRelationship* _stylistRelationship;
}

@property (nonatomic, retain) GTIOVotingResultSet *results;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSString *userReview;
@property (nonatomic, copy) NSArray *reviews;
@property (nonatomic, readonly) NSString* sid;
@property (nonatomic, retain) NSString* outfitID;
@property (nonatomic, retain) NSString* uid;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSString* location;
@property (nonatomic, retain) NSNumber*	timestamp;
@property (nonatomic, retain) NSNumber* isPublic;
@property (nonatomic, retain) NSString* descriptionString;
@property (nonatomic, retain) NSString* event;
@property (nonatomic, retain) NSNumber* eventId;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* method;
@property (nonatomic, retain) NSNumber* isMultipleOption;
@property (nonatomic, retain) NSNumber* photoCount;
@property (nonatomic, retain) NSString* imagePath;
@property (nonatomic, retain) NSString* mainImageUrl;
@property (nonatomic, retain) NSString* iphoneThumbnailUrl;
@property (nonatomic, retain) UIImage*  thumbnailImage;
@property (nonatomic, retain) NSString* smallThumbnailUrl;
@property (nonatomic, retain) NSArray* badges;
// Reviews
@property (nonatomic, retain) NSNumber* reviewCount;
@property (nonatomic, retain) NSString* user;
// Photos
@property (nonatomic, retain) NSNumber* isNew;

@property (nonatomic, readonly) NSString* firstName;
@property (nonatomic, readonly) NSString* reviewCountString;

@property (nonatomic, retain) GTIOStylistRelationship* stylistRelationship;

+ (GTIOOutfit*)outfitWithOutfitID:(NSString*)oid;

@end
