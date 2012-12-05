//
//  GTIOFindMyFriendsTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsTableViewCell.h"
#import "GTIOSelectableProfilePicture.h"
#import "UIImageView+WebCache.h"
#import "GTIOUIFollowButton.h"

static CGFloat const kGTIORightPadding = 7.0;
static CGFloat const kGTIOProfilePictureRightPadding = 10.0;
static CGFloat const kGTIONameLabelYPosition = 11.0;
static CGFloat const kGTIOBottomBorderVerticalOffset = 1.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = -2.0;
static CGFloat const kGTIOUserBadgeHorizontalOffset = 4.0;

@interface GTIOFindMyFriendsTableViewCell()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profilePicture;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *realNameLabel;

@property (nonatomic, strong) GTIOUIFollowButton *followingButton;

@property (nonatomic, strong) UIView *bottomBorder;
@property (nonatomic, strong) UIImageView *badgeImageView;

@end

@implementation GTIOFindMyFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _profilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 6, 6, 36, 36 } andImageURL:nil];
        _profilePicture.hasInnerShadow = YES;
        _profilePicture.hasOuterShadow = NO;
        _profilePicture.isSelectable = NO;
        [self.contentView addSubview:_profilePicture];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0];
        _nameLabel.textColor = [UIColor gtio_grayTextColor727272];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];

        _realNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _realNameLabel.font = [UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0];
        _realNameLabel.textColor = [UIColor gtio_grayTextColorA7A7A7];
        _realNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_realNameLabel];
        
        _followingButton = [GTIOUIFollowButton initFollowButton];
        [self.contentView addSubview:_followingButton];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [self.contentView addSubview:_bottomBorder];

        // Badge
        _badgeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_badgeImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.nameLabel.text = @"";
    self.realNameLabel.text = @"";
    [self.badgeImageView setFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.followingButton setFrame:(CGRect){ self.bounds.size.width - self.followingButton.bounds.size.width - kGTIORightPadding, 9, self.followingButton.bounds.size }];
    
    double nameLableXPosition = self.profilePicture.frame.origin.x + self.profilePicture.bounds.size.width + kGTIOProfilePictureRightPadding;
    [self.nameLabel setFrame:(CGRect){ nameLableXPosition, kGTIONameLabelYPosition, self.followingButton.frame.origin.x - nameLableXPosition - kGTIOProfilePictureRightPadding, 17 }];
    [self.realNameLabel setFrame:(CGRect){ nameLableXPosition, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, self.followingButton.frame.origin.x - nameLableXPosition - kGTIOProfilePictureRightPadding, 10 }];
    [self.bottomBorder setFrame:(CGRect){ 0, self.contentView.bounds.size.height - kGTIOBottomBorderVerticalOffset, self.contentView.bounds.size.width, 1 }];

    if (self.user.badge) {
        [self.badgeImageView setFrame:(CGRect){ (self.nameLabel.frame.origin.x + [self nameLabelSize].width + kGTIOUserBadgeHorizontalOffset), (self.nameLabel.frame.origin.y + kGTIOUserBadgeVerticalOffset), [self.user.badge badgeImageSizeForUserList] }];
    }

}



- (void)setUser:(GTIOUser *)user
{
    if (![_user isEqual:user]) {
        _user = user;
    }
    [self.profilePicture setImageWithURL:_user.icon];
    self.nameLabel.text = _user.name;
    self.realNameLabel.text = _user.realName;
    
    
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
        [self.badgeImageView setImageWithURL:[user.badge badgeImageURLForUserList]];
    }

    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = (highlighted) ? [UIColor gtio_findMyFriendsTableCellActiveColor] : [UIColor whiteColor];
}

-(CGSize)nameLabelSize
{
    return [self.user.name sizeWithFont:self.nameLabel.font forWidth:400.0f lineBreakMode:UILineBreakModeTailTruncation];
}


@end
