//
//  GTIOConnectTableViewCell.m
//  GTIO
//
//  Created by Simon Holroyd on 11/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOConnectTableViewCell.h"
#import "GTIOSelectableProfilePicture.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIImage+Mask.h"
#import "UIImage+Blend.h"
#import "GTIOUser.h"
#import "GTIOPost.h"

static CGFloat const kGTIORightPadding = 8.0;
static CGFloat const kGTIOTopPadding = 3.0;
static CGFloat const kGTIOBottomPadding = 3.0;
static CGFloat const kGTIOProfilePictureSize = 42.0;
static CGFloat const kGTIOProfilePictureRightPadding = 10.0;
static CGFloat const kGTIONameLabelXPosition = 7.0;
static CGFloat const kGTIONameLabelYPosition = 11.0;
static CGFloat const kGTIOBottomBorderVerticalOffset = 1.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = -2.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 4.0;

static CGFloat const kGTIOOutfitThumbSize = 70.0;
static int const kGTIOMaxThumbnails = 4;

@interface GTIOConnectTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconFrameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) GTIOUIButton *followingButton;
@property (nonatomic, strong) GTIOUIButton *followButton;
@property (nonatomic, strong) GTIOUIButton *requestedButton;

@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UIImageView *separatorImage;

@property (nonatomic, strong) NSMutableArray *postThumbnails;
@property (nonatomic, strong) NSMutableArray *postThumbnailOverlays;

@end

@implementation GTIOConnectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // User Icon
        _iconImageView = [[UIImageView alloc] initWithFrame:(CGRect){ kGTIORightPadding, kGTIOTopPadding, kGTIOProfilePictureSize, kGTIOProfilePictureSize }];
        [self.contentView addSubview:_iconImageView];

        _iconFrameImageView = [[UIImageView alloc] initWithFrame:_iconImageView.frame];
        [_iconFrameImageView setImage:[UIImage imageNamed:@"user-pic-84-shadow-overlay.png"]];

        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect-info-bg.png"]];
        [_backgroundImage setFrame:(CGRect){{kGTIORightPadding+kGTIOProfilePictureSize+kGTIORightPadding, kGTIOTopPadding}, _backgroundImage.bounds.size }];
        [self.contentView addSubview:_backgroundImage];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0];
        _nameLabel.textColor = [UIColor gtio_pinkTextColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];

        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _locationLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_locationLabel];

        _postThumbnails = [[NSMutableArray alloc] initWithObjects:nil];
        _postThumbnailOverlays = [[NSMutableArray alloc] initWithObjects:nil];
        for (int i = 0; i<kGTIOMaxThumbnails; i++ ){
            UIImageView *thumb = [[UIImageView alloc] initWithFrame:(CGRect){ kGTIORightPadding + i * (kGTIORightPadding + kGTIOOutfitThumbSize) , _backgroundImage.frame.origin.y + _backgroundImage.frame.size.height + kGTIORightPadding, kGTIOOutfitThumbSize, kGTIOOutfitThumbSize }];
            [thumb setHidden:YES];
            [_postThumbnails addObject:thumb];
            [self.contentView addSubview:thumb];

            UIImageView *overlay = [[UIImageView alloc] initWithFrame:thumb.frame];
            [overlay setHidden:YES];
            [overlay setImage:[UIImage imageNamed:@"connect-thumb-overlay-70.png"]];
            [_postThumbnailOverlays addObject:overlay];
            [self.contentView addSubview:overlay];
        }

        _separatorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect-separator.png"]];
        [self.contentView addSubview:_separatorImage];

        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.nameLabel.text = @"";
    self.locationLabel.text = @"";
    [self.iconFrameImageView removeFromSuperview];

    // self.followButton.userInteractionEnabled = YES;
    // self.followingButton.userInteractionEnabled = YES;
    // self.requestedButton.userInteractionEnabled = YES;
    // [self.requestedButton setSelected:NO];
    // [self.followingButton setSelected:NO];
    // [self.followButton setSelected:NO];
    // [self.badgeImageView setFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // [self.followingButton setFrame:(CGRect){ self.bounds.size.width - self.followingButton.bounds.size.width - kGTIORightPadding, 9, self.followingButton.bounds.size }];
    // [self.followButton setFrame:(CGRect){ self.bounds.size.width - self.followButton.bounds.size.width - kGTIORightPadding, 9, self.followButton.bounds.size }];
    // [self.requestedButton setFrame:(CGRect){ self.bounds.size.width - self.requestedButton.bounds.size.width - kGTIORightPadding, 9, self.requestedButton.bounds.size }];
    
    double nameLabelYPosition = ([self.user.location length] > 0) ? 5 : 13;
    [self.nameLabel setFrame:(CGRect){ self.backgroundImage.frame.origin.x + kGTIONameLabelXPosition, self.backgroundImage.frame.origin.y + nameLabelYPosition, 250, 17 }];
    
    
    [self.locationLabel setFrame:(CGRect){ self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, 250, 10 }];


    [self.separatorImage setFrame:(CGRect){ 0, self.backgroundImage.frame.origin.y + self.backgroundImage.frame.size.height + kGTIORightPadding + kGTIOOutfitThumbSize + kGTIOBottomPadding , self.contentView.frame.size.width, self.separatorImage.bounds.size.height }];
    // [self.bottomBorder setFrame:(CGRect){ 0, self.contentView.bounds.size.height - kGTIOBottomBorderVerticalOffset, self.contentView.bounds.size.width, 1 }];

    // if (self.user.badge) {
    //     [self.badgeImageView setFrame:(CGRect){ (self.nameLabel.frame.origin.x + [self nameLabelSize].width + kGTIOUserBadgeHorizontalOffset), (self.nameLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset), [self.user.badge badgeImageSizeForUserList] }];
    // }

