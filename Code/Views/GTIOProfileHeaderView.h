//
//  GTIOProfileHeaderView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOProfile.h"

@interface GTIOProfileHeaderView : UIView {
	UILabel* _nameLabel;
	UILabel* _locationLabel;
}

- (void)displayProfile:(GTIOProfile*)profile;

@end
