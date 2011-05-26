//
//  GTIOBadge.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOBadge.h"


@implementation GTIOBadge

@synthesize type = _type;
@synthesize since = _since;
@synthesize imgURL = _imgURL;

- (void)dealloc {
	[_type release];
	_type = nil;
	[_since release];
	_since = nil;
	[_imgURL release];
	_imgURL = nil;

	[super dealloc];
}

@end
