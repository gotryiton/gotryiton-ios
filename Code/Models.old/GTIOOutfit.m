//
//  GTIOOutfit.m
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/20/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOOutfit.h"
#import "GTIOSpinnerImageView.h"

NSMutableArray* allOutfits;

@implementation GTIOOutfit

@synthesize results = _results;
@synthesize photos = _photos;
@synthesize userReview = _userReview;
@synthesize userReviewAgreeVotes = _userReviewAgreeVotes;
@synthesize reviews = _reviews;
@synthesize outfitID = _outfitID;
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize city = _city;
@synthesize state = _state;
@synthesize location = _location;
@synthesize timestamp = _timestamp;
@synthesize isPublic = _isPublic;
@synthesize descriptionString = _descriptionString;
@synthesize event = _event;
@synthesize eventId = _eventId;
@synthesize url = _url;
@synthesize method = _method;
@synthesize isMultipleOption = _isMultipleOption;
@synthesize photoCount = _photoCount;
@synthesize imagePath = _imagePath;
@synthesize mainImageUrl = _mainImageUrl;
@synthesize iphoneThumbnailUrl = _iphoneThumbnailUrl;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize smallThumbnailUrl = _smallThumbnailUrl;
@synthesize badges = _badges;
// Reviews
@synthesize reviewCount = _reviewCount;
@synthesize user = _user;
// Photos
@synthesize isNew = _isNew;	

@synthesize stylistRelationship = _stylistRelationship;

- (id)init {
	if (self = [super init]) {
		if (nil == allOutfits) {
			allOutfits = TTCreateNonRetainingArray();
		}
		[allOutfits addObject:self];
	}
	return self;
}

- (void)dealloc {
	[allOutfits removeObjectIdenticalTo:self];
	
	[_results release];
	[_photos release];
	[_userReview release];
    [_userReviewAgreeVotes release];
	[_reviews release];
	[_outfitID release];
	[_uid release];
	[_name release];
	[_city release];
	[_state release];
	[_location release];
	[_timestamp release];
	[_isPublic release];
	[_descriptionString release];
	[_event release];
	[_eventId release];
	[_url release];
	[_method release];
	[_isMultipleOption release];
	[_photoCount release];
	[_imagePath release];
	[_mainImageUrl release];
	[_iphoneThumbnailUrl release];
	[_thumbnailImage release];
	[_smallThumbnailUrl release];
    [_badges release];
	[_reviewCount release];
	[_user release];
	[_isNew release];
    [_stylistRelationship release];

	[super dealloc];
}

+ (GTIOOutfit*)outfitWithOutfitID:(NSString*)oid {
    NSLog(@"Outfit IDs: %@", [allOutfits valueForKeyPath:@"outfitID"]);
	return [allOutfits objectWithValue:oid forKey:@"outfitID"];
}

- (NSString*)sid {
	return self.outfitID;
}

- (NSString*)firstName {
    NSMutableArray* nameParts = [[[self.name componentsSeparatedByString:@" "] mutableCopy] autorelease];
    [nameParts removeLastObject];
    NSString* firstName = [nameParts componentsJoinedByString:@" "];
    return firstName;
}

- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
	return [_photos count];
}

- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
	UIView* view = [scrollView dequeueReusablePage];
    GTIOSpinnerImageView* imgView = (GTIOSpinnerImageView*)[view viewWithTag:99999];
	if (nil == view) {
        view = [[[UIView alloc] initWithFrame:scrollView.bounds] autorelease];
        view.clipsToBounds = NO;
        scrollView.clipsToBounds = NO;
		imgView = [[[GTIOSpinnerImageView alloc] initWithFrame:CGRectMake(0,-7,320,427)] autorelease];
        [imgView setContentMode:UIViewContentModeScaleToFill];
		imgView.defaultImage = [UIImage imageNamed:@"default-outfit.png"];
        imgView.tag = 99999;
        [view addSubview:imgView];
	}
	[imgView unsetImage];
	imgView.urlPath = [[_photos objectAtIndex:pageIndex] valueForKey:@"mainImg"];
	return view;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
//    return CGSizeMake(320,427);
	return scrollView.bounds.size;
}

- (NSString*)reviewCountString {
    if ([_reviewCount intValue] == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", _reviewCount];
}

- (BOOL)isEqual:(id)obj {
    if ([obj isKindOfClass:[GTIOOutfit class]]) {
        if ([self.outfitID isEqualToString:[(GTIOOutfit*)obj outfitID]]) {
            return YES;
        } else {
            return NO;
        }
    }
    return [super isEqual:obj];
}

@end
