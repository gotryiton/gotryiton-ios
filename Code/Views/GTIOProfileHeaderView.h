//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfile.h"

@interface GTIOProfileHeaderView : UIView {
	UIImageView* _profilePictureImageView;
	UIImageView* _fashionProfileBadge;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UIButton* _editProfileButton;
}

- (void)displayProfile:(GTIOProfile*)profile;

@end
