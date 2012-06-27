//
//  GTIOFriendsTableHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsTableHeaderView.h"
#import "GTIOSuggestedFriendsBarButton.h"
#import "GTIOFindMyFriendsSearchBoxView.h"
#import "GTIOFriendsViewController.h"

@interface GTIOFriendsTableHeaderView()

@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *suggestedFriendsBarButton;
@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *inviteFriendsBarButton;
@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *findFriendsBarButton;

@property (nonatomic, strong) GTIOFindMyFriendsSearchBoxView *searchBoxView;
@property (nonatomic, assign) GTIOFriendsTableHeaderViewType type;

@end

@implementation GTIOFriendsTableHeaderView

@synthesize suggestedFriendsBarButton = _suggestedFriendsBarButton, searchBoxView = _searchBoxView, suggestedFriends = _suggestedFriends, numberOfFriendsFollowing = _numberOfFriendsFollowing, searchBarDelegate = _searchBarDelegate, type = _type, numberOfFollowers = _numberOfFollowers, inviteFriendsBarButton = _inviteFriendsBarButton, findFriendsBarButton = _findFriendsBarButton, delegate = _delegate;

+ (CGFloat)heightForGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)type
{
    switch (type) {
        case GTIOFriendsTableHeaderViewTypeFriends:
            return 216;
            break;
        case GTIOFriendsTableHeaderViewTypeFindMyFriends:
            return 116;
            break;
        case GTIOFriendsTableHeaderViewTypeFindFriends:
            return 55;
            break;
        case GTIOFriendsTableHeaderViewTypeFollowers:
            return 66;
            break;
        case GTIOFriendsTableHeaderViewTypeFollowing:
            return 66;
            break;
        case GTIOFriendsTableHeaderViewTypeSuggested:
            return 0;
        default:
            return 0;
            break;
    }
}

- (id)initWithFrame:(CGRect)frame type:(GTIOFriendsTableHeaderViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        
        _inviteFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        _inviteFriendsBarButton.barTitle = @"invite friends";
        _inviteFriendsBarButton.hasGreenBackgroundColor = YES;
        _findFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        _findFriendsBarButton.barTitle = @"find friends";
        _findFriendsBarButton.hasGreenBackgroundColor = YES;
        [_findFriendsBarButton addTarget:self action:@selector(pushFindFriendsViewController:) forControlEvents:UIControlEventTouchUpInside];
        _suggestedFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        [_suggestedFriendsBarButton addTarget:self action:@selector(pushSuggestedFriendsViewController:) forControlEvents:UIControlEventTouchUpInside];
        if (type == GTIOFriendsTableHeaderViewTypeFriends) {
            _suggestedFriendsBarButton.hasGreenBackgroundColor = YES;
        }
        _searchBoxView = [[GTIOFindMyFriendsSearchBoxView alloc] initWithFrame:CGRectZero];
        if (type == GTIOFriendsTableHeaderViewTypeFindFriends) {
            _searchBoxView.showFollowingLabel = NO;
            _searchBoxView.searchBarPlaceholder = @"search e.g. (Jane Doe)";
        }
        if (type == GTIOFriendsTableHeaderViewTypeFollowers) {
            _searchBoxView.searchBarPlaceholder = @"search through followers";
        }

        [self addSubview:_inviteFriendsBarButton];
        [self addSubview:_findFriendsBarButton];
        [self addSubview:_suggestedFriendsBarButton];
        [self addSubview:_searchBoxView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.inviteFriendsBarButton setFrame:(CGRect){ 0, 0, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeFriends) ? 50 : 0 }];
    [self.findFriendsBarButton setFrame:(CGRect){ 0, self.inviteFriendsBarButton.frame.origin.y + self.inviteFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeFriends) ? 50 : 0 }];
    [self.suggestedFriendsBarButton setFrame:(CGRect){ 0, self.findFriendsBarButton.frame.origin.y + self.findFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeFriends || self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends) ? 50 : 0 }];
    [self.searchBoxView setFrame:(CGRect){ 0, self.suggestedFriendsBarButton.frame.origin.y + self.suggestedFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeSuggested) ? 0 : ((self.searchBoxView.showFollowingLabel) ? 66 : 55) }];
}

- (void)pushFindFriendsViewController:(id)sender
{
    GTIOFriendsViewController *findFriendsViewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeFindFriends];
    if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
        [self.delegate pushViewController:findFriendsViewController];
    }
}

- (void)pushSuggestedFriendsViewController:(id)sender
{
    GTIOFriendsViewController *suggestedFriendsViewController = [[GTIOFriendsViewController alloc] initWithGTIOFriendsTableHeaderViewType:GTIOFriendsTableHeaderViewTypeSuggested];
    if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
        [self.delegate pushViewController:suggestedFriendsViewController];
    }
}

- (void)setNumberOfFriendsFollowing:(int)numberOfFriendsFollowing
{
    _numberOfFriendsFollowing = numberOfFriendsFollowing;
    [self.searchBoxView setNumberOfFriendsFollowing:_numberOfFriendsFollowing];
}

- (void)setNumberOfFollowers:(int)numberOfFollowers
{
    _numberOfFollowers = numberOfFollowers;
    [self.searchBoxView setNumberOfFollowers:_numberOfFollowers];
}

- (void)setSuggestedFriends:(NSArray *)suggestedFriends
{
    _suggestedFriends = suggestedFriends;
    [self.suggestedFriendsBarButton setSuggestedFriends:_suggestedFriends];
}

- (void)setSearchBarDelegate:(id<UISearchBarDelegate>)searchBarDelegate
{
    _searchBarDelegate = searchBarDelegate;
    [self.searchBoxView setSearchBarDelegate:_searchBarDelegate];
}

@end
