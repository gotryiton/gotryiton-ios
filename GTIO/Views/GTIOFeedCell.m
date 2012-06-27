//
//  GTIOFeedCell.m
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedCell.h"

#import "GTIOPostFrameView.h"
#import "GTIOWhoHeartedThisView.h"

static CGFloat const kGTIOFrameOriginX = 3.5f;
static CGFloat const kGTIOWhoHeartedThisOriginX = 13.0f;
static CGFloat const kGTIOWhoHeartedThisTopPadding = 2.0f;
static CGFloat const kGTIOWhoHeartedThisWidth = 250.0f;
static CGFloat const kGTIOWhoHeartedThisBottomPadding = 11.0f;

@interface GTIOFeedCell ()

@property (nonatomic, strong) GTIOPostFrameView *frameView;
@property (nonatomic, strong) GTIOWhoHeartedThisView *whoHeartedThisView;

@end

@implementation GTIOFeedCell

@synthesize post = _post;
@synthesize frameView = _frameView, whoHeartedThisView = _whoHeartedThisView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setClipsToBounds:YES];
        
        // Post Frame View
        _frameView = [[GTIOPostFrameView alloc] initWithFrame:(CGRect){ 3.5, 0, CGSizeZero }];
        [self.contentView addSubview:_frameView];
        
        // Who Hearted this View
        _whoHeartedThisView = [[GTIOWhoHeartedThisView alloc] initWithFrame:(CGRect){ kGTIOWhoHeartedThisOriginX, 0, CGSizeZero }];
        [self.contentView addSubview:_whoHeartedThisView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)prepareForReuse
{
    [self.frameView prepareForReuse];
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    if (_post != post) {
        _post = post;
        
        [self.frameView setPost:_post];
        
        CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
        [self.whoHeartedThisView setWhoHeartedThisButtons:_post.buttons];
        [self.whoHeartedThisView setFrame:(CGRect){ { self.whoHeartedThisView.frame.origin.x, self.frameView.frame.origin.y + photoFrameHeight + kGTIOWhoHeartedThisTopPadding }, { kGTIOWhoHeartedThisWidth, self.whoHeartedThisView.frame.size.height } }];
    }
}

#pragma mark - Height

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post
{
    CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
    CGFloat whoHeartedThisViewHeight = [GTIOWhoHeartedThisView heightWithWhoHeartedThisButtons:post.whoHeartedButtons];
    if (whoHeartedThisViewHeight > 0) {
        whoHeartedThisViewHeight += kGTIOWhoHeartedThisBottomPadding;
    }
    return photoFrameHeight + whoHeartedThisViewHeight;
}

@end
