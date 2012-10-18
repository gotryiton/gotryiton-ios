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

static CGFloat const kGTIOConnectWithFriendsLeftPadding = 0.0f;
static CGFloat const kGTIOConnectWithFriendsTopPadding = -3.0f;
static CGFloat const kGTIOBetterWhenSharedTopPadding = 15.0f;
static CGFloat const kGTIOBetterWhenSharedLeftPadding = -1.0f;
static CGFloat const kGTIOEditProfileButtonLeftPadding = 257.0f;
static CGFloat const kGTIOUserNameLeftPadding = 11.0f;
static CGFloat const kGTIOUserNameTopPaddingDefault = 2.0f;
static CGFloat const kGTIOUserNameTopPaddingNoLocation = 8.0f;
static CGFloat const kGTIOUserNameWidth = 160.0f;
static CGFloat const kGTIOUserNameHeight = 17.0f;
static CGFloat const kGTIORealNameHeight = 14.0f;
static CGFloat const kGTIOViewLayoutTopPadding = 5.0f;
static CGFloat const kGTIOViewLayoutLeftPadding = 2.0f;
static CGFloat const kGTIOProfileIconTopPadding = 75.0f;
static CGFloat const kGTIOProfileIconLeftPadding = 34.0f;
static CGFloat const kGTIOProfileIconSize = 46.0f;

@interface GTIOAccountCreatedView()

@property (nonatomic, strong) GTIOUIButton *editProfileButton;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UIImageView *viewLayout;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userRealName;
@property (nonatomic, strong) UILabel *userLocation;
@property (nonatomic, strong) UILabel *betterWhenShared;
@property (nonatomic, strong) UILabel *connectWithFriends;

@end

@implementation GTIOAccountCreatedView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _profilePicture = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_profilePicture setImageWithURL:[GTIOUser currentUser].icon];
        [self addSubview:_profilePicture];
        
        _viewLayout = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-info-container.png"]];
        [self addSubview:_viewLayout];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userName setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagBook size:18.0]];
        [_userName setTextColor:[UIColor gtio_grayTextColor727272]];
        [_userName setBackgroundColor:[UIColor clearColor]];
        [_userName setText:[GTIOUser currentUser].name];
        
        [self addSubview:_userName];
        
        _userRealName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userRealName setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [_userRealName setTextColor:[UIColor gtio_grayTextColorA7A7A7]];
        [_userRealName setBackgroundColor:[UIColor clearColor]];
        [_userRealName setText:[GTIOUser currentUser].realName];
        
        [self addSubview:_userRealName];

        _userLocation = [[UILabel alloc] initWithFrame:CGRectZero];
        [_userLocation setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
        [_userLocation setBackgroundColor:[UIColor clearColor]];
        [_userLocation setTextColor:[UIColor gtio_grayTextColorA7A7A7]];
        [_userLocation setText:[[GTIOUser currentUser].location uppercaseString]];
        [self addSubview:_userLocation];
        
        _editProfileButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeEditProfilePencilCircle];
        [self addSubview:_editProfileButton];
        
        _betterWhenShared = [[UILabel alloc] initWithFrame:CGRectZero];
        [_betterWhenShared setBackgroundColor:[UIColor clearColor]];
        [_betterWhenShared setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:17.0]];
        [_betterWhenShared setTextColor:[UIColor gtio_grayTextColor404040]];
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
    
    [self.profilePicture setFrame:(CGRect){ kGTIOProfileIconLeftPadding, kGTIOProfileIconTopPadding, kGTIOProfileIconSize, kGTIOProfileIconSize }];
    
    [self.viewLayout setFrame:(CGRect){ kGTIOViewLayoutLeftPadding, kGTIOViewLayoutTopPadding, self.viewLayout.bounds.size }];

    [self.userName setFrame:(CGRect){ 
        // user name positioned from right side of profile icon
        self.profilePicture.frame.origin.x + self.profilePicture.frame.size.width + kGTIOUserNameLeftPadding,
        // top padding is based on presence of a location 
        ([GTIOUser currentUser].location.length > 0) ? self.profilePicture.frame.origin.y + kGTIOUserNameTopPaddingDefault : self.profilePicture.frame.origin.y + kGTIOUserNameTopPaddingNoLocation, 
        kGTIOUserNameWidth, 
        kGTIOUserNameHeight 
    }];

    [self.userRealName setFrame:(CGRect){ 
        self.profilePicture.frame.origin.x + self.profilePicture.frame.size.width + kGTIOUserNameLeftPadding, 
        self.userName.frame.origin.y + self.userName.frame.size.height, 
        kGTIOUserNameWidth, 
        kGTIORealNameHeight 
    }];

    [self.userLocation setFrame:(CGRect){ 
        self.profilePicture.frame.origin.x + self.profilePicture.frame.size.width + kGTIOUserNameLeftPadding, 
        self.userRealName.frame.origin.y+self.userRealName.frame.size.height, 
        kGTIOUserNameWidth, 
        kGTIORealNameHeight 
    }];

    [self.editProfileButton setFrame:(CGRect){ 
        kGTIOEditProfileButtonLeftPadding, 
        // edit button should be vertically centered
        self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height/2 - self.editProfileButton.bounds.size.height/2, 
        self.editProfileButton.bounds.size 
    }];

    [self.betterWhenShared setFrame:(CGRect){ 
        kGTIOBetterWhenSharedLeftPadding, 
        self.viewLayout.frame.origin.y + self.viewLayout.bounds.size.height + kGTIOBetterWhenSharedTopPadding, 
        self.bounds.size.width, 
        20 
    }];

    [self.connectWithFriends setFrame:(CGRect){ 
        kGTIOConnectWithFriendsLeftPadding, 
        _betterWhenShared.frame.origin.y + _betterWhenShared.bounds.size.height + kGTIOConnectWithFriendsTopPadding, 
        self.bounds.size.width, 
        40 
    }];

    [self.userName setNumberOfLines:1];
    [self.userName setMinimumFontSize:12.0];
    self.userName.adjustsFontSizeToFitWidth = YES;

    [self.userRealName setNumberOfLines:1];
    [self.userRealName setMinimumFontSize:8.0];
    self.userRealName.adjustsFontSizeToFitWidth = YES;

    [self.userLocation setNumberOfLines:1];
    [self.userLocation setMinimumFontSize:8.0];
    self.userLocation.adjustsFontSizeToFitWidth = YES;
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
        [self.userLocation setText:[[GTIOUser currentUser].location uppercaseString]];
    }
    [self setNeedsLayout];
}

@end
