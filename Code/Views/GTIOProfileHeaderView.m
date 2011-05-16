//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfileHeaderView.h"


@implementation GTIOProfileHeaderView

@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark-top.png"]];
	[self addSubview:background];
	[background release];
	
	_profilePictureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
	_profilePictureImageView.layer.cornerRadius = 5.0;
	[_profilePictureImageView setFrame:CGRectMake(10,8,54,54)];
	[self addSubview:_profilePictureImageView];
		
	UIImageView* profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-icon-overlay-110.png"]];
	[profilePictureFrame setFrame:CGRectMake(5,3,64,64)];
	[self addSubview:profilePictureFrame];
	
	_fashionProfileBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fash-badge-profile.png"]];
	[_fashionProfileBadge setFrame:CGRectMake(0,2.5,48,48)];
	[self addSubview:_fashionProfileBadge];
	[_fashionProfileBadge setHidden:YES];

	_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 250, 40)];
	_nameLabel.backgroundColor = [UIColor clearColor];
	_nameLabel.font = kGTIOFetteFontOfSize(36);
	_nameLabel.textColor = [UIColor whiteColor];
	[self addSubview:_nameLabel];
	
	_locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 43, 250, 20)];
	_locationLabel.backgroundColor = [UIColor clearColor];
	_locationLabel.font = [UIFont systemFontOfSize:15];
	_locationLabel.textColor = kGTIOColorB2B2B2;
	[self addSubview:_locationLabel];
	
	_editProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_editProfileButton setImage:[UIImage imageNamed:@"edit-OFF.png"] forState:UIControlStateNormal];
	[_editProfileButton setImage:[UIImage imageNamed:@"edit-ON.png"] forState:UIControlStateHighlighted];
	[_editProfileButton setFrame:CGRectMake(320-35-7.5,70-20-5,35,20)];
	[_editProfileButton addTarget:self action:@selector(editButtonHighlight) forControlEvents:UIControlEventTouchDown];
	[_editProfileButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_editProfileButton];
	
	return self;
}

- (void)displayProfile:(GTIOProfile*)profile {
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
	CGRect badgeFrame = _fashionProfileBadge.frame;
	CGFloat offsetX = [_nameLabel.text sizeWithFont:_nameLabel.font].width + _nameLabel.frame.origin.x;
	[_fashionProfileBadge setFrame:CGRectMake(offsetX,badgeFrame.origin.y,badgeFrame.size.width,badgeFrame.size.height)];
	[_fashionProfileBadge setHidden:NO];
}

- (void)dealloc
{
	[super dealloc];
}

- (void)editButtonHighlight {
	[_editProfileButton setHighlighted:YES];
}

- (void)editButtonAction {
	[_editProfileButton setHighlighted:YES];
	TTOpenURL(@"gtio://profile/edit");
}

@end
