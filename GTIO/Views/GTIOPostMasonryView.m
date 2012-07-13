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

@synthesize userProfile = _userProfile, posts = _posts, postType = _postType;
@synthesize emptyStateView = _emptyStateView;
@synthesize masonGridView = _masonGridView;

- (id)initWithGTIOPostType:(GTIOPostType)postType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        _postType = postType;
        _masonGridView = [[GTIOMasonGridView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setPosts:(NSArray *)posts userProfile:(GTIOUserProfile *)userProfile
{
    _posts = posts;
    self.userProfile = userProfile;
    
    [self.emptyStateView removeFromSuperview];
    [self.masonGridView removeFromSuperview];
    
    // if the user's profile isn't locked or this user is us
    if (!self.userProfile.profileLocked.boolValue || [self.userProfile.user.userID isEqualToString:[GTIOUser currentUser].userID]) {
        if (_posts.count > 0) {
            // display posts in mason grid
            [self.masonGridView setPosts:posts postsType:self.postType];
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

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.emptyStateView setFrame:(CGRect){ 60, 90, self.emptyStateView.bounds.size }];
    [self.masonGridView setFrame:(CGRect){ kGTIOLeftPadding, kGTIOTopPadding, self.bounds.size.width - kGTIOLeftPadding, self.bounds.size.height - kGTIOTopPadding }];
}

- (void)refreshAndCenterGTIOEmptyStateView:(GTIOPostMasonryEmptyStateView *)emptyStateView
{
    [self.emptyStateView removeFromSuperview];
    self.emptyStateView = emptyStateView;
    [self addSubview:self.emptyStateView];
}

@end
