//
//  GTIOReview.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "GTIOProfile.h"

@interface GTIOReview : RKObject {
	NSString* _outfitID;
	NSString* _uid;
	NSString* _reviewID;
	NSNumber* _timestamp;
	NSString* _text;
	GTIOProfile* _user;
	NSNumber* _agreeVotes;
	NSNumber* _flags;
}

@property (nonatomic, retain) NSNumber *agreeVotes;
@property (nonatomic, retain) NSNumber *flags;
@property (nonatomic, copy) NSString *outfitID;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *reviewID;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) GTIOProfile *user;

@end
