//
//  GTIOButton.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOButton.h"

@implementation GTIOButton

@synthesize tapHandler = _tapHandler;

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
    return [self buttonWithImage:[UIImage imageNamed:@"login-nav-back.png"] hightlightImage:nil];
}

+ (id)gtio_saveButtonGreenTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"save-button-green-top-margin.png"] hightlightImage:nil];
}

+ (id)gtio_cancelButtonGrayTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"cancel-button-gray-top-margin.png"] hightlightImage:nil];
}

+ (id)gtio_saveButtonGrayTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"save-button-gray-top-margin.png"] hightlightImage:nil];
}

+ (id)gtio_backButtonTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"general.back.top.margin.png"] hightlightImage:nil];
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
    UIButton *button = [GTIOButton buttonWithImage:[UIImage imageNamed:@"upload.bottom.bar.camera.button.icon.normal.png"] hightlightImage:nil];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.off.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.on.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 93, 45 } }];
    return button;
}

+ (id)gtio_photoFlashButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"upload.flash.off.png"] hightlightImage:nil];
}

#pragma mark - Touch Handling

- (void)buttonWasTouchedUpInside:(id)sender
{
    if (self.tapHandler) {
        self.tapHandler(sender);
    }
}

@end
