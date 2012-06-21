//
//  GTIOMeTableHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMeTableHeaderView.h"
#import "GTIOUser.h"
#import "UIImageView+WebCache.h"
#import "GTIOSelectableProfilePicture.h"
#import <QuartzCore/QuartzCore.h>
#import "GTIOEditProfilePictureViewController.h"
#import "GTIOMeTableHeaderViewLabel.h"
#import "GTIOProfileViewController.h"
#import "GTIOEditProfileViewController.h"

typedef enum {
    GTIOUserInfoButtonTagFollowing = 0,
    GTIOUserInfoButtonTagFollowers,
    GTIOUserInfoButtonTagStars
} GTIOUserInfoButtonTag;

@interface GTIOMeTableHeaderView()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profileIcon;
@property (nonatomic, strong) GTIOButton *profileIconButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *badge;

@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followingLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followingCountLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followersLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followerCountLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *starsLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *starCountLabel;

@property (nonatomic, strong) GTIOButton *followingButton;
@property (nonatomic, strong) GTIOButton *followersButton;
@property (nonatomic, strong) GTIOButton *starsButton;
@property (nonatomic, strong) GTIOButton *editButton;

@property (nonatomic, strong) UIImage *editImage;

@end

@implementation GTIOMeTableHeaderView

@synthesize profileIcon = _profileIcon, profileIconButton = _profileIconButton, nameLabel = _nameLabel, locationLabel = _locationLabel, userInfoButtons = _userInfoButtons, badge = _badge;
@synthesize followingLabel = _followingLabel, followingCountLabel = _followingCountLabel, followersLabel = _followersLabel, followerCountLabel = _followerCountLabel, starsLabel = _starsLabel, starCountLabel = _starCountLabel, user = _user, usesGearInsteadOfPencil = _usesGearInsteadOfPencil;
@synthesize followingButton = _followingButton, followersButton = _followersButton, starsButton = _starsButton, editButton = _editButton, editImage = _editImage, editButtonTapHandler = _editButtonTapHandler, profilePictureTapHandler = _profilePictureTapHandler;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _profileIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 8, 8, 55, 55 } andImageURL:nil];
        [_profileIcon setIsSelectable:NO];
        [_profileIcon setHasOuterShadow:YES];
        [self addSubview:_profileIcon];
        
        _profileIconButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_profileIconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_profileIconButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_nameLabel];
        
        _badge = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_badge];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_locationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [_locationLabel setTextColor:[UIColor gtio_lightGrayTextColor]];
        [_locationLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_locationLabel];
        
        // following / followers / stars labels

        _followingLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_followingLabel];
        
        _followingCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [_followingCountLabel setUsesLightColors:YES];
        [self addSubview:_followingCountLabel];
        
        _followersLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_followersLabel];
        
        _followerCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [_followerCountLabel setUsesLightColors:YES];
        [self addSubview:_followerCountLabel];
        
        _starsLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [_starsLabel setUsesStar:YES];
        [self addSubview:_starsLabel];
        
        _starCountLabel = [[GTIOMeTableHeaderViewLabel alloc] initWithFrame:CGRectZero];
        [_starCountLabel setUsesLightColors:YES];
        [self addSubview:_starCountLabel];
        
        // following / followers / stars buttons
        
        _followingButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_followingButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followingButton];
        
        _followersButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_followersButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followersButton];
        
        _starsButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_starsButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_starsButton];
        
        _editButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_editButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self setUsesGearInsteadOfPencil:NO];
        [self addSubview:_editButton];
        
        [self refreshButtons];
    }
    return self;
}

- (void)setUsesGearInsteadOfPencil:(BOOL)usesGearInsteadOfPencil
{
    _usesGearInsteadOfPencil = usesGearInsteadOfPencil;
    self.editImage = (usesGearInsteadOfPencil) ? [UIImage imageNamed:@"profile.top.icon.cog.png"] : [UIImage imageNamed:@"profile.top.icon.edit.png"];
    [self.editButton setImage:self.editImage forState:UIControlStateNormal];
}

