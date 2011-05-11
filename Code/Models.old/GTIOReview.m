//
//  GTIOReview.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOReview.h"


@implementation GTIOReview

@synthesize agreeVotes = _agreeVotes;
@synthesize flags = _flags;
@synthesize outfitID = _outfitID;
@synthesize uid = _uid;
@synthesize reviewID = _reviewID;
@synthesize timestamp = _timestamp;
@synthesize text = _text;
@synthesize user = _user;


- (void)dealloc {

	[_outfitID release];
	_outfitID = nil;
	[_uid release];
	_uid = nil;
	[_reviewID release];
	_reviewID = nil;
	[_timestamp release];
	_timestamp = nil;
	[_text release];
	_text = nil;
	[_user release];
	_user = nil;
	[_agreeVotes release];
	_agreeVotes = nil;
	[_flags release];
	_flags = nil;

	[super dealloc];
}

@end
