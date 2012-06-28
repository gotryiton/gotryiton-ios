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

@property (nonatomic, strong) GTIOUIButton *followingButton;
@property (nonatomic, strong) GTIOUIButton *followButton;
@property (nonatomic, strong) GTIOUIButton *requestedButton;

@property (nonatomic, strong) UIView *bottomBorder;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation GTIOFindMyFriendsTableViewCell

@synthesize user = _user, profilePicture = _profilePicture, nameLabel = _nameLabel, chevron = _chevron, bottomBorder = _bottomBorder, followingButton = _followingButton, followButton = _followButton, requestedButton = _requestedButton, indexPath = _indexPath, delegate = _delegate;

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
        
        _followingButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFollowingButtonRegular];
        _followingButton.hidden = YES;
        [self.contentView addSubview:_followingButton];
        
        _followButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeFollowButtonRegular];
        _followButton.hidden = YES;
        [self.contentView addSubview:_followButton];
        
        _requestedButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeRequestedButtonRegular];
        _requestedButton.hidden = YES;
        [self.contentView addSubview:_requestedButton];
        
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
    
    self.nameLabel.text = @"";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.followingButton setFrame:(CGRect){ self.chevron.frame.origin.x - self.followingButton.bounds.size.width - 9, 9, self.followingButton.bounds.size }];
    [self.followButton setFrame:(CGRect){ self.chevron.frame.origin.x - self.followButton.bounds.size.width - 9, 9, self.followButton.bounds.size }];
    [self.requestedButton setFrame:(CGRect){ self.chevron.frame.origin.x - self.requestedButton.bounds.size.width - 9, 9, self.requestedButton.bounds.size }];
    
    double nameLableXPosition = self.profilePicture.frame.origin.x + self.profilePicture.bounds.size.width + 10;
    [self.nameLabel setFrame:(CGRect){ nameLableXPosition, 17, self.followingButton.frame.origin.x - nameLableXPosition - 10, 20 }];
    [self.bottomBorder setFrame:(CGRect){ 0, self.contentView.bounds.size.height - 1, self.contentView.bounds.size.width, 1 }];
}

- (void)setUser:(GTIOUser *)user indexPath:(NSIndexPath *)indexPath
{
    _user = user;
    self.indexPath = indexPath;
    [self.profilePicture setImageWithURL:_user.icon];
    self.nameLabel.text = _user.name;
    
    self.followButton.hidden = YES;
    self.followingButton.hidden = YES;
    self.requestedButton.hidden = YES;
    
    GTIOUIButton *followButton;
    if ([_user.button.name isEqualToString:kGTIOUserInfoButtonNameFollow]) {
        if ([_user.button.state intValue] == GTIOFollowButtonStateFollowing) {
            followButton = self.followingButton;
        } else if ([_user.button.state intValue] == GTIOFollowButtonStateFollow) {
            followButton = self.followButton;
        } else if ([_user.button.state intValue] == GTIOFollowButtonStateRequested) {
            followButton = self.requestedButton;
        }
    }
    
    followButton.hidden = NO;
    
    __block typeof(self) blockSelf = self;
    [followButton setTapHandler:^(id sender) {
        GTIOUIButton *button = (GTIOUIButton *)sender;
        button.enabled = NO;
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:_user.button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
            loader.onDidLoadObjects = ^(NSArray *objects) {
                button.enabled = YES;
                for (id object in objects) {
                    if ([object isMemberOfClass:[GTIOUser class]]) {
                        GTIOUser *newUser = (GTIOUser *)object;
                        [blockSelf setUser:newUser indexPath:blockSelf.indexPath];
                        if ([blockSelf.delegate respondsToSelector:@selector(updateDataSourceWithUser:atIndexPath:)]) {
                            [blockSelf.delegate updateDataSourceWithUser:newUser atIndexPath:blockSelf.indexPath];
                        }
                    }
                }
            };
            loader.onDidFailWithError = ^(NSError *error) {
                button.enabled = YES;
                NSLog(@"%@", [error localizedDescription]);
            };
        }];
    }];
    
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

@end
