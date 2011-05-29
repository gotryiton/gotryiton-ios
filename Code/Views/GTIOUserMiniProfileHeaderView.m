//
//  GTIOUserMiniProfileHeaderView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/26/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOUserMiniProfileHeaderView.h"


@implementation GTIOUserMiniProfileHeaderView

@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _profilePictureImageView = [TTImageView new];
        //[(UIImageView*)_profilePictureImageView setImage:[UIImage imageNamed:@"empty-profile-pic.png"]];
        _profilePictureImageView.layer.cornerRadius = 2.0;
        [_profilePictureImageView setFrame:CGRectMake(10,8,46,46)];
        //[self addSubview:_profilePictureImageView];

        UIImageView* profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-76.png"]];
        [profilePictureFrame setFrame:CGRectMake(15,12,46,46)];
        [self addSubview:profilePictureFrame];
        
        _fashionProfileBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fash-badge-profile.png"]];
        [_fashionProfileBadge setFrame:CGRectMake(0,2.5,48,48)];
        [self addSubview:_fashionProfileBadge];
        [_fashionProfileBadge setHidden:YES];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 250, 40)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = kGTIOFetteFontOfSize(21);
        _nameLabel.textColor = kGTIOColorBrightPink;
        [self addSubview:_nameLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 37, 250, 20)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.textColor = kGTIOColor888888;
        [self addSubview:_locationLabel];
    }
    return self;
}

- (void)displayProfile:(GTIOProfile*)profile {
    //    [_profilePictureImageView setUrlPath:[profile profileIconURL]];
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
	CGRect badgeFrame = _fashionProfileBadge.frame;
	CGFloat offsetX = [_nameLabel.text sizeWithFont:_nameLabel.font].width + _nameLabel.frame.origin.x;
	[_fashionProfileBadge setFrame:CGRectMake(offsetX,badgeFrame.origin.y,badgeFrame.size.width,badgeFrame.size.height)];
	//[_fashionProfileBadge setHidden:NO];
}

- (void)dealloc
{
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_profilePictureImageView);
    [super dealloc];
}

@end
