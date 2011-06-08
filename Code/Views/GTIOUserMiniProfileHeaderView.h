//
//  GTIOUserMiniProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/26/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//
/// GTIOUserMiniProfileHeaderView is a subview used in several places that displays a [GTIOProfile](GTIOProfile) profile picture, name, location, and badges
#import "GTIOProfile.h"

@interface GTIOUserMiniProfileHeaderView : UIView {
    TTImageView* _profilePictureImageView;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
    NSMutableArray* _badgeImageViews;
}
/// UILabel for the profile's name value
@property (nonatomic, retain) UILabel* nameLabel;
/// UILabel for the profile's location value
@property (nonatomic, retain) UILabel* locationLabel;
/// Display a given profile
- (void)displayProfile:(GTIOProfile*)profile;

@end
