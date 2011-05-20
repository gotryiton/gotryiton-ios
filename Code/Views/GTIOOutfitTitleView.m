//
//  GTIOOutfitHeaderView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOOutfitTitleView.h"


@implementation GTIOOutfitTitleView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
        // Names
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.textColor = [UIColor whiteColor];
		_nameLabel.font = kGTIOFetteFontOfSize(23);
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_nameLabel];
        // Locations
		_locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_locationLabel.textColor = kGTIOColorBrightPink;
		_locationLabel.font = kGTIOFontHelveticaNeueOfSize(13);
		_locationLabel.backgroundColor = [UIColor clearColor];
		_locationLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_locationLabel];
        // Badges
        _badgeView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,20,20)];
        _badgeView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,10,20,20)];
        [_badgeView1 setImage:[UIImage imageNamed:@"exampleBadgeImage1.png"]];
        [_badgeView2 setImage:[UIImage imageNamed:@"exampleBadgeImage2.png"]];
        [self addSubview:_badgeView1];
        [self addSubview:_badgeView2];
	}
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_nameLabel);
    TT_RELEASE_SAFELY(_locationLabel);
    TT_RELEASE_SAFELY(_badgeView1);
    TT_RELEASE_SAFELY(_badgeView2);
	[super dealloc];
}

- (void)layoutSubviews {
    // Layout Badges
    // TODO: Once we have API integration we'll need to make this conditional based on number of badges
    //       We can safely assume according to GTIO team that there will be 0-2 badges, and here we assume 
    //       that badgeview1 is always the leftmost for the label calculations -DRH
    CGFloat badgeTopPadding = 2.5;
    CGFloat badgeLeftPadding = (self.width - 20);
    _badgeView1.frame = CGRectMake(badgeLeftPadding-_badgeView1.frame.size.width,badgeTopPadding,20,20);
    _badgeView2.frame = CGRectMake(badgeLeftPadding,badgeTopPadding,20,20);
    // Layout Labels Based on Badge Frames
    CGFloat nameLabelWidth = (_badgeView1.frame.origin.x - (self.width / 2)) * 2.0;     // (Distance of left most badge to center times 2)
    CGFloat nameLabelLeftPadding = (self.width - nameLabelWidth)/2.0;                   // Centered based on width
    _nameLabel.frame = CGRectMake(nameLabelLeftPadding, 4 - 2, nameLabelWidth, self.height * 0.65);
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
