//
//  GTIOReviewsTableViewHeader.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/9/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOReviewsTableViewHeader.h"
#import "GTIOReviewsPicture.h"
#import "UIImageView+WebCache.h"

static CGFloat const kGTIOPostPictureWidthHeight = 75.0;
static CGFloat const kGTIOHeaderLeftPadding = 5.0;
static CGFloat const kGTIOHeaderTopPadding = 6.0;
static CGFloat const kGTIOUserNamePostPictureHorizontalSpacing = 8.0;
static CGFloat const kGTIOUserNamePostPictureVerticalOffset = 4.0;
static CGFloat const kGTIOUserNameLabelWidthPaddingAdjustment = 10.0;
static CGFloat const kGTIODefaultLabelHeight = 20.0;
static CGFloat const kGTIOPostedAtLabelHorizontalOffset = 1.0;
static CGFloat const kGTIOPostedAtLabelVerticalOffset = 6.0;
static CGFloat const kGTIOLeaveACommentButtonHorizontalOffset = 3.0;
static CGFloat const kGTIOLeaveACommentButtonVerticalOffset = 2.0;
static CGFloat const kGTIOLeaveACommentButtonWidth = 230.0;
static CGFloat const kGTIOLeaveACommentButtonHeight = 35.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = 0.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 4.0;

@interface GTIOReviewsTableViewHeader()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) GTIOReviewsPicture *postPicture;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *postedAtLabel;
@property (nonatomic, strong) UIImageView *badge;
@property (nonatomic, strong) GTIOUIButton *leaveACommentButton;

@end

@implementation GTIOReviewsTableViewHeader

@synthesize background = _background, postPicture = _postPicture, userNameLabel = _userNameLabel, postedAtLabel = _postedAtLabel, leaveACommentButton = _leaveACommentButton, post = _post, commentButtonTapHandler = _commentButtonTapHandler, postImageTapHandler = _postImageTapHandler, badge = _badge;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviews.top.bg.png"]];
        _background.frame = self.bounds;
        [self addSubview:_background];
        
        _postPicture = [[GTIOReviewsPicture alloc] initWithFrame:(CGRect){ kGTIOHeaderLeftPadding, kGTIOHeaderTopPadding, kGTIOPostPictureWidthHeight, kGTIOPostPictureWidthHeight } imageURL:nil];
        [self addSubview:_postPicture];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:(CGRect){ _postPicture.frame.origin.x + _postPicture.bounds.size.width + kGTIOUserNamePostPictureHorizontalSpacing, _postPicture.frame.origin.y + kGTIOUserNamePostPictureVerticalOffset, frame.size.width - _postPicture.frame.origin.x - _postPicture.frame.size.width - kGTIOUserNameLabelWidthPaddingAdjustment, kGTIODefaultLabelHeight }];
        _userNameLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0];
        _userNameLabel.textColor = [UIColor gtio_pinkTextColor];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];
        
        _postedAtLabel = [[UILabel alloc] initWithFrame:(CGRect){ _userNameLabel.frame.origin.x + kGTIOPostedAtLabelHorizontalOffset, _userNameLabel.frame.origin.y + _userNameLabel.bounds.size.height - kGTIOPostedAtLabelVerticalOffset, _userNameLabel.bounds.size.width - kGTIOPostedAtLabelHorizontalOffset, kGTIODefaultLabelHeight }];
        _postedAtLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        _postedAtLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _postedAtLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_postedAtLabel];
        
        _badge = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_badge];

        _leaveACommentButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeLeaveAComment];
        [_leaveACommentButton setFrame:(CGRect){ _userNameLabel.frame.origin.x - kGTIOLeaveACommentButtonHorizontalOffset, _postedAtLabel.frame.origin.y + _postedAtLabel.bounds.size.height + kGTIOLeaveACommentButtonVerticalOffset, kGTIOLeaveACommentButtonWidth, kGTIOLeaveACommentButtonHeight }];
        _leaveACommentButton.hidden = YES;
        [self addSubview:_leaveACommentButton];
    }
    return self;
}

- (void)setPost:(GTIOPost *)post
{
    _post = post;
    self.userNameLabel.text = _post.user.name;
    self.postedAtLabel.text = [_post.createdWhen uppercaseString];
    [self.postPicture proxySetImageWithURL:_post.photo.squareThumbnailURL];
    [self.postPicture setHasInnerShadow:YES];
    self.leaveACommentButton.hidden = NO;

    if (_post.user.badge){
        [self.badge setImageWithURL:[_post.user.badge badgeImageURLForPostOwner]];
        [self.badge setFrame:(CGRect){ self.userNameLabel.frame.origin.x + [self nameLabelSize].width + kGTIOUserBadgeHorizontalOffset, self.userNameLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset, [_post.user.badge badgeImageSizeForPostOwner]}];
    }

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

-(CGSize)nameLabelSize
{
    return [self.post.user.name sizeWithFont:self.userNameLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
}

@end
