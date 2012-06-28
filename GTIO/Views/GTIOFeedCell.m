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
#import "GTIOPopOverView.h"
#import "GTIOPopOverButton.h"

static CGFloat const kGTIOFrameOriginX = 3.5f;
static CGFloat const kGTIOWhoHeartedThisOriginX = 13.0f;
static CGFloat const kGTIOWhoHeartedThisTopPadding = 2.0f;
static CGFloat const kGTIOWhoHeartedThisWidth = 250.0f;
static CGFloat const kGTIOWhoHeartedThisBottomPadding = 11.0f;
static CGFloat const kGITODotDotDotPopOverViewXOriginOffset = -3.5f;
static CGFloat const kGITODotDotDotPopOverViewYOriginOffset = -61.0f;

@interface GTIOFeedCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GTIOPostFrameView *frameView;
@property (nonatomic, strong) GTIOWhoHeartedThisView *whoHeartedThisView;
@property (nonatomic, strong) GTIOPostButtonColumnView *postButtonColumnView;

@property (nonatomic, strong) GTIOPopOverView *dotdotdotPopOverView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation GTIOFeedCell

@synthesize post = _post;
@synthesize frameView = _frameView, whoHeartedThisView = _whoHeartedThisView, postButtonColumnView = _postButtonColumnView;
@synthesize dotdotdotPopOverView = _dotdotdotPopOverView;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;

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
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [_tapGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissDotdotdotPopOverView:) name:kGTIODismissDotDotDotPopOverViewNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
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
    [self.dotdotdotPopOverView removeFromSuperview];
    self.dotdotdotPopOverView = nil;
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
        [self.postButtonColumnView setDotdotdotButtonTapHandler:^(id sender){ 
            if (!blockSelf.dotdotdotPopOverView) {
                blockSelf.dotdotdotPopOverView = [[GTIOPopOverView alloc] initWithButtonModels:_post.dotOptionsButtons];
            }
            
            [blockSelf.dotdotdotPopOverView setFrame:(CGRect){ { self.frame.size.width - blockSelf.dotdotdotPopOverView.frame.size.width + kGITODotDotDotPopOverViewXOriginOffset, self.postButtonColumnView.dotdotdotButton.frame.origin.y + kGITODotDotDotPopOverViewYOriginOffset }, blockSelf.dotdotdotPopOverView.frame.size }];
            [blockSelf addSubview:blockSelf.dotdotdotPopOverView];
        }];
    }
}

#pragma mark - NSNotifcations

- (void)dismissDotdotdotPopOverView:(NSNotification *)notification
{
    [self.dotdotdotPopOverView removeFromSuperview];
}

#pragma mark - UIGestureRecognizer

- (void)didTap:(UIGestureRecognizer *)gesture
{
    switch ([gesture state]) {
        case UIGestureRecognizerStateRecognized:
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissDotDotDotPopOverViewNotification object:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isEqual:self.postButtonColumnView.dotdotdotButton]) {
        // Disallow recognition of tap gestures in the button but do not remove overlay
        return NO;
    } else if ([[touch.view class] isSubclassOfClass:[GTIOPopOverButton class]]) {
        // Disallow recognition of tap gestures in the pop over button but do not remove overlay
        return NO;
    } else if ([[touch.view class] isSubclassOfClass:[UIButton class]]) {
        // Disallow recognition of tap gestures in the button and remove overlay
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissDotDotDotPopOverViewNotification object:nil];
        return NO;
    }
    return YES;
}

#pragma mark - Height

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post
{
    CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
    CGFloat whoHeartedThisViewHeight = [GTIOWhoHeartedThisView heightWithWhoHeartedThis:post.whoHearted];
    if (whoHeartedThisViewHeight > 0) {
        whoHeartedThisViewHeight += kGTIOWhoHeartedThisBottomPadding;
    }
    return photoFrameHeight + whoHeartedThisViewHeight;
}

@end
