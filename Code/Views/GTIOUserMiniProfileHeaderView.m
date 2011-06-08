//
//  GTIOUserMiniProfileHeaderView.m
//  GTIO
//
//  Created by Daniel Hammond on 5/26/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOUserMiniProfileHeaderView.h"
#import "GTIOBadge.h"

@implementation GTIOUserMiniProfileHeaderView

@synthesize nameLabel = _nameLabel;
@synthesize locationLabel = _locationLabel;

- (void)setup {
    _profilePictureImageView = [TTImageView new];
    _profilePictureImageView.layer.cornerRadius = 2.0;
    [_profilePictureImageView setFrame:CGRectInset(CGRectMake(15,12,46,46), 4, 4)];
    [self addSubview:_profilePictureImageView];
    
    UIImageView* profilePictureFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-overlay-76.png"]];
    [profilePictureFrame setFrame:CGRectMake(15,12,46,46)];
    [self addSubview:profilePictureFrame];
    
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

- (void)awakeFromNib {
    [self setup];
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)displayProfile:(GTIOProfile*)profile {
    [_profilePictureImageView setUrlPath:[profile profileIconURL]];
	_nameLabel.text = [profile.displayName uppercaseString];
	[_nameLabel setNeedsDisplay];
	_locationLabel.text = profile.location;
	[_locationLabel setNeedsDisplay];
	CGFloat offsetX = [_nameLabel.text sizeWithFont:_nameLabel.font].width + _nameLabel.frame.origin.x;
    
    // Badges
    for (UIView* view in _badgeImageViews) {
        [view removeFromSuperview];
    }
    [_badgeImageViews release];
    _badgeImageViews = [NSMutableArray new];
    offsetX += 10;
    for (GTIOBadge* badge in profile.badges) {
        TTImageView* imageView = [[TTImageView alloc] initWithFrame:CGRectMake(offsetX,20,16,16)];
        offsetX += 10;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.urlPath = badge.imgURL;
        [self addSubview:imageView];
        [_badgeImageViews addObject:imageView];
    }
}

- (void)dealloc
{
	TT_RELEASE_SAFELY(_nameLabel);
	TT_RELEASE_SAFELY(_locationLabel);
	TT_RELEASE_SAFELY(_profilePictureImageView);
    for (UIView* view in _badgeImageViews) {
        [view removeFromSuperview];
    }
    [_badgeImageViews release];
    [super dealloc];
}

@end
