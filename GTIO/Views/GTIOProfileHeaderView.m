//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileHeaderView.h"
#import "GTIOMeTableHeaderView.h"

@interface GTIOProfileHeaderView()

@property (nonatomic, strong) GTIOMeTableHeaderView *basicUserInfoView;
@property (nonatomic, strong) UIImageView *basicUserInfoBackgroundImageView;

@end

@implementation GTIOProfileHeaderView

@synthesize basicUserInfoView = _basicUserInfoView, basicUserInfoBackgroundImageView = _basicUserInfoBackgroundImageView, userProfile = _userProfile;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _basicUserInfoView = [[GTIOMeTableHeaderView alloc] initWithFrame:CGRectZero];
        _basicUserInfoView.usesGearInsteadOfPencil = YES;
        _basicUserInfoBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"profile.top.bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0]];
        [_basicUserInfoBackgroundImageView setFrame:CGRectZero];
        [_basicUserInfoBackgroundImageView setUserInteractionEnabled:YES];
        [self addSubview:_basicUserInfoBackgroundImageView];
        [_basicUserInfoBackgroundImageView addSubview:_basicUserInfoView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.basicUserInfoView setFrame:(CGRect){ 0, 0, self.bounds.size.width, 72 }];
    [self.basicUserInfoBackgroundImageView setFrame:(CGRect){ 0, 0, self.basicUserInfoView.bounds.size }];
}

- (void)setUserProfile:(GTIOUserProfile *)userProfile
{
    _userProfile = userProfile;
    [self.basicUserInfoView setUser:self.userProfile.user];
    [self.basicUserInfoView setUserInfoButtons:self.userProfile.userInfoButtons];
    [self.basicUserInfoView setEditButtonTapHandler:^(id sender) {
        NSLog(@"pull up the settings action sheet");
    }];
    [self setNeedsLayout];
}

@end
