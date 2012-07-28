//
//  GTIOPostMasonryView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostMasonryView.h"
#import "GTIOPostMasonryEmptyStateView.h"
#import "GTIOPost.h"

static double const kGTIOLeftPadding = 7.0;
static double const kGTIOTopPadding = 9.0;

@interface GTIOPostMasonryView()

@property (nonatomic, strong) GTIOPostMasonryEmptyStateView *emptyStateView;

@end

@implementation GTIOPostMasonryView

@synthesize userProfile = _userProfile, items = _items, postType = _postType;
@synthesize emptyStateView = _emptyStateView;
@synthesize masonGridView = _masonGridView;

- (id)initWithGTIOPostType:(GTIOPostType)postType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        _postType = postType;
        
        _masonGridView = [[GTIOMasonGridView alloc] initWithFrame:self.bounds];
        [self.masonGridView attachPullToRefreshAndPullToLoadMore];
        [self.masonGridView.pullToRefreshView setExpandedHeight:60.0f];
        [self.masonGridView.pullToLoadMoreView setExpandedHeight:0.0f];
        [((GTIOPullToLoadMoreContentView *)self.masonGridView.pullToLoadMoreView.contentView) setShouldShowTopAccentLine:NO];
    }
    return self;
}

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.masonGridView setFrame:self.bounds];
    [self.emptyStateView setFrame:(CGRect){ self.frame.size.width/2 - self.emptyStateView.bounds.size.width/2 , self.frame.size.height/2 - self.emptyStateView.bounds.size.height/2, self.emptyStateView.bounds.size }];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    // Initial load on segment change
    if (!hidden && [self.items count] == 0) {
        if (self.masonGridView.pullToRefreshHandler) {
            self.masonGridView.pullToRefreshHandler(self.masonGridView, self.masonGridView.pullToRefreshView, YES);
        }
    }
}

#pragma mark - Data

- (void)setItems:(NSArray *)items userProfile:(GTIOUserProfile *)userProfile
{
    _items = [items mutableCopy];
    self.userProfile = userProfile;
    
    [self.emptyStateView removeFromSuperview];
    [self.masonGridView removeFromSuperview];
    
    // if the user's profile isn't locked or this user is us
    if (!self.userProfile.profileLocked.boolValue || [self.userProfile.user.userID isEqualToString:[GTIOUser currentUser].userID]) {
        if (_items.count > 0) {
            // display posts in mason grid
            [self.masonGridView setItems:_items postsType:self.postType];
            [self addSubview:self.masonGridView];
        } else {
            GTIOPostMasonryEmptyStateView *followingNoPosts = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:CGRectZero title:@"nothing here yet!" userName:nil locked:NO];
            [self refreshAndCenterGTIOEmptyStateView:followingNoPosts];
        }
    } else {
        NSString *userName = userProfile.user.name;
        NSString *postTypePlural = nil;
        if (self.postType == GTIOPostTypeNone) {
            postTypePlural = @"posts";
        } else if (self.postType == GTIOPostTypeHeart) {
            postTypePlural = @"hearts";
        } else if (self.postType == GTIOPostTypeStar) {
            postTypePlural = @"stars";
        }
        NSString *notFollowingTitle = [NSString stringWithFormat:@"follow %@\nto see their %@!", userName, postTypePlural];
        GTIOPostMasonryEmptyStateView *notFollowing = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:CGRectZero title:notFollowingTitle userName:userName locked:YES];
        [self refreshAndCenterGTIOEmptyStateView:notFollowing];
    }
}

- (void)refreshAndCenterGTIOEmptyStateView:(GTIOPostMasonryEmptyStateView *)emptyStateView
{

    [self.emptyStateView removeFromSuperview];
    self.emptyStateView = emptyStateView;
    [self.emptyStateView setFrame:(CGRect){ self.frame.size.width/2 - self.emptyStateView.bounds.size.width/2 , self.frame.size.height/2 - self.emptyStateView.bounds.size.height/2, self.emptyStateView.bounds.size }];
    [self addSubview:self.emptyStateView];
}

@end
