//
//  GTIOFriendsNoSearchResultsView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOFriendsSearchEmptyStateViewDelegate.h"

@interface GTIOFriendsNoSearchResultsView : UIView

@property (nonatomic, copy) NSString *failedQuery;
@property (nonatomic, assign) BOOL hideSearchCommunityText;
@property (nonatomic, weak) id<GTIOFriendsSearchEmptyStateViewDelegate> delegate;

- (CGFloat)height;

@end
