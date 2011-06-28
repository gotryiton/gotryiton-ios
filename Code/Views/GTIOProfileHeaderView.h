//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOProfileHeaderView is a subview of the [GTIOProfileViewController](GTIOProfileViewController) that displays
/// the profile picture, name, location, badges from the supplied [GTIOProfile](GTIOProfile). And when apropriate
/// displays an "edit" button allowing the user to edit their own profile.

#import "GTIOProfile.h"

@interface GTIOProfileHeaderView : UIView <RKObjectLoaderDelegate> {
	TTImageView* _profilePictureImageView;
	UILabel* _nameLabel;
	UILabel* _locationLabel;
	UIButton* _editProfileButton;
    UIImageView* _connectionImageView;
    bool _shouldAllowEditing;
    
    UIImageView* _profilePictureFrame;
    UIImageView* _backgroundOverlay;
    
    GTIOProfile* _profile;
    NSMutableArray* _badgeImageViews;
}
/// UILabel for name
@property (nonatomic, retain) UILabel* nameLabel;
/// UILabel for location
@property (nonatomic, retain) UILabel* locationLabel;
/// displayProfile: accepts profile to display
- (void)displayProfile:(GTIOProfile*)profile;

@end
