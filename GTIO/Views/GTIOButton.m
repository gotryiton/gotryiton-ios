//
//  GTIOButton.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOButton.h"

@implementation GTIOButton

@synthesize tapHandler = _tapHandler, name = _name, action = _action, count = _count, text = _text, attribute = _attribute, value = _value, chevron = _chevron, state = _state, imageURL = _imageURL;

#pragma mark - Button creator helpers

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType 
{
    switch (buttonType) {
        case GTIOButtonTypeSignIn: return [self gtio_signInButton];
        case GTIOButtonTypeNext: return [self gtio_nextButton];
        case GTIOButtonTypeFacebookSignIn: return [self gtio_facebookSignInButton];
        case GTIOButtonTypeFacebookSignUp: return [self gtio_facebookSignUpButton];
        case GTIOButtonTypeAOL: return [self gtio_aolButton];
        case GTIOButtonTypeGoogle: return [self gtio_googleButton];
        case GTIOButtonTypeTwitter: return [self gtio_twitterButton];
        case GTIOButtonTypeYahoo: return [self gtio_yahooButton];
        case GTIOButtonTypeReturningUser: return [self gtio_returningUserButton];
        case GTIOButtonTypeNewUser: return [self gtio_newUserButton];
        case GTIOButtonTypeTryAgain: return [self gtio_tryAgainButton];
        case GTIOButtonTypeEmailSupport: return [self gtio_emailSupportButton];
        case GTIOButtonTypePhotoClose: return [self gtio_photoCloseButton];
        case GTIOButtonTypePhotoPicker: return [self gtio_photoPickerButton];
        case GTIOButtonTypePhotoShootGrid: return [self gtio_photoShootGridButton];
        case GTIOButtonTypePhotoShutter: return [self gtio_photoShutterButton];
        case GTIOButtonTypePhotoFlash: return [self gtio_photoFlashButton];
        case GTIOButtonTypePhotoConfirm: return [self gtio_photoConfirmButton];
        case GTIOButtonTypeBackBottomMargin: return [self gtio_backButtonBottomMargin];
        case GTIOButtonTypeBackTopMargin: return [self gtio_backButtonTopMargin];
        case GTIOButtonTypeSaveGreenTopMargin: return [self gtio_saveButtonGreenTopMargin];
        case GTIOButtonTypeCancelGrayTopMargin: return [self gtio_cancelButtonGrayTopMargin];
        case GTIOButtonTypeSaveGrayTopMargin: return [self gtio_saveButtonGrayTopMargin];
        case GTIOButtonTypePhotoSelectBox: return [self gtio_photoSelectBox];
        case GTIOButtonTypePostThis: return [self gtio_postThisButton];
        case GTIOButtonTypePhotoDelete: return [self gtio_photoDeleteButton];
        case GTIOButtonTypeNotificationBubble: return [self gtio_notificationBubbleButton];
        case GTIOButtonTypeNotificationBubbleEmpty: return [self gtio_notificationBubbleEmptyButton];
        case GTIOButtonTypeEditProfilePencilCircle: return [self gtio_editProfilePencilCircle];
        case GTIOButtonTypeQuickAddCheckbox: return [self gtio_quickAddCheckbox];
        case GTIOButtonTypeFollowButton: return [self gtio_followButton];
        case GTIOButtonTypeAccept: return [self gtio_acceptButton];
        case GTIOButtonTypeBlock: return [self gtio_blockButton];
        case GTIOButtonTypeWebsiteLink: return [self gtio_websiteLinkButton];
        case GTIOButtonTypeFollowButtonForNavBar: return [self gtio_followButtonForNavBar];
        case GTIOButtonTypeFollowingButtonForNavBar: return [self gtio_followingButtonForNavBar];
        case GTIOButtonTypeRequestedButtonForNavBar: return [self gtio_requestedButtonForNavBar];
        default: 
            NSLog(@"Could not find button for type: %i", buttonType);
            return nil;
    }
}

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    id button = [self buttonWithGTIOType:buttonType];
    [button setTapHandler:tapHandler];
    return button;
}

