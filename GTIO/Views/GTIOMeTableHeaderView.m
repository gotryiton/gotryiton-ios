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
#import "GTIOButton.h"
#import "GTIOEditProfileViewController.h"
#import "GTIORouter.h"

#import "GTIOFriendsViewController.h"

static CGFloat const kGTIOMaximumNameLabelWidth = 204.0;
static CGFloat const kGTIODefaultLabelHeight = 21.0;
static CGFloat const kGTIODefaultHorizontalSpacing = 8.0;
static CGFloat const kGTIOLocationLabelVerticalOffset = 4.0;
static CGFloat const kGTIOUserBadgeWidthHeight = 17.0;
static CGFloat const kGTIOUserBadgeVerticalOffset = 1.0;
static CGFloat const kGTIOUserBadgeNameLabelSpacing = 3.0;
static CGFloat const kGTIOLocationLabelWidth = 224.0;
static CGFloat const kGTIOLocationLabelHeight = 13.0;
static CGFloat const kGTIOFollowingLabelLocationLabelVerticalSpacing = 4.0;
static CGFloat const kGTIOFollowingFollowersLabelWidth = 53.0;
static CGFloat const kGTIOStarsLabelWidth = 23.0;
static CGFloat const kGTIOEditButtonWidth = 3.0;

@interface GTIOMeTableHeaderView()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) GTIOSelectableProfilePicture *profileIcon;
@property (nonatomic, strong) GTIOUIButton *profileIconButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *badge;

@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followingLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followingCountLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followersLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *followerCountLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *starsLabel;
@property (nonatomic, strong) GTIOMeTableHeaderViewLabel *starCountLabel;

@property (nonatomic, strong) GTIOUIButton *followingButton;
@property (nonatomic, strong) GTIOUIButton *followersButton;
@property (nonatomic, strong) GTIOUIButton *starsButton;
@property (nonatomic, strong) GTIOUIButton *editButton;

@property (nonatomic, strong) UIImage *editImage;

@end

@implementation GTIOMeTableHeaderView

@synthesize backgroundImageView = _backgroundImageView, hasBackground = _hasBackground;
@synthesize profileIcon = _profileIcon, profileIconButton = _profileIconButton, nameLabel = _nameLabel, locationLabel = _locationLabel, userInfoButtons = _userInfoButtons, badge = _badge;
@synthesize followingLabel = _followingLabel, followingCountLabel = _followingCountLabel, followersLabel = _followersLabel, followerCountLabel = _followerCountLabel, starsLabel = _starsLabel, starCountLabel = _starCountLabel, user = _user, usesGearInsteadOfPencil = _usesGearInsteadOfPencil;
@synthesize followingButton = _followingButton, followersButton = _followersButton, starsButton = _starsButton, editButton = _editButton, editImage = _editImage, editButtonTapHandler = _editButtonTapHandler, profilePictureTapHandler = _profilePictureTapHandler;
@synthesize delegate = _delegate, settingsButtonHidden = _settingsButtonHidden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"profile.top.bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0]];
        [_backgroundImageView setFrame:CGRectZero];
        [self addSubview:_backgroundImageView];
        
        _profileIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 8, 8, 55, 55 } andImageURL:nil];
        [_profileIcon setIsSelectable:NO];
        [_profileIcon setHasOuterShadow:YES];
        [_profileIcon setHasInnerShadow:NO];
        [self addSubview:_profileIcon];
        
        _profileIconButton = [[GTIOUIButton alloc] initWithFrame:CGRectZero];
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
        
        _followingButton = [[GTIOUIButton alloc] initWithFrame:CGRectZero];
        [_followingButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followingButton];
        
        _followersButton = [[GTIOUIButton alloc] initWithFrame:CGRectZero];
        [_followersButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followersButton];
        
        _starsButton = [[GTIOUIButton alloc] initWithFrame:CGRectZero];
        [_starsButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_starsButton];
        
        _editButton = [[GTIOUIButton alloc] initWithFrame:CGRectZero];
        [_editButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self setUsesGearInsteadOfPencil:NO];
        [self addSubview:_editButton];
        
        [self refreshButtons];
    }
    return self;
}

