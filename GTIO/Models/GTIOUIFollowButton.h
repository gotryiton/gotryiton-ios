//
//  GTIOFollowingButton.h
//  GTIO
//
//  Created by Simon Holroyd on 12/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

typedef enum GTIOUIFollowButtonState {
    GTIOUIFollowButtonStateFollow = 0,
    GTIOUIFollowButtonStateFollowing,
    GTIOUIFollowButtonStateRequested
} GTIOUIFollowButtonState;

@interface GTIOUIFollowButton : GTIOUIButton


- (void)setFollowState:(GTIOUIFollowButtonState)state;
+ (id)initFollowButton;

@end
