//
//  GTIOFindMyFriendsTableViewCell.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFindMyFriendsTableViewCell.h"
#import "GTIOSelectableProfilePicture.h"

@interface GTIOFindMyFriendsTableViewCell()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profilePicture;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *chevron;

@property (nonatomic, strong) UIView *bottomBorder;

@end

@implementation GTIOFindMyFriendsTableViewCell

@synthesize user = _user, profilePicture = _profilePicture, nameLabel = _nameLabel, chevron = _chevron, bottomBorder = _bottomBorder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _profilePicture = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 6, 6, 36, 36 } andImageURL:nil];
        [self.contentView addSubview:_profilePicture];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0];
        _nameLabel.textColor = [UIColor gtio_grayTextColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        _chevron = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general.chevron.png"]];
        [_chevron setFrame:(CGRect){ 306, 18, _chevron.image.size }];
        _chevron.alpha = 0.60;
        [self.contentView addSubview:_chevron];
        
        _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBorder.backgroundColor = [UIColor gtio_groupedTableBorderColor];
        [self.contentView addSubview:_bottomBorder];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.profilePicture = nil;
    self.nameLabel = nil;
    self.chevron = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel setFrame:(CGRect){ self.profilePicture.frame.origin.x + self.profilePicture.bounds.size.width + 10, 17, 200, 20 }];
    [self.bottomBorder setFrame:(CGRect){ 0, self.contentView.bounds.size.height - 1, self.contentView.bounds.size.width, 1 }];
}

- (void)setUser:(GTIOUser *)user
{
    _user = user;
    
    [self.profilePicture setImageWithURL:_user.icon];
    self.nameLabel.text = _user.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundColor = (highlighted) ? [UIColor gtio_findMyFriendsTableCellActiveColor] : [UIColor whiteColor];
}

@end
