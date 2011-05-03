//
//  GTIOOutfitHeaderView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOOutfitHeaderView.h"


@implementation GTIOOutfitHeaderView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.textColor = [UIColor whiteColor];
		_nameLabel.font = kGTIOFetteFontOfSize(23);
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_nameLabel];
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.textColor = kGTIOColorBrightPink;
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_locationLabel.backgroundColor = [UIColor clearColor];
		_locationLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_locationLabel];
	}
	return self;
}

- (void)dealloc {
//	TODO: WHY DOES THIS CRASH???!?!
//	[_nameLabel release];
//	_nameLabel = nil;
	[_locationLabel release];
	_locationLabel = nil;
	[super dealloc];
}

- (void)layoutSubviews {
	_nameLabel.frame = CGRectMake(0, 4 - 2, self.width, self.height * 0.65);
	_locationLabel.frame = CGRectMake(0, self.height * 0.65 - 1, self.width, self.height * 0.35);
}

- (void)setName:(NSString*)name {
	_nameLabel.text = [[name copy] autorelease];
}

- (NSString*)name {
	return [[_nameLabel.text copy] autorelease];
}

- (void)setLocation:(NSString*)location {
	_locationLabel.text = location;
}

- (NSString*)location {
	return _locationLabel.text;
}

@end
