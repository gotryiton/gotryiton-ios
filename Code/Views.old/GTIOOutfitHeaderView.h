//
//  GTIOOutfitHeaderView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTIOOutfitHeaderView : UIView {
	UILabel* _nameLabel;
	UILabel* _locationLabel;
    UIImageView* _badgeView1;
    UIImageView* _badgeView2;
}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* location;

@end
