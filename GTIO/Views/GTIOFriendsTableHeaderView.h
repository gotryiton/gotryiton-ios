//
//  GTIOFriendsTableHeaderView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum GTIOFriendsTableHeaderViewType {
    GTIOFriendsTableHeaderViewTypeFindMyFriends = 0,
    GTIOFriendsTableHeaderViewTypeFriends,
    GTIOFriendsTableHeaderViewTypeFindFriends,
    GTIOFriendsTableHeaderViewTypeFollowing,
    GTIOFriendsTableHeaderViewTypeFollowers
} GTIOFriendsTableHeaderViewType;

@interface GTIOFriendsTableHeaderView : UIView

@property (nonatomic, strong) NSArray *suggestedFriends;
@property (nonatomic, assign) int numberOfFriendsFollowing;
@property (nonatomic, assign) int numberOfFollowers;
@property (nonatomic, weak) id<UISearchBarDelegate> searchBarDelegate;

- (id)initWithFrame:(CGRect)frame type:(GTIOFriendsTableHeaderViewType)type;
+ (CGFloat)heightForGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)type;

@end
