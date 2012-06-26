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

@interface GTIOPostMasonryView()

@property (nonatomic, strong) GTIOPostMasonryEmptyStateView *emptyStateView;

@end

@implementation GTIOPostMasonryView

@synthesize user = _user, posts = _posts, postType = _postType;
@synthesize emptyStateView = _emptyStateView;

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
    
    // if we're following this user or this user is us
    if ([self.user.button.state intValue] == GTIOFollowButtonStateFollowing || [self.user.userID isEqualToString:[GTIOUser currentUser].userID]) {
        if (_posts.count > 0) {
            // display posts in mason grid
            for (GTIOPost *post in _posts) {
                NSLog(@"Post ID: %@, User: %@", post.postID, post.user.name);
            }
        } else {
            GTIOPostMasonryEmptyStateView *followingNoPosts = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:(CGRect){ 60, 80, 200, 300 } title:@"nothing here yet!" userName:nil locked:NO];
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
        GTIOPostMasonryEmptyStateView *notFollowing = [[GTIOPostMasonryEmptyStateView alloc] initWithFrame:(CGRect){ 60, 95, 200, 300 } title:notFollowingTitle userName:userName locked:YES];
        [self refreshAndCenterGTIOEmptyStateView:notFollowing];
    }
    
    NSArray *subviews = [self subviews];
    if (subviews.count > 0) {
        UIView *lastSubview = [subviews objectAtIndex:(subviews.count - 1)];
        double contentHeight = lastSubview.frame.origin.y + lastSubview.bounds.size.height + 15;
        if (contentHeight < 344) contentHeight = 344;
        [self setContentSize:(CGSize){ self.bounds.size.width, contentHeight }];
    }
}

- (void)refreshAndCenterGTIOEmptyStateView:(GTIOPostMasonryEmptyStateView *)emptyStateView
{
    [self.emptyStateView removeFromSuperview];
    self.emptyStateView = emptyStateView;
    [self addSubview:self.emptyStateView];
}

@end
