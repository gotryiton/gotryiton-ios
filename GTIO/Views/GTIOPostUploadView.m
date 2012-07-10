//
//  GTIOPostUploadView.m
//  GTIO
//
//  Created by Scott Penrose on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostUploadView.h"

#import "SDWebImageManager.h"

#import "UIImage+Mask.h"
#import "UIImage+Blend.h"
#import "UIImage+Resize.h"

#import "GTIOUser.h"
#import "GTIOPostHeaderView.h"

static CGFloat const kGTIOPadding = 7.0f;
static CGFloat const kGTIOAccentLineGap = 28.0f;
static CGFloat const kGTIOTextAreaWidth = 213.0f;
static CGFloat const kGTIOTextYOrigin = 23.0f;

@interface GTIOPostUploadView () <SDWebImageManagerDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconFrameImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *doneLabel;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) GTIOUIButton *retryButton;

@end

@implementation GTIOPostUploadView

@synthesize iconImageView = _iconImageView, iconFrameImageView = _iconFrameImageView, statusLabel = _statusLabel, doneLabel = _doneLabel, shadowImageView = _shadowImageView, progressView = _progressView;
@synthesize showingShadow = _showingShadow, clearBackground = _clearBackground;
@synthesize state = _state, progress = _progress;
@synthesize retryButton = _retryButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Background
        [self setBackgroundColor:[UIColor clearColor]];
        _clearBackground = YES;
        
        // Shadow
        _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header-shadow.png"]];
        [_shadowImageView setFrame:(CGRect){ { 0, self.frame.size.height }, _shadowImageView.image.size }];
        
        // User Icon
        _iconFrameImageView = [[UIImageView alloc] initWithFrame:_iconImageView.frame];
        [_iconFrameImageView setImage:[UIImage imageNamed:@"user-pic-84-shadow-overlay.png"]];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:(CGRect){ kGTIOPadding, kGTIOPadding, 42, 42 }];
        [[SDWebImageManager sharedManager] downloadWithURL:[GTIOUser currentUser].icon delegate:self options:0 success:^(UIImage *image) {
            UIImage *maskedImage = [image maskImageWithMask:[UIImage imageNamed:@"user-pic-84-mask.png"]];
            [self.iconImageView setImage:maskedImage];
            [self addSubview:self.iconFrameImageView];
        } failure:nil];
        [self addSubview:_iconImageView];
        
        // Text Background Images
        UIImageView *nameBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-info-bg.png"]];
        [nameBGImageView setFrame:(CGRect){ { _iconImageView.frame.origin.y + _iconImageView.frame.size.width + kGTIOPadding, kGTIOPadding }, nameBGImageView.image.size }];
        [self addSubview:nameBGImageView];
        
        // Status Label
        _statusLabel = [[UILabel alloc] initWithFrame:(CGRect){ nameBGImageView.frame.origin.x + kGTIOPadding, kGTIOTextYOrigin, kGTIOTextAreaWidth - 2 * kGTIOPadding, 20 }];
        [_statusLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:11.0f]];
        [_statusLabel setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [_statusLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_statusLabel];
        
        // Done Label
        _doneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_doneLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:11.0f]];
        [_doneLabel setTextColor:[UIColor gtio_grayTextColor585858]];
        [_doneLabel setTextAlignment:UITextAlignmentRight];
        [_doneLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_doneLabel];
        
        // Progress Slider
        _progressView = [[UIProgressView alloc] initWithFrame:(CGRect){ nameBGImageView.frame.origin.x + 5, 37, 204, 5 }];
        [_progressView setTrackImage:[UIImage imageNamed:@"uploading.min.track.png"]];
        [_progressView setProgressImage:[[UIImage imageNamed:@"uploading.max.track.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 3, 3, 3, 3 }]];
        [self addSubview:_progressView];
        
        _retryButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePostRetry tapHandler:^(id sender) {
            NSLog(@"Retry post");
            [[GTIOPostManager sharedManager] retry];
        }];
        [_retryButton setFrame:(CGRect){ _iconImageView.frame.origin, _retryButton.frame.size }];
        
        // Accent line
        UIImageView *accentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [accentLine setFrame:(CGRect){ { self.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, 0 }, { accentLine.image.size.width, self.frame.size.height } }];
        [self addSubview:accentLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.statusLabel sizeToFit];
    [self.doneLabel setFrame:(CGRect){ _statusLabel.frame.origin.x + _statusLabel.frame.size.width + kGTIOPadding + 2, kGTIOTextYOrigin, kGTIOTextAreaWidth - _statusLabel.frame.size.width - 3 * kGTIOPadding, self.statusLabel.frame.size.height }];
}

- (void)prepareForReuse
{
    [self.iconFrameImageView removeFromSuperview];
}

#pragma mark - Properties

- (void)setState:(GTIOPostState)state
{
    _state = state;
    
    NSString *status = @"";
    NSString *done = @"";
    [self.retryButton removeFromSuperview];
    
    switch (_state) {
        case GTIOPostStateUploadingImage:
            status = @"your post is uploading...";
            break;
        case GTIOPostStateUploadingImageComplete:
            status = @"finalizing...";
            break;
        case GTIOPostStateSavingPost:
            status = @"finalizing...";
            break;
        case GTIOPostStateComplete:
            status = @"finalizing...";
            done = @"done!";
            break;
        case GTIOPostStateError:
            status = @"upload failed. retry?";
            [self addSubview:self.retryButton];
            break;
        default:
            break;
    }
    
    [self.statusLabel setText:status];
    [self.doneLabel setText:done];
    
    [self setNeedsLayout];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self.progressView setProgress:_progress animated:YES];
}

- (void)setShowingShadow:(BOOL)showingShadow
{
    _showingShadow = showingShadow;
    if (_showingShadow) {
        [self addSubview:self.shadowImageView];
    } else {
        [self.shadowImageView removeFromSuperview];
    }
}

- (void)setClearBackground:(BOOL)clearBackground
{
    _clearBackground = clearBackground;
    if (_clearBackground) {
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
    }
}

@end

