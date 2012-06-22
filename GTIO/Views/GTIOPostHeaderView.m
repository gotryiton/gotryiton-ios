//
//  GTIOPostHeaderView.m
//  GTIO
//
//  Created by Scott Penrose on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostHeaderView.h"

#import "SDWebImageManager.h"

#import "UIImage+Mask.h"
#import "UIImage+Blend.h"
#import "UIImage+Resize.h"

static CGFloat const kGTIOPadding = 7.0f;
static CGFloat const kGTIOAccessLinePixelsFromRightSizeOfScreen = 25.0f;
static CGFloat const kGTIOAccessLineGap = 28.0f;

@interface GTIOPostHeaderView () <SDWebImageManagerDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconFrameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *createdAtLabel;
@property (nonatomic, strong) UIImageView *shadowImageView;

@end

@implementation GTIOPostHeaderView

@synthesize post = _post;
@synthesize iconImageView = _iconImageView, iconFrameImageView = _iconFrameImageView, nameLabel = _nameLabel, locationLabel = _locationLabel, createdAtLabel = _createdAtLabel, shadowImageView = _shadowImageView;
@synthesize showingShadow = _showingShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Background
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"checkered-bg.png"]]];
        
        // Shadow
        _shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header-shadow.png"]];
        [_shadowImageView setFrame:(CGRect){ { 0, self.frame.size.height }, _shadowImageView.image.size }];
        
        // User Icon
        _iconImageView = [[UIImageView alloc] initWithFrame:(CGRect){ kGTIOPadding, kGTIOPadding, 42, 42 }];
        [self addSubview:_iconImageView];
        
        _iconFrameImageView = [[UIImageView alloc] initWithFrame:_iconImageView.frame];
        [_iconFrameImageView setImage:[UIImage imageNamed:@"user-pic-84-shadow-overlay.png"]];
        
        // Text Background Images
        UIImageView *nameBGImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-info-bg.png"]];
        [nameBGImageView setFrame:(CGRect){ { _iconImageView.frame.origin.y + _iconImageView.frame.size.width + kGTIOPadding, kGTIOPadding }, nameBGImageView.image.size }];
        [self addSubview:nameBGImageView];
        
        // Name and Location Labels
        _nameLabel = [[UILabel alloc] initWithFrame:(CGRect){ nameBGImageView.frame.origin.x + kGTIOPadding, 0, nameBGImageView.frame.size.width - 2 * kGTIOPadding, 20 }];
        [_nameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0f]];
        [_nameLabel setTextColor:[UIColor gtio_pinkTextColor]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nameLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:(CGRect){ nameBGImageView.frame.origin.x + kGTIOPadding, 0, nameBGImageView.frame.size.width - 2 * kGTIOPadding, 20 }];
        [_locationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0f]];
        [_locationLabel setTextColor:[UIColor gtio_darkGrayTextColor]];
        [_locationLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_locationLabel];
        
        // Accent line
        CGFloat accessLineOriginX = self.frame.size.width - kGTIOAccessLinePixelsFromRightSizeOfScreen;
        
        UIImageView *topAccessLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [topAccessLine setFrame:(CGRect){ { accessLineOriginX, 0 }, { topAccessLine.image.size.width, 11 } }];
        [self addSubview:topAccessLine];
        
        UIImageView *topAccessLineCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line-separator-top.png"]];
        [topAccessLineCap setFrame:(CGRect){ { accessLineOriginX - ((topAccessLineCap.image.size.width - 2) / 2), topAccessLine.frame.origin.y + topAccessLine.frame.size.height }, topAccessLineCap.image.size }];
        [self addSubview:topAccessLineCap];
        
        UIImageView *bottomAccessLineCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line-separator-bottom.png"]];
        [bottomAccessLineCap setFrame:(CGRect){ { topAccessLineCap.frame.origin.x, topAccessLineCap.frame.origin.y + topAccessLineCap.frame.size.height + kGTIOAccessLineGap }, bottomAccessLineCap.image.size }];
        [self addSubview:bottomAccessLineCap];
        
        UIImageView *bottomAccessLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [bottomAccessLine setFrame:(CGRect){ { accessLineOriginX, bottomAccessLineCap.frame.origin.y + bottomAccessLineCap.frame.size.height }, { bottomAccessLine.image.size.width, 11 } }];
        [self addSubview:bottomAccessLine];
        
        // Created At Label
        CGFloat createdAtPadding = kGTIOPadding - 3;
        CGFloat createdAtOriginX = nameBGImageView.frame.origin.x + nameBGImageView.frame.size.width + createdAtPadding;
        _createdAtLabel = [[UILabel alloc] initWithFrame:(CGRect){ createdAtOriginX, (self.frame.size.height - kGTIOAccessLineGap) / 2, self.frame.size.width - createdAtOriginX - (kGTIOPadding - createdAtPadding), kGTIOAccessLineGap }];
        [_createdAtLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:10.0f]];
        [_createdAtLabel setTextColor:[UIColor gtio_grayTextColor]];
        [_createdAtLabel setTextAlignment:UITextAlignmentCenter];
        [_createdAtLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_createdAtLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat nameLocationOriginY = 12.0f;
    CGFloat locationOriginY = 31.0f;
    if ([self.post.user.location length] == 0) {
        nameLocationOriginY = 27.0f;
    }
    
    [self.nameLabel setFrame:(CGRect){ { self.nameLabel.frame.origin.x, nameLocationOriginY }, self.nameLabel.frame.size }];
    [self.locationLabel setFrame:(CGRect){ { self.locationLabel.frame.origin.x, locationOriginY }, self.locationLabel.frame.size }];
}

- (void)prepareForReuse
{
    [self.iconFrameImageView removeFromSuperview];
}

#pragma mark - Properties

- (void)setPost:(GTIOPost *)post
{
    _post = post;
    
    [[SDWebImageManager sharedManager] downloadWithURL:_post.user.icon delegate:self options:0 success:^(UIImage *image) {
        UIImage *maskedImage = [image maskImageWithMask:[UIImage imageNamed:@"user-pic-84-mask.png"]];
        [self.iconImageView setImage:maskedImage];
        [self addSubview:self.iconFrameImageView];
    } failure:nil];
    
    [self.nameLabel setText:_post.user.name];
    [self.nameLabel sizeToFit];

    if ([_post.user.location length] > 0) {
        [self.locationLabel setHidden:NO];
        [self.locationLabel setText:[_post.user.location uppercaseString]];
        [self.locationLabel sizeToFit];
    } else {
        [self.locationLabel setHidden:YES];
    }
    
    [self.createdAtLabel setText:_post.createdWhen];
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

@end
