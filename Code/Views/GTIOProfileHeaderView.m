//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfileHeaderView.h"


@implementation GTIOProfileHeaderView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark-top.png"]];
	[self addSubview:background];
	[background release];
	
	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 40)];
	_nameLabel.backgroundColor = [UIColor clearColor];
	_nameLabel.font = kGTIOFetteFontOfSize(36);
	_nameLabel.textColor = [UIColor whiteColor];
	[self addSubview:_nameLabel];
	
	_locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50-6-1, 250, 20)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.font = [UIFont systemFontOfSize:15];
	_locationLabel.textColor = kGTIOColorB2B2B2;
	[self addSubview:_locationLabel];
	return self;
}

- (void)displayProfile:(GTIOProfile*)profile {
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
}

- (void)dealloc
{
	[super dealloc];
}

@end