- (void)setSettingsButtonHidden:(BOOL)settingsButtonHidden
{
    _settingsButtonHidden = settingsButtonHidden;
    self.editButton.hidden = _settingsButtonHidden;
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
    [super layoutSubviews];
    
    if (self.hasBackground) {
        [self.backgroundImageView setFrame:(CGRect){ 0, 0, self.bounds.size }];
    }
    [self.profileIconButton setFrame:self.profileIcon.frame];
    [self.nameLabel sizeToFit];
    
    [self.nameLabel setFrame:(CGRect){ self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + kGTIODefaultHorizontalSpacing, self.profileIcon.frame.origin.y, (self.nameLabel.bounds.size.width < kGTIOMaximumNameLabelWidth) ? self.nameLabel.bounds.size.width : kGTIOMaximumNameLabelWidth, kGTIODefaultLabelHeight }];
    if (self.user.badge) {
        [self.badge setFrame:(CGRect){ self.nameLabel.frame.origin.x + self.nameLabel.bounds.size.width + kGTIOUserBadgeNameLabelSpacing, self.nameLabel.frame.origin.y - kGTIOUserBadgeVerticalOffset, kGTIOUserBadgeWidthHeight, kGTIOUserBadgeWidthHeight }];
    }
    [self.locationLabel setFrame:(CGRect){ self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - kGTIOLocationLabelVerticalOffset, kGTIOLocationLabelWidth, kGTIOLocationLabelHeight }];
    [self.followingLabel setFrame:(CGRect){ self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + kGTIOFollowingLabelLocationLabelVerticalSpacing, kGTIOFollowingFollowersLabelWidth, kGTIODefaultLabelHeight }];
    [self.followingCountLabel setFrame:(CGRect){ self.followingLabel.frame.origin.x + self.followingLabel.frame.size.width, self.followingLabel.frame.origin.y, 0, kGTIODefaultLabelHeight }];
    [self.followingCountLabel sizeToFitText];
    [self.followingButton setFrame:(CGRect){ self.followingLabel.frame.origin, self.followingLabel.bounds.size.width + self.followingCountLabel.bounds.size.width, self.followingLabel.bounds.size.height }];
    [self.followersLabel setFrame:(CGRect){ self.followingCountLabel.frame.origin.x + self.followingCountLabel.frame.size.width + kGTIODefaultHorizontalSpacing, self.followingCountLabel.frame.origin.y, kGTIOFollowingFollowersLabelWidth, kGTIODefaultLabelHeight }];
    [self.followerCountLabel setFrame:(CGRect){ self.followersLabel.frame.origin.x + self.followersLabel.frame.size.width, self.followersLabel.frame.origin.y, 0, kGTIODefaultLabelHeight }];
    [self.followerCountLabel sizeToFitText];
    [self.followersButton setFrame:(CGRect){ self.followersLabel.frame.origin, self.followersLabel.bounds.size.width + self.followerCountLabel.bounds.size.width, self.followersLabel.bounds.size.height }];
    [self.starsLabel setFrame:(CGRect){ self.followerCountLabel.frame.origin.x + self.followerCountLabel.frame.size.width + kGTIODefaultHorizontalSpacing, self.followerCountLabel.frame.origin.y, kGTIOStarsLabelWidth, kGTIODefaultLabelHeight }];
    [self.starCountLabel setFrame:(CGRect){ self.starsLabel.frame.origin.x + self.starsLabel.frame.size.width, self.starsLabel.frame.origin.y, 0, kGTIODefaultLabelHeight }];
    [self.starCountLabel sizeToFitText];
    [self.starsButton setFrame:(CGRect){ self.starsLabel.frame.origin, self.starsLabel.bounds.size.width + self.starCountLabel.bounds.size.width, self.starsLabel.bounds.size.height }];
    [self.editButton setFrame:(CGRect){ self.bounds.size.width - self.editImage.size.width, kGTIOEditButtonWidth, self.editImage.size }];
}

- (void)refreshButtons
{
    self.followingLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowing];
    self.followingCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowing];
    self.followingButton.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowing];
    self.followersLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowers];
    self.followerCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowers];
    self.followersButton.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameFollowers];
    self.starsLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameStars];
    self.starCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameStars];
    self.starsButton.hidden = ![self userInfoButtonsHasButtonwWithName:kGTIOUserInfoButtonNameStars];
}

- (BOOL)userInfoButtonsHasButtonwWithName:(NSString *)name
{
    for (GTIOButton *button in self.userInfoButtons) {
        if ([button.name isEqualToString:name]) {
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
            [self.followingLabel setText:@"following"];
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            self.followingButton.tapHandler = ^(id sender) {
                if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {                    
                    UIViewController *followingFriendsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                    [self.delegate pushViewController:followingFriendsViewController];
                }
            };
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameFollowers]) {
            [self.followersLabel setText:@"followers"];
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            _followersButton.tapHandler = ^(id sender) {
                if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
                    UIViewController *followingFriendsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                    [self.delegate pushViewController:followingFriendsViewController];
                }
            };
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameStars]) {
            [self.starCountLabel setText:[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:button.count]]];
            _starsButton.tapHandler = ^(id sender) {
                UIViewController *starsViewController = [[GTIORouter sharedRouter] viewControllerForURLString:button.action.destination];
                [self.delegate pushViewController:starsViewController];
            };
        }
    }
    [self refreshButtons];
    [self setNeedsLayout];
}

- (void)buttonTapped:(id)sender
{
    GTIOUIButton *button = (GTIOUIButton *)sender;
    if (button.tapHandler) {
        button.tapHandler(button);
    }
}

@end
