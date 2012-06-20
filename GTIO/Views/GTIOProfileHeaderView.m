//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileHeaderView.h"
#import "GTIOMeTableHeaderView.h"
#import "GTIOWantsToFollowYouView.h"

#import "UIImageView+WebCache.h"

@interface GTIOProfileHeaderView()

@property (nonatomic, strong) UIImageView *banner;
@property (nonatomic, strong) GTIOWantsToFollowYouView *wantsToFollowYouView;
@property (nonatomic, strong) GTIOMeTableHeaderView *basicUserInfoView;
@property (nonatomic, strong) UIImageView *basicUserInfoBackgroundImageView;
@property (nonatomic, strong) UILabel *profileDescription;
@property (nonatomic, strong) GTIOButton *websiteLinkButton;

@end

@implementation GTIOProfileHeaderView

@synthesize banner = _banner;
@synthesize wantsToFollowYouView = _wantsToFollowYouView;
@synthesize basicUserInfoView = _basicUserInfoView, basicUserInfoBackgroundImageView = _basicUserInfoBackgroundImageView, userProfile = _userProfile;
@synthesize profileDescription = _profileDescription;
@synthesize websiteLinkButton = _websiteLinkButton;

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
        
        _wantsToFollowYouView = [[GTIOWantsToFollowYouView alloc] initWithFrame:CGRectZero];
        [_basicUserInfoBackgroundImageView addSubview:_wantsToFollowYouView];
        
        _profileDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        [_profileDescription setBackgroundColor:[UIColor clearColor]];
        [_profileDescription setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11]];
        [_profileDescription setTextColor:[UIColor gtio_profileDescriptionTextColor]];
        [_profileDescription setNumberOfLines:0];
        [_profileDescription setLineBreakMode:UILineBreakModeWordWrap];
        [_basicUserInfoBackgroundImageView addSubview:_profileDescription];
        
        _websiteLinkButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeWebsiteLink];
        [_basicUserInfoBackgroundImageView addSubview:_websiteLinkButton];
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.banner.bounds.size.height > 0) {
        [self.banner setFrame:(CGRect){ 0, 0, self.bounds.size.width, self.banner.bounds.size.height }];
    }
    if (FALSE) {
        [self.wantsToFollowYouView setFrame:(CGRect){ 0, 0, self.bounds.size.width, 32 }];
    }
    [self.basicUserInfoView setFrame:(CGRect){ 0, self.wantsToFollowYouView.frame.origin.y + self.wantsToFollowYouView.bounds.size.height, self.bounds.size.width, 72 }];
    [self.profileDescription sizeToFit];
    [self.profileDescription setFrame:(CGRect){ 12, self.basicUserInfoView.frame.origin.y + self.basicUserInfoView.bounds.size.height, self.bounds.size.width - 24, (self.userProfile.user.aboutMe.length > 0) ? self.profileDescription.bounds.size.height : 0 }];
    [self.websiteLinkButton setFrame:(CGRect){ 8, self.profileDescription.frame.origin.y + self.profileDescription.bounds.size.height + 3, self.bounds.size.width - 16, (self.websiteLinkButton.titleLabel.text.length > 0) ? 24 : 0 }];
    [self.basicUserInfoBackgroundImageView setFrame:(CGRect){ 0, self.banner.frame.origin.y + self.banner.bounds.size.height, self.bounds.size.width, self.websiteLinkButton.frame.origin.y + self.websiteLinkButton.bounds.size.height + 10 }];
    [self setFrame:(CGRect){ self.frame.origin, self.bounds.size.width, self.basicUserInfoBackgroundImageView.bounds.size.height }];
}

- (void)setUserProfile:(GTIOUserProfile *)userProfile completionHandler:(GTIOProfileInitCompletionHandler)completionHandler
{
    _userProfile = userProfile;
    for (GTIOButton *button in self.userProfile.userInfoButtons) {
        __block typeof(self) blockSelf = self;
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameBannerAd]) {
            [self.banner setImageWithURL:button.imageURL placeholderImage:nil success:^(UIImage *image) {
                [blockSelf.banner setImage:image];
                [blockSelf.banner sizeToFit];
                [blockSelf setNeedsLayout];
            } failure:nil];
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameWebsite]) {
            [self.websiteLinkButton setTitle:[button.text uppercaseString] forState:UIControlStateNormal];
            [self.websiteLinkButton setTapHandler:^(id sender) {
                [blockSelf openURLWithSafari:button.action.destination];
            }];
        }
    }
    [self.basicUserInfoView setUser:self.userProfile.user];
    [self.basicUserInfoView setUserInfoButtons:self.userProfile.userInfoButtons];
    [self.basicUserInfoView setEditButtonTapHandler:^(id sender) {
        NSLog(@"pull up the settings action sheet");
    }];
    [self.profileDescription setText:self.userProfile.user.aboutMe];
    [self layoutSubviews];
    completionHandler(self);
}

- (void)openURLWithSafari:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
