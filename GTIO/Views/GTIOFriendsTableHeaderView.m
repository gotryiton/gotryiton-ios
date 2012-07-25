//
//  GTIOFriendsTableHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFriendsTableHeaderView.h"
#import "GTIOSuggestedFriendsBarButton.h"
#import "GTIOFriendsViewController.h"
#import "GTIORouter.h"

@interface GTIOFriendsTableHeaderView()

@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *suggestedFriendsBarButton;
@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *inviteFriendsBarButton;
@property (nonatomic, strong) GTIOSuggestedFriendsBarButton *findFriendsBarButton;

@property (nonatomic, assign) GTIOFriendsTableHeaderViewType type;

@end

@implementation GTIOFriendsTableHeaderView

@synthesize suggestedFriendsBarButton = _suggestedFriendsBarButton, searchBoxView = _searchBoxView, suggestedFriends = _suggestedFriends, searchBarDelegate = _searchBarDelegate, type = _type, inviteFriendsBarButton = _inviteFriendsBarButton, findFriendsBarButton = _findFriendsBarButton, delegate = _delegate, subTitleText = _subTitleText;
@synthesize inviteFriendsURL = _inviteFriendsURL, suggestedFriendsURL = _suggestedFriendsURL, findFriendsURL = _findFriendsURL;

+ (CGFloat)heightForGTIOFriendsTableHeaderViewType:(GTIOFriendsTableHeaderViewType)type
{
    switch (type) {
        case GTIOFriendsTableHeaderViewTypeFriends:
            return 178;
            break;
        case GTIOFriendsTableHeaderViewTypeFindMyFriends:
            return 128;
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
        [_inviteFriendsBarButton addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
        _findFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        _findFriendsBarButton.barTitle = (self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends) ? @"search" : @"find friends";
        _findFriendsBarButton.hasGreenBackgroundColor = (self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends) ? NO : YES;
        [_findFriendsBarButton addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
        _suggestedFriendsBarButton = [GTIOSuggestedFriendsBarButton buttonWithType:UIButtonTypeCustom];
        [_suggestedFriendsBarButton addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
        if (type == GTIOFriendsTableHeaderViewTypeFriends) {
            _suggestedFriendsBarButton.hasGreenBackgroundColor = YES;
        }
        _searchBoxView = [[GTIOFindMyFriendsSearchBoxView alloc] initWithFrame:CGRectZero];
        _searchBoxView.showSearchBox = (self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends || self.type == GTIOFriendsTableHeaderViewTypeFriends) ? NO : YES;
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
    [self.findFriendsBarButton setFrame:(CGRect){ 0, self.inviteFriendsBarButton.frame.origin.y + self.inviteFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeFriends || self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends) ? 50 : 0 }];
    [self.suggestedFriendsBarButton setFrame:(CGRect){ 0, self.findFriendsBarButton.frame.origin.y + self.findFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeFriends || self.type == GTIOFriendsTableHeaderViewTypeFindMyFriends) ? 50 : 0 }];
    [self.searchBoxView setFrame:(CGRect){ 0, self.suggestedFriendsBarButton.frame.origin.y + self.suggestedFriendsBarButton.bounds.size.height, self.bounds.size.width, (self.type == GTIOFriendsTableHeaderViewTypeSuggested) ? 0 : ((self.searchBoxView.showFollowingLabel && self.searchBoxView.showSearchBox) ? 66 : (!self.searchBoxView.showSearchBox) ? 28 : 55) }];
}

- (void)setSuggestedFriendsURL:(NSString *)suggestedFriendsURL
{
    _suggestedFriendsURL = suggestedFriendsURL;
    _suggestedFriendsBarButton.routingURL = _suggestedFriendsURL;
}

- (void)setInviteFriendsURL:(NSString *)inviteFriendsURL
{
    _inviteFriendsURL = inviteFriendsURL;
    _inviteFriendsBarButton.routingURL = _inviteFriendsURL;
}

- (void)setFindFriendsURL:(NSString *)findFriendsURL
{
    _findFriendsURL = findFriendsURL;
    _findFriendsBarButton.routingURL = _findFriendsURL;
}

- (void)pushViewController:(id)sender
{
    GTIOSuggestedFriendsBarButton *button = (GTIOSuggestedFriendsBarButton *)sender;
    if (button.routingURL.length > 0) {
        UIViewController *viewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.routingURL];
        if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
            [self.delegate pushViewController:viewController];
        }
    }
}

- (void)setSubTitleText:(NSString *)subTitleText
{
    _subTitleText = subTitleText;
    [self.searchBoxView setSubTitleText:_subTitleText];
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
