//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfile.h"

@interface GTIOProfileHeaderView : UIView {
	TTImageView* _profilePictureImageView;
	UIImageView* _fashionProfileBadge;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UIButton* _editProfileButton;
    bool _shouldAllowEditing;
}

@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) UILabel* locationLabel;

- (void)displayProfile:(GTIOProfile*)profile;

@end
