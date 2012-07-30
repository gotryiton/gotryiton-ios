//
//  GTIOTagCell.m
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOTagCell.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

static CGFloat const kGTIOTitlePadding = 17.0f;
static CGFloat const kGTIOImageSize = 19.0f;
static CGFloat const kGTIOImageTitlePadding = 10.0f;

@interface GTIOTagCell () <SDWebImageManagerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation GTIOTagCell

@synthesize gtioTag = _gtioTag;
@synthesize titleLabel = _titleLabel, iconImageView = _iconImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:16.0f]];
        [_titleLabel setTextColor:[UIColor gtio_grayTextColor8F8F8F]];
        [self.contentView addSubview:_titleLabel];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_iconImageView];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        [selectedBackgroundView setBackgroundColor:[UIColor gtio_selectedCellBGColorC6F0DE]];
        [self setSelectedBackgroundView:selectedBackgroundView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.iconImageView.image) {
        [self.iconImageView setFrame:(CGRect){ { kGTIOTitlePadding, (self.frame.size.height - kGTIOImageSize) / 2 }, { kGTIOImageSize, kGTIOImageSize } }];
        [self.titleLabel setFrame:(CGRect){ self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + kGTIOImageTitlePadding, self.titleLabel.frame.origin.y, self.titleLabel.frame.size }];
    } else {
        [self.titleLabel setFrame:(CGRect){ { kGTIOTitlePadding, kGTIOTitlePadding }, { 200, 20 } }];
        [self.iconImageView setFrame:(CGRect){ { kGTIOTitlePadding, 0 }, CGSizeZero }];
    }
}

#pragma mark - Properties

- (void)setGtioTag:(GTIOTag *)gtioTag
{
    if (_gtioTag != gtioTag) {
        _gtioTag = gtioTag;
        
        [self.titleLabel setText:_gtioTag.text];
        
        if (_gtioTag.iconURL) {
            [[SDWebImageManager sharedManager] downloadWithURL:_gtioTag.iconURL delegate:self];
        }
    }
}

#pragma mark - SDWebImageManagerDelegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self.iconImageView setImage:image];
    [self setNeedsLayout];
}

@end
