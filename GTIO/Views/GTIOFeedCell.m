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
#import "GTIOPostButtonColumnView.h"
#import "GTIOPopOverButton.h"

static CGFloat const kGTIOFrameOriginX = 3.5f;
static CGFloat const kGTIOWhoHeartedThisOriginX = 13.0f;
static CGFloat const kGTIOWhoHeartedThisTopPadding = -8.0f;
static CGFloat const kGTIOWhoHeartedThisWidth = 250.0f;
static CGFloat const kGTIOWhoHeartedThisBottomPadding = 7.0f;

@interface GTIOFeedCell () <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) GTIOWhoHeartedThisView *whoHeartedThisView;
@property (nonatomic, strong) GTIOPostButtonColumnView *postButtonColumnView;

@end

@implementation GTIOFeedCell

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
        
        // Right column button view
        _postButtonColumnView = [[GTIOPostButtonColumnView alloc] initWithFrame:(CGRectZero)];
        [self.contentView addSubview:_postButtonColumnView];
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)prepareForReuse
{
    [self.postButtonColumnView prepareForReuse];
    [self.frameView prepareForReuse];
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    if (_post != post) {
        _post = post;
        
        [self.frameView setPost:_post];
        
        CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
        [self.whoHeartedThisView setWhoHeartedThis:_post.whoHearted];
        [self.whoHeartedThisView setFrame:(CGRect){ { self.whoHeartedThisView.frame.origin.x, self.frameView.frame.origin.y + photoFrameHeight + kGTIOWhoHeartedThisTopPadding }, { kGTIOWhoHeartedThisWidth, photoFrameHeight } }];
        
        CGFloat postButtonColumnViewOriginX = self.frameView.frame.origin.x + self.frameView.frame.size.width;
        [self.postButtonColumnView setFrame:(CGRect){ { postButtonColumnViewOriginX, 0 }, { self.frame.size.width - postButtonColumnViewOriginX, self.frame.size.height } }];
        [self.postButtonColumnView setPost:_post];
        __block typeof(self) blockSelf = self;

        [self.postButtonColumnView setEllipsisButtonTapHandler:^(id sender){ 
            
            id tapDelegate = self.delegate;
            blockSelf.actionSheet = [[GTIOActionSheet alloc] initWithButtons:_post.dotOptionsButtons buttonTapHandler:^(GTIOActionSheet *actionSheet, GTIOButton *buttonModel) {
                [actionSheet dismiss];
                if ([tapDelegate respondsToSelector:@selector(buttonTap:)]) {
                    buttonModel.postID = blockSelf.post.postID;
                    [tapDelegate buttonTap:buttonModel];
                }
            }];

            [blockSelf.actionSheet showWithConfigurationBlock:^(GTIOActionSheet *actionSheet) {
                actionSheet.didDismiss = ^(GTIOActionSheet *actionSheet) {
                    if (!actionSheet.wasCancelled) {
                        
                    }
                };
            }];

        }];
    }
}


#pragma mark - Height

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post
{
    CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
    CGFloat whoHeartedThisViewHeight = [GTIOWhoHeartedThisView heightWithWhoHeartedThis:post.whoHearted];

    return photoFrameHeight + whoHeartedThisViewHeight + kGTIOWhoHeartedThisBottomPadding;
}

@end
