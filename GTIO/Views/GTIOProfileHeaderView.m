//
//  GTIOProfileHeaderView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProfileHeaderView.h"
#import "GTIOProfileCalloutView.h"
#import "GTIOActionSheet.h"
#import "GTIOProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <RestKit/RestKit.h>

static CGFloat const kGTIOWebsiteButtonPadding = 8.0f;
static CGFloat const kGTIOBannerAdWidth = 320.0f;
static CGFloat const kGTIOBannerAdHeight = 50.0f;

@interface GTIOProfileHeaderView()

@property (nonatomic, strong) UIImageView *banner;
@property (nonatomic, strong) GTIOFollowRequestAcceptBarView *followRequestAcceptBarView;
@property (nonatomic, strong) GTIOMeTableHeaderView *basicUserInfoView;
@property (nonatomic, strong) UIImageView *basicUserInfoBackgroundImageView;
@property (nonatomic, strong) UILabel *profileDescription;
@property (nonatomic, strong) GTIOUIButton *websiteLinkButton;
@property (nonatomic, strong) NSMutableArray *profileCalloutViews;
@property (nonatomic, strong) GTIOActionSheet *actionSheet;

@property (nonatomic, strong) UITapGestureRecognizer *bannerTapRecognizer;
@property (nonatomic, strong) NSString *bannerDestination;

@property (nonatomic, copy) GTIOProfileInitCompletionHandler userProfileLayoutCompletionHandler;
@property (nonatomic, assign) BOOL bannerImageDownloadProcessComplete;
@property (nonatomic, assign) BOOL hasBannerImage;


@end

@implementation GTIOProfileHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _banner = [[UIImageView alloc] initWithFrame:CGRectZero];
        _banner.contentMode = UIViewContentModeScaleAspectFit;
        _banner.userInteractionEnabled = YES;
        [self addSubview:_banner];

        self.bannerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerTap)];
        [_banner addGestureRecognizer:self.bannerTapRecognizer];
        
        _basicUserInfoView = [[GTIOMeTableHeaderView alloc] initWithFrame:CGRectZero];
        _basicUserInfoView.usesGearInsteadOfPencil = YES;
        _basicUserInfoBackgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"profile.top.bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:10.0]];
        [_basicUserInfoBackgroundImageView setFrame:CGRectZero];
        [_basicUserInfoBackgroundImageView setUserInteractionEnabled:YES];
        [self addSubview:_basicUserInfoBackgroundImageView];
        [_basicUserInfoBackgroundImageView addSubview:_basicUserInfoView];
        
        _followRequestAcceptBarView = [[GTIOFollowRequestAcceptBarView alloc] initWithFrame:CGRectZero];
        [_followRequestAcceptBarView setDelegate:self];
        [_basicUserInfoBackgroundImageView addSubview:_followRequestAcceptBarView];
        
        _profileDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        [_profileDescription setBackgroundColor:[UIColor clearColor]];
        [_profileDescription setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11]];
        [_profileDescription setTextColor:[UIColor gtio_profileDescriptionTextColor]];
        [_profileDescription setNumberOfLines:0];
        [_profileDescription setLineBreakMode:UILineBreakModeWordWrap];
        [_basicUserInfoBackgroundImageView addSubview:_profileDescription];
        
        _websiteLinkButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeWebsiteLink];
        [_basicUserInfoBackgroundImageView addSubview:_websiteLinkButton];
        
        _profileCalloutViews = [NSMutableArray array];
        _bannerImageDownloadProcessComplete = NO;
        _hasBannerImage = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger bannerHeight = 0;
    if (self.hasBannerImage) {
        [self.banner setFrame:(CGRect){ 0, 0, kGTIOBannerAdWidth, kGTIOBannerAdHeight }];
        bannerHeight = kGTIOBannerAdHeight;
    }
    if (self.userProfile.acceptBar) {
        [self.followRequestAcceptBarView setFrame:(CGRect){ 0, 0, self.bounds.size.width, 32 }];
    } else {
        [self.followRequestAcceptBarView setFrame:CGRectZero];
    }

    [self.basicUserInfoView setFrame:(CGRect){ 0, self.followRequestAcceptBarView.frame.origin.y  + self.followRequestAcceptBarView.frame.size.height + bannerHeight, self.bounds.size.width, 72 }];
    
    [self.profileDescription sizeToFit];
    [self.profileDescription setFrame:(CGRect){ 12, self.basicUserInfoView.frame.origin.y + self.basicUserInfoView.frame.size.height, self.bounds.size.width - 24, (self.userProfile.user.aboutMe.length > 0) ? self.profileDescription.bounds.size.height : 0 }];
    
    
    NSString *buttonTitle = [self.websiteLinkButton titleForState:UIControlStateNormal];    
    [self.websiteLinkButton setFrame:(CGRect){ 8, self.profileDescription.frame.origin.y + self.profileDescription.bounds.size.height + ((buttonTitle.length > 0) ? 6 : 0), self.bounds.size.width - 16, (buttonTitle.length > 0) ? 24 : 0 }];
    
    
    double profileCalloutsYPosition = self.websiteLinkButton.frame.origin.y + self.websiteLinkButton.bounds.size.height;
    profileCalloutsYPosition += (buttonTitle.length > 0) ? kGTIOWebsiteButtonPadding : 3;
    double profileCalloutsHeight = 11.0 ;
    GTIOProfileCalloutView *lastProfileCalloutView = nil;
    for (GTIOProfileCalloutView *profileCalloutView in self.profileCalloutViews) {
        [profileCalloutView setFrame:(CGRect){ 9, profileCalloutsYPosition, self.profileDescription.bounds.size.width, profileCalloutsHeight }];
        profileCalloutsYPosition += profileCalloutsHeight + 3;
        lastProfileCalloutView = profileCalloutView;
    }
    
    if (lastProfileCalloutView) {
        [self.basicUserInfoBackgroundImageView setFrame:(CGRect){ 0, 0, self.bounds.size.width, lastProfileCalloutView.frame.origin.y  + lastProfileCalloutView.bounds.size.height + 10 }];
    } else {
        [self.basicUserInfoBackgroundImageView setFrame:(CGRect){ 0, 0, self.bounds.size.width, self.websiteLinkButton.frame.origin.y  + self.websiteLinkButton.bounds.size.height + ((buttonTitle.length > 0 || self.profileDescription.text.length > 0) ? ((self.profileCalloutViews.count == 0) ? 10 : 13 ): 0) }];
    }
    [self setFrame:(CGRect){ self.frame.origin, self.bounds.size.width, self.basicUserInfoBackgroundImageView.frame.size.height }];
    
    [self bringSubviewToFront:self.banner];
    
    if (self.userProfileLayoutCompletionHandler && !self.hasBannerImage) {
        self.userProfileLayoutCompletionHandler(self);
        self.userProfileLayoutCompletionHandler = nil;
    } else if (self.userProfileLayoutCompletionHandler && self.bannerImageDownloadProcessComplete) {
        self.userProfileLayoutCompletionHandler(self);
        self.userProfileLayoutCompletionHandler = nil;
    }
    
    if ([self.acceptBarDelegate respondsToSelector:@selector(acceptBarRemoved)] && self.userProfile.acceptBar == nil) {
        [self.acceptBarDelegate acceptBarRemoved];
    }
}