- (void)setUser:(GTIOUser *)user
{
    _user = user;
    [self refreshUserData];
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)layoutSubviews
{
    [self.profileIconButton setFrame:self.profileIcon.frame];
    [self.nameLabel sizeToFit];
    [self.nameLabel setFrame:(CGRect){ self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 7, self.profileIcon.frame.origin.y, (self.nameLabel.bounds.size.width < 204) ? self.nameLabel.bounds.size.width : 204, 21 }];
    if (self.user.badge) {
        [self.badge setFrame:(CGRect){ self.nameLabel.frame.origin.x + self.nameLabel.bounds.size.width + 3, self.nameLabel.frame.origin.y - 1, 17, 17 }];
    }
    [self.locationLabel setFrame:(CGRect){ self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 5, 224, 13 }];
    [self.followingLabel setFrame:(CGRect){ self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 6, 53, 20 }];
    [self.followingCountLabel setFrame:(CGRect){ self.followingLabel.frame.origin.x + self.followingLabel.frame.size.width, self.followingLabel.frame.origin.y, 0, 20 }];
    [self.followingCountLabel sizeToFitText];
    [self.followingButton setFrame:(CGRect){ self.followingLabel.frame.origin, self.followingLabel.bounds.size.width + self.followingCountLabel.bounds.size.width, self.followingLabel.bounds.size.height }];
    [self.followersLabel setFrame:(CGRect){ self.followingCountLabel.frame.origin.x + self.followingCountLabel.frame.size.width + 8, self.followingCountLabel.frame.origin.y, 53, 20 }];
    [self.followerCountLabel setFrame:(CGRect){ self.followersLabel.frame.origin.x + self.followersLabel.frame.size.width, self.followersLabel.frame.origin.y, 0, 20 }];
    [self.followerCountLabel sizeToFitText];
    [self.followersButton setFrame:(CGRect){ self.followersLabel.frame.origin, self.followersLabel.bounds.size.width + self.followerCountLabel.bounds.size.width, self.followersLabel.bounds.size.height }];
    [self.starsLabel setFrame:(CGRect){ self.followerCountLabel.frame.origin.x + self.followerCountLabel.frame.size.width + 8, self.followerCountLabel.frame.origin.y, 23, 20 }];
    [self.starCountLabel setFrame:(CGRect){ self.starsLabel.frame.origin.x + self.starsLabel.frame.size.width, self.starsLabel.frame.origin.y, 0, 20 }];
    [self.starCountLabel sizeToFitText];
    [self.starsButton setFrame:(CGRect){ self.starsLabel.frame.origin, self.starsLabel.bounds.size.width + self.starCountLabel.bounds.size.width, self.starsLabel.bounds.size.height }];
    [self.editButton setFrame:(CGRect){ self.bounds.size.width - self.editImage.size.width, 3, self.editImage.size }];
}

- (void)refreshButtons
{
    self.followingLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowing];
    self.followingCountLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowing];
    self.followingButton.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowing];
    self.followersLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowers];
    self.followerCountLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowers];
    self.followersButton.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagFollowers];
    self.starsLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagStars];
    self.starCountLabel.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagStars];
    self.starsButton.hidden = ![self userInfoButtonsHasButtonwWithTag:GTIOUserInfoButtonTagStars];
}

- (BOOL)userInfoButtonsHasButtonwWithTag:(GTIOUserInfoButtonTag)tag
{
    for (GTIOButton *button in self.userInfoButtons) {
        if (button.tag == tag) {
            return YES;
        }
    }
    return NO;
}

- (void)setProfilePictureTapHandler:(GTIOButtonDidTapHandler)profilePictureTapHandler
{
    _profilePictureTapHandler = profilePictureTapHandler;
    [self.profileIconButton setTapHandler:self.profilePictureTapHandler];
}

- (void)setEditButtonTapHandler:(GTIOButtonDidTapHandler)editButtonTapHandler
{
    _editButtonTapHandler = editButtonTapHandler;
    [self.editButton setTapHandler:self.editButtonTapHandler];
}

- (void)refreshUserData
{
    [self.profileIcon setImageWithURL:self.user.icon];
    [self.nameLabel setText:self.user.name];
    [self.locationLabel setText:[self.user.location uppercaseString]];
    if (self.user.badge) {
        [self.badge setImageWithURL:[self.user.badge badgeImageURL]];
    }
    [self refreshButtons];
    [self setNeedsLayout];
}

- (void)setUserInfoButtons:(NSArray *)userInfoButtons
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterRoundFloor];
    _userInfoButtons = userInfoButtons;
    for (int i = 0; i < [self.userInfoButtons count]; i++) {
        GTIOButton *button = [self.userInfoButtons objectAtIndex:i];
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameFollowing]) {
            button.tag = GTIOUserInfoButtonTagFollowing;
            [self.followingLabel setText:@"following"];
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            self.followingButton.tapHandler = ^(id sender) {
                NSLog(@"tapped %@, use endpoint: %@", button.name, button.action.endpoint);
                if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
                    GTIOProfileViewController *profileViewController = [[GTIOProfileViewController alloc] initWithNibName:nil bundle:nil];
                    [profileViewController setUserID:@"0596D58"];
                    [self.delegate pushViewController:profileViewController];
                }
            };
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameFollowers]) {
            button.tag = GTIOUserInfoButtonTagFollowers;
            [self.followersLabel setText:@"followers"];
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            _followersButton.tapHandler = ^(id sender) {
                NSLog(@"tapped %@, use endpoint: %@", button.name, button.action.endpoint);
            };
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameStars]) {
            button.tag = GTIOUserInfoButtonTagStars;
            [self.starCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            _starsButton.tapHandler = ^(id sender) {
                NSLog(@"tapped %@, use endpoint: %@", button.name, button.action.endpoint);
            };
        }
    }
    [self refreshButtons];
    [self setNeedsLayout];
}

- (void)buttonTapped:(id)sender
{
    GTIOButton *button = (GTIOButton *)sender;
    if (button.tapHandler) {
        button.tapHandler(button);
    }
}

@end
