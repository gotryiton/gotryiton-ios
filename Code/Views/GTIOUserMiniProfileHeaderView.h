//
//  GTIOUserMiniProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/26/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProfile.h"

@interface GTIOUserMiniProfileHeaderView : UIView {
    TTImageView* _profilePictureImageView;
	UIImageView* _fashionProfileBadge;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
}

@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* locationLabel;

- (void)displayProfile:(GTIOProfile*)profile;

@end
