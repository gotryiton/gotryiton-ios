//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileHeaderView.h"
#import "GTIOMeTableHeaderView.h"
#import "UIImageView+WebCache.h"

@interface GTIOProfileHeaderView()

@property (nonatomic, strong) GTIOMeTableHeaderView *basicUserInfoView;
@property (nonatomic, strong) UIImageView *basicUserInfoBackgroundImageView;

@property (nonatomic, strong) UIImageView *banner;

@end

@implementation GTIOProfileHeaderView

@synthesize basicUserInfoView = _basicUserInfoView, basicUserInfoBackgroundImageView = _basicUserInfoBackgroundImageView, userProfile = _userProfile;
@synthesize banner = _banner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _banner = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_banner];
        
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
    if (self.banner.bounds.size.height > 0) {
        [self.banner setFrame:(CGRect){ 0, 0, self.bounds.size.width, self.banner.bounds.size.height }];
    }
    [self.basicUserInfoView setFrame:(CGRect){ 0, 0, self.bounds.size.width, 72 }];
    [self.basicUserInfoBackgroundImageView setFrame:(CGRect){ 0, self.banner.frame.origin.y + self.banner.bounds.size.height, self.basicUserInfoView.bounds.size }];
}

- (void)setUserProfile:(GTIOUserProfile *)userProfile
{
    _userProfile = userProfile;
    for (GTIOButton *button in self.userProfile.userInfoButtons) {
        if ([button.name isEqualToString:@"banner-ad"]) {
            __block typeof(self) blockSelf = self;
            [self.banner setImageWithURL:button.imageURL placeholderImage:nil success:^(UIImage *image) {
                [blockSelf.banner setImage:image];
                [blockSelf.banner sizeToFit];
                [blockSelf setNeedsLayout];
            } failure:nil];
        }
    }
    [self.basicUserInfoView setUser:self.userProfile.user];
    [self.basicUserInfoView setUserInfoButtons:self.userProfile.userInfoButtons];
    [self.basicUserInfoView setEditButtonTapHandler:^(id sender) {
        NSLog(@"pull up the settings action sheet");
    }];
    [self setNeedsLayout];
}

@end