- (void)setUserProfile:(GTIOUserProfile *)userProfile completionHandler:(GTIOProfileInitCompletionHandler)completionHandler
{
    _userProfile = userProfile;
    if (self.userProfile.acceptBar) {
        [self.followRequestAcceptBarView setFollowRequestAcceptBar:self.userProfile.acceptBar];
    }
    for (GTIOButton *button in self.userProfile.userInfoButtons) {
        __block typeof(self) blockSelf = self;
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameBannerAd]) {
            self.hasBannerImage = YES;
            self.bannerDestination = button.action.destination;
            [self.banner setImageWithURL:button.imageURL placeholderImage:nil success:^(UIImage *image, BOOL cached) {
                [blockSelf.banner setImage:image];
                blockSelf.bannerImageDownloadProcessComplete = YES;
                [blockSelf setNeedsLayout];
            } failure:^(NSError *error) {
                blockSelf.bannerImageDownloadProcessComplete = YES;
                [blockSelf setNeedsLayout];
            }];
        }
        if ([button.name isEqualToString:kGTIOUserInfoButtonNameWebsite]) {
            NSString *buttonText = [button.text uppercaseString];
            [self.websiteLinkButton setTitle:buttonText forState:UIControlStateNormal];
            [self.websiteLinkButton setTapHandler:^(id sender) {
                if (self.profileOpenURLHandler) {
                    self.profileOpenURLHandler([NSURL URLWithString:button.action.destination]);
                }
            }];
        }
    }
    [self.basicUserInfoView setUser:self.userProfile.user];
    [self.basicUserInfoView setUserInfoButtons:self.userProfile.userInfoButtons];
    if (self.userProfile.settingsButtons.count > 0) {
        [self.basicUserInfoView setEditButtonTapHandler:^(id sender) {
            self.actionSheet = [[GTIOActionSheet alloc] initWithButtons:self.userProfile.settingsButtons buttonTapHandler:nil];
            [self.actionSheet showWithConfigurationBlock:^(GTIOActionSheet *actionSheet) {
                actionSheet.didDismiss = ^(GTIOActionSheet *actionSheet) {
                    if (!actionSheet.wasCancelled) {
                        if ([self.delegate respondsToSelector:@selector(refreshUserProfile)]) {
                            [self.delegate refreshUserProfile];
                        }
                    }
                };
            }];
        }];
    } else {
        [self.basicUserInfoView setSettingsButtonHidden:YES];
    }
    [self.profileDescription setText:self.userProfile.user.aboutMe];
    
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[GTIOProfileCalloutView class]]) {
            [view removeFromSuperview];
        }
    }
    [self.profileCalloutViews removeAllObjects];

    for (GTIOProfileCallout *profileCallout in self.userProfile.profileCallOuts) {
        GTIOProfileCalloutView *profileCalloutView = [[GTIOProfileCalloutView alloc] initWithFrame:CGRectZero];
        [profileCalloutView setProfileCallout:profileCallout user:self.userProfile.user];
        [self addSubview:profileCalloutView];
        [self.profileCalloutViews addObject:profileCalloutView];
    }
    self.userProfileLayoutCompletionHandler = completionHandler;
    [self setNeedsLayout];
}

- (void)setMeTableHeaderViewDelegate:(id<GTIOMeTableHeaderViewDelegate>)meTableHeaderViewDelegate
{
    _meTableHeaderViewDelegate = meTableHeaderViewDelegate;
    [self.basicUserInfoView setDelegate:_meTableHeaderViewDelegate];
}

- (void)removeAcceptBar
{
    self.userProfile.acceptBar = nil;
    [self setNeedsLayout];
}


- (void)bannerTap
{
    if ([self.delegate respondsToSelector:@selector(bannerTapWithUrl:)]){
        [self.delegate bannerTapWithUrl:self.bannerDestination];
    }
}

@end
