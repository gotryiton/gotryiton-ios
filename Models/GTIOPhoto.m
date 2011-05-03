//
//  GTIOPhoto.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOPhoto.h"

@implementation GTIOPhoto

@synthesize image = _image;
@synthesize brandsYouAreWearing = _brandsYouAreWearing;
@synthesize blurApplied = _blurApplied;

- (id)init {
	if (self = [super init]) {
		_blurApplied = NO;
	}
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_image);
	TT_RELEASE_SAFELY(_brandsYouAreWearing);

	[super dealloc];
}

@end
