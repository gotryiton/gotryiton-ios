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
#import "GTIOMasonGridView.h"

@interface GTIOPostMasonryView()

@property (nonatomic, strong) GTIOPostMasonryEmptyStateView *emptyStateView;
@property (nonatomic, strong) GTIOMasonGridView *masonGridView;

@end

@implementation GTIOPostMasonryView

@synthesize user = _user, posts = _posts, postType = _postType;
@synthesize emptyStateView = _emptyStateView;
@synthesize masonGridView = _masonGridView;

- (id)initWithGTIOPostType:(GTIOPostType)postType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = YES;
        _postType = postType;
    }
    return self;
}

- (void)setPosts:(NSArray *)posts user:(GTIOUser *)user
{
    _posts = posts;
    self.user = user;
    
    [self.emptyStateView removeFromSuperview];
    [self.masonGridView removeFromSuperview];
    
    // if we're following this user or this user is us
    if ([self.user.button.state intValue] == GTIOFollowButtonStateFollowing || [self.user.userID isEqualToString:[GTIOUser currentUser].userID]) {
        if (_posts.count > 0) {
            // display posts in mason grid
            self.masonGridView = [[GTIOMasonGridView alloc] initWithFrame:CGRectZero];
            [self.masonGridView setPosts:posts postsType:self.postType];
            [self addSubview:self.masonGridView];
        } else {
            GTIOPostMasonryEmptyStateView *followingNoPosts = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:CGRectZero title:@"nothing here yet!" userName:nil locked:NO];
            [self refreshAndCenterGTIOEmptyStateView:followingNoPosts];
        }
    } else {
        NSString *userName = user.name;
        NSString *userGenderQualifier = ([user.gender isEqualToString:@"female"]) ? @"her" : @"his";
        NSString *postTypePlural = nil;
        if (self.postType == GTIOPostTypeNone) {
            postTypePlural = @"posts";
        } else if (self.postType == GTIOPostTypeHeart) {
            postTypePlural = @"hearts";
        } else if (self.postType == GTIOPostTypeStar) {
            postTypePlural = @"stars";
        }
        NSString *notFollowingTitle = [NSString stringWithFormat:@"follow %@\nto see %@ %@!", userName, userGenderQualifier, postTypePlural];
        GTIOPostMasonryEmptyStateView *notFollowing = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:CGRectZero title:notFollowingTitle userName:userName locked:YES];
        [self refreshAndCenterGTIOEmptyStateView:notFollowing];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.emptyStateView setFrame:(CGRect){ 60, 90, self.emptyStateView.bounds.size }];
    [self.masonGridView setFrame:(CGRect){ 7, 9, self.bounds.size.width - 7, self.bounds.size.height - 9 }];
}

- (void)refreshAndCenterGTIOEmptyStateView:(GTIOPostMasonryEmptyStateView *)emptyStateView
{
    [self.emptyStateView removeFromSuperview];
    self.emptyStateView = emptyStateView;
    [self addSubview:self.emptyStateView];
}

@end
