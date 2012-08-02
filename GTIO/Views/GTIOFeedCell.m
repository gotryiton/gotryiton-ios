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
static CGFloat const kGTIOWhoHeartedThisTopPadding = -8.0f;
static CGFloat const kGTIOWhoHeartedThisWidth = 250.0f;
static CGFloat const kGTIOWhoHeartedThisBottomPadding = 7.0f;
static CGFloat const kGITOEllipsisPopOverViewXOriginOffset = -3.5f;
static CGFloat const kGITOEllipsisPopOverViewYOriginOffset = 13.5f;

@interface GTIOFeedCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GTIOWhoHeartedThisView *whoHeartedThisView;
@property (nonatomic, strong) GTIOPostButtonColumnView *postButtonColumnView;

@property (nonatomic, strong) GTIOPopOverView *ellipsisPopOverView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

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
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [_tapGestureRecognizer setDelegate:self];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissEllipsisPopOverView:) name:kGTIODismissEllipsisPopOverViewNotification object:nil];
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
    [self.ellipsisPopOverView removeFromSuperview];
    self.ellipsisPopOverView = nil;    
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
            if (!blockSelf.ellipsisPopOverView) {
                blockSelf.ellipsisPopOverView = [GTIOPopOverView ellipsisPopOverViewWithButtonModels:_post.dotOptionsButtons];

                [blockSelf.ellipsisPopOverView setFrame:(CGRect){ { self.frame.size.width - blockSelf.ellipsisPopOverView.frame.size.width + kGITOEllipsisPopOverViewXOriginOffset, self.postButtonColumnView.ellipsisButton.frame.origin.y - blockSelf.ellipsisPopOverView.frame.size.height + kGITOEllipsisPopOverViewYOriginOffset }, blockSelf.ellipsisPopOverView.frame.size }];
                [blockSelf addSubview:blockSelf.ellipsisPopOverView];
                
                id tapDelegate = self.delegate;
                [blockSelf.ellipsisPopOverView setTapHandler:^(GTIOButton *buttonModel) {
                    if ([tapDelegate respondsToSelector:@selector(buttonTap:)]) {
                        [tapDelegate buttonTap:buttonModel];
                    }
                }];
            }
            else {
                [blockSelf.ellipsisPopOverView removeFromSuperview];
                blockSelf.ellipsisPopOverView = nil;
            }
            
        }];
    }
}

#pragma mark - NSNotifcations

- (void)dismissEllipsisPopOverView:(NSNotification *)notification
{
    [self.ellipsisPopOverView removeFromSuperview];
    self.ellipsisPopOverView = nil;
}

#pragma mark - UIGestureRecognizer

- (void)didTap:(UIGestureRecognizer *)gesture
{
    switch ([gesture state]) {
        case UIGestureRecognizerStateRecognized:
            [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isEqual:self.postButtonColumnView.ellipsisButton]) {
        // Disallow recognition of tap gestures in the button but do not remove overlay
        return NO;
    } else if ([[touch.view class] isSubclassOfClass:[GTIOPopOverButton class]]) {
        // Disallow recognition of tap gestures in the pop over button but do not remove overlay
        return NO;
    } else if ([[touch.view class] isSubclassOfClass:[UIButton class]]) {
        // Disallow recognition of tap gestures in the button and remove overlay
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIODismissEllipsisPopOverViewNotification object:nil];
        return NO;
    } 
    return YES;
}

#pragma mark - Height

+ (CGFloat)cellHeightWithPost:(GTIOPost *)post
{
    CGFloat photoFrameHeight = [GTIOPostFrameView heightWithPost:post];
    CGFloat whoHeartedThisViewHeight = [GTIOWhoHeartedThisView heightWithWhoHeartedThis:post.whoHearted];

    return photoFrameHeight + whoHeartedThisViewHeight + kGTIOWhoHeartedThisBottomPadding;
}

@end
