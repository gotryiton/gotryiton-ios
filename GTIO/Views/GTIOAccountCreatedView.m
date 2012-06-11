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

@property (nonatomic, strong) GTIOButton *editProfileButton;
@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userLocation;

@end

@implementation GTIOAccountCreatedView

@synthesize delegate = _delegate, editProfileButton = _editProfileButton, profilePicture = _profilePicture, userName = _userName, userLocation = _userLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _profilePicture = [[UIImageView alloc] initWithFrame:(CGRect){ 25, 65, 46, 46 }];
        [_profilePicture setImageWithURL:[GTIOUser currentUser].icon];
        [self addSubview:_profilePicture];
        
        UIImageView *viewLayout = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top-info-container.png"]];
        [viewLayout sizeToFit];
        [viewLayout setFrame:(CGRect){ 5, 5, viewLayout.bounds.size }];
        [self addSubview:viewLayout];
        
        _userName = [[UILabel alloc] initWithFrame:(CGRect){ 80, 70, 167, 20 }];
        [_userName setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:18.0]];
        [_userName setTextColor:[UIColor gtio_pinkTextColor]];
        [_userName setBackgroundColor:[UIColor clearColor]];
        [_userName setText:[GTIOUser currentUser].name];
        [self addSubview:_userName];
        
        _userLocation = [[UILabel alloc] initWithFrame:(CGRect){ 80, 92, 167, 14 }];
        [_userLocation setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
        [_userLocation setBackgroundColor:[UIColor clearColor]];
        [_userLocation setTextColor:[UIColor gtio_darkGrayTextColor]];
        [_userLocation setText:[[GTIOUser currentUser].location uppercaseString]];
        [self addSubview:_userLocation];
        
        _editProfileButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeEditProfilePencilCircle];
        [_editProfileButton setFrame:(CGRect){ 255, 78, _editProfileButton.bounds.size }];
        [self addSubview:_editProfileButton];
        
        UILabel *betterWhenShared = [[UILabel alloc] initWithFrame:(CGRect){ 0, viewLayout.frame.origin.y + viewLayout.bounds.size.height + 18, self.bounds.size.width, 20 }];
        [betterWhenShared setBackgroundColor:[UIColor clearColor]];
        [betterWhenShared setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:17.0]];
        [betterWhenShared setTextColor:[UIColor gtio_reallyDarkGrayTextColor]];
        [betterWhenShared setText:@"style is better when shared!"];
        [betterWhenShared setTextAlignment:UITextAlignmentCenter];
        [self addSubview:betterWhenShared];
        
        UILabel *connectWithFriends = [[UILabel alloc] initWithFrame:(CGRect){ 0, betterWhenShared.frame.origin.y + betterWhenShared.bounds.size.height - 5, self.bounds.size.width, 40 }];
        [connectWithFriends setBackgroundColor:[UIColor clearColor]];
        [connectWithFriends setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
        [connectWithFriends setLineBreakMode:UILineBreakModeWordWrap];
        [connectWithFriends setNumberOfLines:0];
        [connectWithFriends setTextColor:[UIColor gtio_darkGrayTextColor]];
        [connectWithFriends setText:@"Connect with friends, bloggers and brands\nto discover great style from the start."];
        [connectWithFriends setTextAlignment:UITextAlignmentCenter];
        [self addSubview:connectWithFriends];
    }
    return self;
}

- (void)setDelegate:(id<GTIOAccountCreatedDelegate>)delegate
{
    _delegate = delegate;
    [self.editProfileButton addTarget:self.delegate action:@selector(pushEditProfileViewController) forControlEvents:UIControlEventTouchUpInside];
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
}

@end
