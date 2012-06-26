//
//  GTIOFindMyFriendsTableHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsTableHeaderView.h"
#import "GTIOSuggestedFriendsBarButton.h"
#import "GTIOFindMyFriendsSearchBoxView.h"

@interface GTIOFindMyFriendsTableHeaderView()

@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *suggestedFriendsBarButton;
@property (nonatomic, strong) GTIOFindMyFriendsSearchBoxView *searchBoxView;

@end

@implementation GTIOFindMyFriendsTableHeaderView

@synthesize suggestedFriendsBarButton = _suggestedFriendsBarButton, searchBoxView = _searchBoxView, suggestedFriends = _suggestedFriends, numberOfFriendsFollowing = _numberOfFriendsFollowing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _suggestedFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_suggestedFriendsBarButton];
        _searchBoxView = [[GTIOFindMyFriendsSearchBoxView alloc] initWithFrame:CGRectZero];
        [self addSubview:_searchBoxView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.suggestedFriendsBarButton setFrame:(CGRect){ 0, 0, self.bounds.size.width, 50 }];
    [self.searchBoxView setFrame:(CGRect){ 0, self.suggestedFriendsBarButton.frame.origin.y + self.suggestedFriendsBarButton.bounds.size.height, self.bounds.size.width, 66 }];
}

- (void)setNumberOfFriendsFollowing:(int)numberOfFriendsFollowing
{
    _numberOfFriendsFollowing = numberOfFriendsFollowing;
    [self.searchBoxView setNumberOfFriendsFollowing:_numberOfFriendsFollowing];
}

- (void)setSuggestedFriends:(NSArray *)suggestedFriends
{
    _suggestedFriends = suggestedFriends;
    [self.suggestedFriendsBarButton setSuggestedFriends:_suggestedFriends];
}

@end
