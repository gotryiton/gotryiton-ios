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
#import "GTIOUIFollowButton.h"

static CGFloat const kGTIORightPadding = 8.0;
static CGFloat const kGTIOTopPadding = 3.0;
static CGFloat const kGTIOTopFollowButtonPadding = 6.0;
static CGFloat const kGTIOBottomPadding = 3.0;
static CGFloat const kGTIOProfilePictureSize = 42.0;
static CGFloat const kGTIOProfilePictureRightPadding = 10.0;
static CGFloat const kGTIONameLabelXPosition = 7.0;
static CGFloat const kGTIONameLabelWidth = 178.0;
static CGFloat const kGTIONameLabelYPosition = 6.0;
static CGFloat const kGTIONameLabelYPositionCentered = 13.0;
static CGFloat const kGTIOBottomBorderVerticalOffset = 1.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = 0.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 5.0;

static CGFloat const kGTIOOutfitThumbSize = 70.0;
static int const kGTIOMaxThumbnails = 4;

@interface GTIOConnectTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *iconFrameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@property (nonatomic, strong) GTIOUIFollowButton *followingButton;

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
        _nameLabel.numberOfLines = 1;
        _nameLabel.minimumFontSize = 8  ;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLabel];

        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _locationLabel.textColor = [UIColor gtio_grayTextColor9C9C9C];
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_locationLabel];

        // Badge
        _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_badgeImageView];

        _followingButton = [GTIOUIFollowButton initFollowButton];
        [self.contentView addSubview:_followingButton];
        
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

    [self.badgeImageView setFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.followingButton setFrame:(CGRect){ self.bounds.size.width - self.followingButton.bounds.size.width - kGTIORightPadding, kGTIOTopPadding+kGTIOTopFollowButtonPadding, self.followingButton.bounds.size }];
    
    double nameLabelYPosition = ([self.user.location length] > 0) ? kGTIONameLabelYPosition : kGTIONameLabelYPositionCentered;
    [self.nameLabel setFrame:(CGRect){ self.backgroundImage.frame.origin.x + kGTIONameLabelXPosition, self.backgroundImage.frame.origin.y + nameLabelYPosition, kGTIONameLabelWidth - kGTIORightPadding, 19 }];
    
    
    [self.locationLabel setFrame:(CGRect){ self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 1, kGTIONameLabelWidth - kGTIORightPadding, 10 }];


    [self.separatorImage setFrame:(CGRect){ 0, self.backgroundImage.frame.origin.y + self.backgroundImage.frame.size.height + kGTIORightPadding + kGTIOOutfitThumbSize + kGTIOBottomPadding , self.contentView.frame.size.width, self.separatorImage.bounds.size.height }];

    if (self.user.badge) {
        [self.nameLabel setFrame:(CGRect){ self.nameLabel.frame.origin , {kGTIONameLabelWidth - kGTIORightPadding - [self.user.badge badgeImageSizeForPostOwner].width , 19 }}];
        [self.badgeImageView setFrame:(CGRect){ (self.nameLabel.frame.origin.x + [self nameLabelSizeWithWidth:self.nameLabel.frame.size.width].width + kGTIOUserBadgeHorizontalOffset), (self.nameLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset), [self.user.badge badgeImageSizeForPostOwner] }];
        
    }
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
    [self.nameLabel sizeToFit];
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
    
    if (_user.button.action.endpoint.length > 0) {
        [self.followingButton setFollowState:(GTIOUIFollowButtonState)[_user.button.state integerValue]];

        __block typeof(self) blockSelf = self;
        [self.followingButton setTapHandler:^(id sender) {
            GTIOUIFollowButton *button = (GTIOUIFollowButton *) sender;
            [button showSpinner];

            if ([blockSelf.delegate respondsToSelector:@selector(buttonTapped:)]) {
                [blockSelf.delegate buttonTapped:_user.button];
            }
        }];
    } else {
        self.followingButton.userInteractionEnabled = NO;
    }
    
    if (_user.badge) {
        [self.badgeImageView setImageWithURL:[user.badge badgeImageURLForPostOwner]];
    }

    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}

-(CGSize)nameLabelSizeWithWidth:(CGFloat)width
{
    return [self.nameLabel.text sizeWithFont:self.nameLabel.font forWidth:width lineBreakMode:UILineBreakModeTailTruncation];
}

@end
