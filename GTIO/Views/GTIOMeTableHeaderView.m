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

@interface GTIOMeTableHeaderView()

@property (nonatomic, strong) GTIOSelectableProfilePicture *profileIcon;
@property (nonatomic, strong) GTIOButton *profileIconButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;

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

@property (nonatomic, strong) UIImage *editPencil;

@end

@implementation GTIOMeTableHeaderView

@synthesize profileIcon = _profileIcon, profileIconButton = _profileIconButton, nameLabel = _nameLabel, locationLabel = _locationLabel, userInfoButtons = _userInfoButtons;
@synthesize followingLabel = _followingLabel, followingCountLabel = _followingCountLabel, followersLabel = _followersLabel, followerCountLabel = _followerCountLabel, starsLabel = _starsLabel, starCountLabel = _starCountLabel;
@synthesize followingButton = _followingButton, followersButton = _followersButton, starsButton = _starsButton, editButton = _editButton, editPencil = _editPencil;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        GTIOUser *currentUser = [GTIOUser currentUser];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"profile.top.bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0]];
        [backgroundImageView setFrame:(CGRect){ 0, 0, frame.size }];
        [self addSubview:backgroundImageView];
        
        _profileIcon = [[GTIOSelectableProfilePicture alloc] initWithFrame:(CGRect){ 8, 8, 55, 55 } andImageURL:currentUser.icon];
        [_profileIcon setIsSelectable:NO];
        [self addSubview:_profileIcon];
        
        _profileIconButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_profileIconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_profileIconButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:16.0]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setText:currentUser.name];
        [self addSubview:_nameLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_locationLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [_locationLabel setTextColor:[UIColor gtio_lightGrayTextColor]];
        [_locationLabel setText:[currentUser.location uppercaseString]];
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
        
        _editPencil = [UIImage imageNamed:@"profile.top.icon.edit.png"];
        _editButton = [[GTIOButton alloc] initWithFrame:CGRectZero];
        [_editButton setImage:_editPencil forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editButton];
        
        [self refreshButtons];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)layoutSubviews
{
    [self.profileIconButton setFrame:self.profileIcon.frame];
    [self.nameLabel setFrame:(CGRect){ self.profileIcon.frame.origin.x + self.profileIcon.frame.size.width + 7, self.profileIcon.frame.origin.y, 224, 21 }];
    [self.locationLabel setFrame:(CGRect){ self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 5, 224, 13 }];
    [self.followingLabel setFrame:(CGRect){ self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 6, 53, 20 }];
    [self.followingCountLabel setFrame:(CGRect){ self.followingLabel.frame.origin.x + self.followingLabel.frame.size.width, self.followingLabel.frame.origin.y, 30, 20 }];
    [self.followingButton setFrame:(CGRect){ self.followingLabel.frame.origin, self.followingLabel.bounds.size.width + self.followingCountLabel.bounds.size.width, self.followingLabel.bounds.size.height }];
    [self.followersLabel setFrame:(CGRect){ self.followingCountLabel.frame.origin.x + self.followingCountLabel.frame.size.width + 8, self.followingCountLabel.frame.origin.y, 53, 20 }];
    [self.followerCountLabel setFrame:(CGRect){ self.followersLabel.frame.origin.x + self.followersLabel.frame.size.width, self.followersLabel.frame.origin.y, 30, 20 }];
    [self.followersButton setFrame:(CGRect){ self.followersLabel.frame.origin, self.followersLabel.bounds.size.width + self.followerCountLabel.bounds.size.width, self.followersLabel.bounds.size.height }];
    [self.starsLabel setFrame:(CGRect){ self.followerCountLabel.frame.origin.x + self.followerCountLabel.frame.size.width + 8, self.followerCountLabel.frame.origin.y, 23, 20 }];
    [self.starCountLabel setFrame:(CGRect){ self.starsLabel.frame.origin.x + self.starsLabel.frame.size.width, self.starsLabel.frame.origin.y, 23, 20 }];
    [self.starsButton setFrame:(CGRect){ self.starsLabel.frame.origin, self.starsLabel.bounds.size.width + self.starCountLabel.bounds.size.width, self.starsLabel.bounds.size.height }];
    [self.editButton setFrame:(CGRect){ self.bounds.size.width - self.editPencil.size.width, 3, self.editPencil.size }];
}

- (void)refreshButtons
{
    self.followingLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"following"];
    self.followingCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"following"];
    self.followingButton.hidden = ![self userInfoButtonsHasButtonwWithName:@"following"];
    self.followersLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"followers"];
    self.followerCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"followers"];
    self.followersButton.hidden = ![self userInfoButtonsHasButtonwWithName:@"followers"];
    self.starsLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"stars"];
    self.starCountLabel.hidden = ![self userInfoButtonsHasButtonwWithName:@"stars"];
    self.starsButton.hidden = ![self userInfoButtonsHasButtonwWithName:@"stars"];
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

- (void)setDelegate:(id<GTIOMeTableHeaderViewDelegate>)delegate
{
    _delegate = delegate;
    
    [self.profileIconButton setTapHandler:^(id sender) {
        if ([self.delegate respondsToSelector:@selector(pushEditProfilePictureViewController)]) {
            [self.delegate pushEditProfilePictureViewController];
        }
    }];
    
    [self.editButton setTapHandler:^(id sender) {
        if ([self.delegate respondsToSelector:@selector(pushEditProfileViewController)]) {
            [self.delegate pushEditProfileViewController];
        }
    }];
}

- (void)refreshUserData
{
    GTIOUser *currentUser = [GTIOUser currentUser];
    [self.profileIcon setImageWithURL:currentUser.icon];
    [self.nameLabel setText:currentUser.name];
    [self.locationLabel setText:currentUser.location];
    [self refreshButtons];
    [self setNeedsLayout];
}

- (void)setUserInfoButtons:(NSArray *)userInfoButtons
{
    _userInfoButtons = userInfoButtons;
    for (int i = 0; i < [self.userInfoButtons count]; i++) {
        GTIOButton *button = [self.userInfoButtons objectAtIndex:i];
        if ([button.name isEqualToString:@"following"]) {
            [self.followingLabel setText:@"following"];
            [self.followingCountLabel setText:[NSString stringWithFormat:@"%i", [button.count intValue]]];
            self.followingButton.tapHandler = ^(id sender) {
                NSLog(@"tapped %@, use endpoint: %@", button.name, button.action.endpoint);
            };
        }
        if ([button.name isEqualToString:@"followers"]) {
            [self.followersLabel setText:@"followers"];
            [self.followerCountLabel setText:[NSString stringWithFormat:@"%i", [button.count intValue]]];
            _followersButton.tapHandler = ^(id sender) {
                NSLog(@"tapped %@, use endpoint: %@", button.name, button.action.endpoint);
            };
        }
        if ([button.name isEqualToString:@"stars"]) {
            [self.starCountLabel setText:[NSString stringWithFormat:@"%i", [button.count intValue]]];
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