+ (id)buttonWithImage:(UIImage *)image hightlightImage:(UIImage *)highlightImage
{
    id button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, [button imageForState:UIControlStateNormal].size }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)buttonWithCoreImageName:(NSString *)coreImageName
{
    UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-OFF.png", coreImageName]];
    UIImage *buttonHightlightImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-ON.png", coreImageName]];
    return [self buttonWithImage:buttonImage hightlightImage:buttonHightlightImage];
}

+ (id)photoToolbarButtonWithImageName:(NSString *)photoToolbarButtonName
{
    UIButton *button = [self buttonWithImage:[UIImage imageNamed:photoToolbarButtonName] hightlightImage:nil];
    [button setBackgroundImage:[UIImage imageNamed:@"upload.bottom.bar.button.bg.off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"upload.bottom.bar.button.bg.on.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ 0, 0, 39, 53}];
    return button;
}

#pragma mark - Buttons

+ (id)gtio_signInButton
{
    return [self buttonWithCoreImageName:@"intro-bar-sign-in"];
}

+ (id)gtio_nextButton
{
    return [self buttonWithCoreImageName:@"intro-bar-next"];
}

+ (id)gtio_facebookSignUpButton
{
    return [self buttonWithCoreImageName:@"fb-sign-up"];
}

+ (id)gtio_facebookSignInButton
{
    return [self buttonWithCoreImageName:@"fb-sign-in"];
}

+ (id)gtio_aolButton
{
    return [self buttonWithCoreImageName:@"janrain-table-1-aol"];
}

+ (id)gtio_googleButton
{
    return [self buttonWithCoreImageName:@"janrain-table-2-google"];
}

+ (id)gtio_twitterButton
{
    return [self buttonWithCoreImageName:@"janrain-table-3-twitter"];
}

+ (id)gtio_yahooButton
{
    return [self buttonWithCoreImageName:@"janrain-table-4-yahoo"];
}

+ (id)gtio_returningUserButton
{
    return [self buttonWithCoreImageName:@"returning-user"];
}

+ (id)gtio_tryAgainButton
{
    return [self buttonWithCoreImageName:@"fail-table-1-try-again"];
}

+ (id)gtio_newUserButton
{
    return [self buttonWithCoreImageName:@"fail-table-2-new-user"];
}

+ (id)gtio_emailSupportButton
{
    return [self buttonWithCoreImageName:@"fail-table-3-email-support"];
}

+ (id)gtio_backButtonBottomMargin
{
    GTIOButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.inactive.bottommargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.active.bottommargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateHighlighted];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_darkGrayTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-3.0, 6.5, 0, 0)];
    [button setFrame:(CGRect){ 0, 0, 45, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_saveButtonGreenTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"save-button-green-top-margin.png"] hightlightImage:nil];
}

+ (id)gtio_cancelButtonGrayTopMargin
{
    GTIOButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.inactive.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.active.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateHighlighted];
    [button setTitle:@"cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_darkGrayTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 1.0, 0, 0)];
    [button setFrame:(CGRect){ 0, 0, 50, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_saveButtonGrayTopMargin
{
    GTIOButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.inactive.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.active.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateHighlighted];
    [button setTitle:@"save" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_darkGrayTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 1.0, 0, 0)];
    [button setFrame:(CGRect){ 0, 0, 45, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_backButtonTopMargin
{
    GTIOButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.inactive.topmargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.active.topmargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateHighlighted];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_darkGrayTextColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 6.5, 0, 0)];
    [button setFrame:(CGRect){ 0, 0, 45, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_photoCloseButton
{
    return [self photoToolbarButtonWithImageName:@"upload.bottom.bar.icon.x.png"];
}

+ (id)gtio_photoPickerButton
{
    return [self photoToolbarButtonWithImageName:@"upload.bottom.bar.icon.photoroll.png"];
}

+ (id)gtio_photoShootGridButton
{
    return [self photoToolbarButtonWithImageName:@"upload.bottom.bar.icon.photoshootreel.png"];
}

+ (id)gtio_photoConfirmButton
{
    return [self photoToolbarButtonWithImageName:@"upload.bottom.bar.icon.check.png"];
}

+ (id)gtio_photoShutterButton
{
    GTIOButton *button = [GTIOButton buttonWithImage:[UIImage imageNamed:@"upload.bottom.bar.camera.button.icon.normal.png"] hightlightImage:nil];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.off.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.on.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 93, 45 } }];
    return button;
}

+ (id)gtio_photoFlashButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"upload.flash-OFF.png"] hightlightImage:nil];
}

