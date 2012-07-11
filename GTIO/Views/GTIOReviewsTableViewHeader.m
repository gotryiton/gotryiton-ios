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
        _background.frame = self.bounds;
        [self addSubview:_background];
        
        double static const postPictureWidthHeight = 75.0;
        double static const headerLeftPadding = 5.0;
        double static const headerTopPadding = 6.0;
        double static const userNamePostPictureHorizontalSpacing = 8.0;
        double static const userNamePostPictureVerticalOffset = 4.0;
        double static const userNameLabelWidthPaddingAdjustment = 10.0;
        double static const defaultLabelHeight = 20.0;
        double static const postedAtLabelHorizontalOffset = 1.0;
        double static const postedAtLabelVerticalOffset = 6.0;
        double static const leaveACommentButtonHorizontalOffset = 3.0;
        double static const leaveACommentButtonVerticalOffset = 2.0;
        double static const leaveACommentButtonWidth = 230.0;
        double static const leaveACommentButtonHeight = 35.0;
        
        _postPicture = [[GTIOReviewsPicture alloc] initWithFrame:(CGRect){ headerLeftPadding, headerTopPadding, postPictureWidthHeight, postPictureWidthHeight } imageURL:nil];
        [self addSubview:_postPicture];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:(CGRect){ _postPicture.frame.origin.x + _postPicture.bounds.size.width + userNamePostPictureHorizontalSpacing, _postPicture.frame.origin.y + userNamePostPictureVerticalOffset, frame.size.width - _postPicture.frame.origin.x - _postPicture.frame.size.width - userNameLabelWidthPaddingAdjustment, defaultLabelHeight }];
        _userNameLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:(CGRect){ _userNameLabel.frame.origin.x + postedAtLabelHorizontalOffset, _userNameLabel.frame.origin.y + _userNameLabel.bounds.size.height - postedAtLabelVerticalOffset, _userNameLabel.bounds.size.width - postedAtLabelHorizontalOffset, defaultLabelHeight }];
        _postedAtLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postedAtLabel];
        
        _leaveACommentButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeLeaveAComment];
        [_leaveACommentButton setFrame:(CGRect){ _userNameLabel.frame.origin.x - leaveACommentButtonHorizontalOffset, _postedAtLabel.frame.origin.y + _postedAtLabel.bounds.size.height + leaveACommentButtonVerticalOffset, leaveACommentButtonWidth, leaveACommentButtonHeight }];
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
    _commentButtonTapHandler = [commentButtonTapHandler copy];
    self.leaveACommentButton.tapHandler = _commentButtonTapHandler;
}

- (void)setPostImageTapHandler:(GTIOButtonDidTapHandler)postImageTapHandler
{
    _postImageTapHandler = [postImageTapHandler copy];
    self.postPicture.invisibleButtonTapHandler = _postImageTapHandler;
}

@end
