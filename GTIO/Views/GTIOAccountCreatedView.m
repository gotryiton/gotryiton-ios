//
//  GTIOAccountCreatedView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAccountCreatedView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "GTIOUser.h"

@interface GTIOAccountCreatedView()

@property (nonatomic, strong) GTIOUIButton *editProfileButton;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UIImageView *viewLayout;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userLocation;
@property (nonatomic, strong) UILabel *betterWhenShared;
@property (nonatomic, strong) UILabel *connectWithFriends;

@end

@implementation GTIOAccountCreatedView

@synthesize delegate = _delegate, editProfileButton = _editProfileButton, profilePicture = _profilePicture, userName = _userName, userLocation = _userLocation, betterWhenShared = _betterWhenShared, viewLayout = _viewLayout, connectWithFriends = _connectWithFriends;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _profilePicture = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_profilePicture setImageWithURL:[GTIOUser currentUser].icon];
        [self addSubview:_profilePicture];
        
        _viewLayout = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-info-container.png"]];
        [_viewLayout sizeToFit];
        [self addSubview:_viewLayout];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userName setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
        [_userName setTextColor:[UIColor gtio_pinkTextColor]];
        [_userName setBackgroundColor:[UIColor clearColor]];
        [_userName setText:[GTIOUser currentUser].name];
        [self addSubview:_userName];
        
        _userLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userLocation setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
        [_userLocation setBackgroundColor:[UIColor clearColor]];
        [_userLocation setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [_userLocation setText:[[GTIOUser currentUser].location uppercaseString]];
        [self addSubview:_userLocation];
        
        _editProfileButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeEditProfilePencilCircle];
        [self addSubview:_editProfileButton];
        
        _betterWhenShared = [[UILabel alloc] initWithFrame:CGRectZero];
        [_betterWhenShared setBackgroundColor:[UIColor clearColor]];
        [_betterWhenShared setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:17.0]];
        [_betterWhenShared setTextColor:[UIColor gtio_grayTextColor515152]];
        [_betterWhenShared setText:@"style is better when shared!"];
        [_betterWhenShared setTextAlignment:UITextAlignmentCenter];
        [self addSubview:_betterWhenShared];
        
        _connectWithFriends = [[UILabel alloc] initWithFrame:CGRectZero];
        [_connectWithFriends setBackgroundColor:[UIColor clearColor]];
        [_connectWithFriends setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
        [_connectWithFriends setLineBreakMode:UILineBreakModeWordWrap];
        [_connectWithFriends setNumberOfLines:0];
        [_connectWithFriends setTextColor:[UIColor gtio_grayTextColor9C9C9C]];
        [_connectWithFriends setText:@"Connect with friends, bloggers and brands\nto discover great style from the start."];
        [_connectWithFriends setTextAlignment:UITextAlignmentCenter];
        [self addSubview:_connectWithFriends];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.profilePicture setFrame:(CGRect){ 30, 70, 46, 46 }];
    [self.viewLayout setFrame:(CGRect){ 5, 5, self.viewLayout.bounds.size }];
    [self.userName setFrame:(CGRect){ 83, ([GTIOUser currentUser].location.length > 0) ? 70 : 82, 167, 22 }];
    [self.userLocation setFrame:(CGRect){ 83, 92, 167, 14 }];
    [self.editProfileButton setFrame:(CGRect){ 255, 78, self.editProfileButton.bounds.size }];
    [self.betterWhenShared setFrame:(CGRect){ 0, self.viewLayout.frame.origin.y + self.viewLayout.bounds.size.height + 18, self.bounds.size.width, 20 }];
    [self.connectWithFriends setFrame:(CGRect){ 0, _betterWhenShared.frame.origin.y + _betterWhenShared.bounds.size.height - 5, self.bounds.size.width, 40 }];
}

- (void)setDelegate:(id<GTIOAccountCreatedDelegate>)delegate
{
    _delegate = delegate;
    [self.editProfileButton addTarget:self action:@selector(pushEditProfileViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushEditProfileViewController:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(pushEditProfileViewController)]) {
        [self.delegate pushEditProfileViewController];
    }
}

- (void)refreshUserData
{
    UIImageView *testProfilePicture = [[UIImageView alloc] initWithFrame:CGRectZero];
    [testProfilePicture setImageWithURL:[GTIOUser currentUser].icon success:^(UIImage *image) {
        if (![self.profilePicture.image isEqual:image]) {
            [self.profilePicture setImage:image];
        }
    } failure:nil];
    if (![self.userName.text isEqualToString:[GTIOUser currentUser].name]) {
        [self.userName setText:[GTIOUser currentUser].name];
    }
    if (![self.userLocation.text isEqualToString:[GTIOUser currentUser].location]) {
        [self.userLocation setText:[GTIOUser currentUser].location];
    }
    [self setNeedsLayout];
}

@end