+ (id)gtio_photoSelectBox
{
    GTIOButton *button = [GTIOButton buttonWithImage:[UIImage imageNamed:@"frame-camera-icon-OFF.png"] hightlightImage:[UIImage imageNamed:@"frame-camera-icon-ON.png"]];
    [button setContentMode:UIViewContentModeCenter];
    return button;
}

+ (id)gtio_postThisButton
{
    GTIOButton *button = [GTIOButton buttonWithImage:[UIImage imageNamed:@"post-button-OFF.png"] hightlightImage:[UIImage imageNamed:@"post-button-ON.png"]];
    [button setImage:[UIImage imageNamed:@"post-button-disabled.png"] forState:UIControlStateDisabled];
    return button;
}

+ (id)gtio_photoDeleteButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"remove-frame-OFF.png"] hightlightImage:[UIImage imageNamed:@"remove-frame-ON.png"]];
}

+ (id)gtio_notificationBubbleButton
{
    return [GTIOButton buttonWithImage:[UIImage imageNamed:@"nav.counter.inactive.png"] hightlightImage:[UIImage imageNamed:@"nav.counter.active.png"]];
}

+ (id)gtio_notificationBubbleEmptyButton
{
    return [GTIOButton buttonWithImage:[UIImage imageNamed:@"nav.counter.empty.inactive.png"] hightlightImage:[UIImage imageNamed:@"nav.counter.empty.active.png"]];
}

+ (id)gtio_editProfilePencilCircle
{
    return [GTIOButton buttonWithImage:[UIImage imageNamed:@"edit-info-inactive.png"] hightlightImage:[UIImage imageNamed:@"edit-info-active.png"]];
}

+ (id)gtio_quickAddCheckbox
{
    GTIOButton *button = [GTIOButton buttonWithImage:[UIImage imageNamed:@"checkbox-off.png"] hightlightImage:[UIImage imageNamed:@"checkbox-off.png"]];
    [button setImage:[UIImage imageNamed:@"checkbox-on.png"] forState:UIControlStateSelected];
    return button;
}

+ (id)gtio_followButton
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-on.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-disabled.png"] forState:UIControlStateDisabled];
    [button setFrame:(CGRect){ 0, 0, [UIImage imageNamed:@"follow-button-off.png"].size }];
    [button.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:18.0]];
    [button setTitleColor:[UIColor gtio_reallyDarkGrayTextColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(7.0, 0, 0, 0)];
    [button setTitle:@"follow" forState:UIControlStateDisabled];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_acceptButton
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.accept.off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.accept.on.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"accept" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_blockButton
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.block.off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.block.on.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"block" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_websiteLinkButton
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"profile.top.link.bg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
    [button setTitleColor:[UIColor gtio_reallyDarkGrayTextColor] forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_followButtonForNavBar
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_reallyDarkGrayTextColor] forState:UIControlStateNormal];
    [button setTitle:@"follow" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

+ (id)gtio_followingButtonForNavBar
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"following-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"following-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_reallyDarkGrayTextColor] forState:UIControlStateNormal];
    [button setTitle:@"following" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

+ (id)gtio_requestedButtonForNavBar
{
    GTIOButton *button = [GTIOButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_reallyDarkGrayTextColor] forState:UIControlStateNormal];
    [button setTitle:@"requested" forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

#pragma mark - Touch Handling

- (void)buttonWasTouchedUpInside:(id)sender
{
    if (self.tapHandler) {
        self.tapHandler(sender);
    }
}

@end
