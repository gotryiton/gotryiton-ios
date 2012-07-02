//
//  GTIOSearchEntireCommunityView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOFriendsSearchEmptyStateViewDelegate.h"

@interface GTIOSearchEntireCommunityView : UIView

@property (nonatomic, weak) id<GTIOFriendsSearchEmptyStateViewDelegate> delegate;

- (CGFloat)height;

@end