//    [self activeFollowButton];
}


- (void)setUser:(GTIOUser *)user
{
    if (![_user isEqual:user]) {
        _user = user;
    }

    [[SDWebImageManager sharedManager] downloadWithURL:_user.icon delegate:self options:0 success:^(UIImage *image, BOOL cached) {
        UIImage *maskedImage = [image maskImageWithMask:[UIImage imageNamed:@"user-pic-84-mask.png"]];
        [self.iconImageView setImage:maskedImage];
        [self addSubview:self.iconFrameImageView];
    } failure:nil];

    self.nameLabel.text = _user.name;
    self.locationLabel.text = [_user.location uppercaseString];
    
    
    for (int i = 0; i<kGTIOMaxThumbnails; i++ ){
        GTIOPost *post;
        if (_user.recentPostThumbnails.count > i){
            post = (GTIOPost *)[_user.recentPostThumbnails objectAtIndex:i];
        }
        UIImageView *thumb = [self.postThumbnails objectAtIndex:i];
        UIImageView *overlay = [self.postThumbnailOverlays objectAtIndex:i];
        if (post) {            
            [thumb setImageWithURL:post.photo.squareThumbnailURL];
            [thumb setHidden:NO];
            [overlay setHidden:NO];
        } else {
            [thumb setHidden:YES];
            [overlay setHidden:YES];
        }

    }
    // GTIOUIButton *followButton = [self activeFollowButton];
    
    // if (_user.button.action.endpoint.length > 0) {
    //     __block typeof(self) blockSelf = self;
    //     [followButton setTapHandler:^(id sender) {
    //         GTIOUIButton *button = (GTIOUIButton *) sender;
    //         [button showSpinner];
    //         button.enabled = NO;
    //         if ([blockSelf.delegate respondsToSelector:@selector(buttonTapped:)]) {
    //             [blockSelf.delegate buttonTapped:_user.button];
    //         }
    //     }];
    // } else {
    //     followButton.userInteractionEnabled = NO;
    // }
    
    // if (_user.badge) {
    //     [self.badgeImageView setImageWithURL:[user.badge badgeImageURLForUserList]];
    // }

    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}


@end
