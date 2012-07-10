//
//  GTIOReviewsTableViewHeader.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsTableViewHeader.h"
#import "GTIOReviewsPicture.h"

@interface GTIOReviewsTableViewHeader()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) GTIOReviewsPicture *postPicture;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;
@property (nonatomic, strong) GTIOUIButton *leaveACommentButton;

@end

@implementation GTIOReviewsTableViewHeader

@synthesize background = _background, postPicture = _postPicture, userNameLabel = _userNameLabel, postedAtLabel = _postedAtLabel, leaveACommentButton = _leaveACommentButton, post = _post, commentButtonTapHandler = _commentButtonTapHandler, postImageTapHandler = _postImageTapHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.top.bg.png"]];
        _background.frame = (CGRect){ 0, 0, frame.size };
        [self addSubview:_background];
        
        _postPicture = [[GTIOReviewsPicture alloc] initWithFrame:(CGRect){ 5, 6, 75, 75 } imageURL:nil];
        [self addSubview:_postPicture];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:(CGRect){ _postPicture.frame.origin.x + _postPicture.bounds.size.width + 8, _postPicture.frame.origin.y + 4, frame.size.width - _postPicture.frame.origin.x - _postPicture.frame.size.width - 10, 20 }];
        _userNameLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:(CGRect){ _userNameLabel.frame.origin.x + 1, _userNameLabel.frame.origin.y + _userNameLabel.bounds.size.height - 6, _userNameLabel.bounds.size.width - 1, 20 }];
        _postedAtLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postedAtLabel];
        
        _leaveACommentButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeLeaveAComment];
        [_leaveACommentButton setFrame:(CGRect){ _userNameLabel.frame.origin.x - 3, _postedAtLabel.frame.origin.y + _postedAtLabel.bounds.size.height + 2, 230, 35 }];
        _leaveACommentButton.hidden = YES;
        [self addSubview:_leaveACommentButton];
    }
    return self;
}

- (void)setPost:(GTIOPost *)post
{
    _post = post;
    self.userNameLabel.text = _post.user.name;
    self.postedAtLabel.text = _post.createdWhen;
    [self.postPicture proxySetImageWithURL:_post.photo.squareThumbnailURL];
    [self.postPicture setHasInnerShadow:YES];
    self.leaveACommentButton.hidden = NO;
}

- (void)setCommentButtonTapHandler:(GTIOButtonDidTapHandler)commentButtonTapHandler
{
    _commentButtonTapHandler = commentButtonTapHandler;
    self.leaveACommentButton.tapHandler = _commentButtonTapHandler;
}

- (void)setPostImageTapHandler:(GTIOButtonDidTapHandler)postImageTapHandler
{
    _postImageTapHandler = postImageTapHandler;
    self.postPicture.invisiButtonTapHandler = postImageTapHandler;
}

@end
