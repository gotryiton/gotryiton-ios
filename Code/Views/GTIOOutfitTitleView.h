//
//  GTIOOutfitHeaderView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

/** GTIOOutfitHeaderView is the navigation header view for outfit views, it displays the outfit owners name, location, and badges
*	There is a limitation of a maximum two badges (0-2), and the name and location labels are centered with the name label truncated where there is not enough room to display the entire name and the badges
*/
@interface GTIOOutfitTitleView : UIView {
	UILabel* _nameLabel;
	UILabel* _locationLabel;
    TTImageView* _badgeView1;
    TTImageView* _badgeView2;
}
/// Outfit Owner's name
@property (nonatomic, copy) NSString* name;
/// Outfit Owner's location
@property (nonatomic, copy) NSString* location;

// Outfit owner's GTIOBadges
- (void)setBadges:(NSArray*)badges;

@end
