//
//  GTIOButton.m
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOUIButton.h"
#import "GTIOHeartToggleButton.h"

#import <QuartzCore/QuartzCore.h>

static CGFloat const kGTIOSpinnerSize = 12.0;
static CGFloat const kGTIOSpinnerDefaultSize = 21.0;
static CGFloat const kGTIOSpinnerScale = 0.55;
static CGFloat const kGTIOSpinnerTopPadding = 2.0;

@implementation GTIOUIButton

@synthesize tapHandler = _tapHandler, touchDownHandler = _touchDownHandler, touchDragExitHandler = _touchDragExitHandler;

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
        case GTIOButtonTypePhotoSource: return [self gtio_photoSourceButton];
        case GTIOButtonTypePhotoShootGrid: return [self gtio_photoShootGridButton];
        case GTIOButtonTypePhotoShutter: return [self gtio_photoShutterButton];
        case GTIOButtonTypePhotoFlash: return [self gtio_photoFlashButton];
        case GTIOButtonTypePhotoCameraDirection: return [self gtio_photoCameraDirectionButton];
        case GTIOButtonTypePhotoConfirm: return [self gtio_photoConfirmButton];
        case GTIOButtonTypeBackBottomMargin: return [self gtio_backButtonBottomMargin];
        case GTIOButtonTypeBackTopMargin: return [self gtio_backButtonTopMargin];
        case GTIOButtonTypeSaveGreenTopMargin: return [self gtio_saveButtonGreenTopMargin];
        case GTIOButtonTypeCancelGrayTopMargin: return [self gtio_cancelButtonGrayTopMargin];
        case GTIOButtonTypeSaveGrayTopMargin: return [self gtio_saveButtonGrayTopMargin];
        case GTIOButtonTypeSkipGrayTopMargin: return [self gtio_skipButtonGrayTopMargin];
        case GTIOButtonTypePhotoSelectBox: return [self gtio_photoSelectBox];
        case GTIOButtonTypeEditPhoto: return [self gtio_editPhotoButton];
        case GTIOButtonTypePostThis: return [self gtio_postThisButton];
        case GTIOButtonTypePhotoFrameHandle: return [self gtio_photoFrameHandleButton];
        case GTIOButtonTypePhotoDelete: return [self gtio_photoDeleteButton];
        case GTIOButtonTypeNotificationBubble: return [self gtio_notificationBubbleButton];
        case GTIOButtonTypeNotificationBubbleEmpty: return [self gtio_notificationBubbleEmptyButton];
        case GTIOButtonTypeEditProfilePencilCircle: return [self gtio_editProfilePencilCircle];
        case GTIOButtonTypeQuickAddCheckbox: return [self gtio_quickAddCheckbox];
        case GTIOButtonTypeFollowButton: return [self gtio_followButton];
        case GTIOButtonTypeAccept: return [self gtio_acceptButton];
        case GTIOButtonTypeUniqueNameSave: return [self gtio_uniqueNameSaveButton];
        case GTIOButtonTypeBlock: return [self gtio_blockButton];
        case GTIOButtonTypeWebsiteLink: return [self gtio_websiteLinkButton];
        case GTIOButtonTypeFollowButtonForNavBar: return [self gtio_followButtonForNavBar];
        case GTIOButtonTypeFollowingButtonForNavBar: return [self gtio_followingButtonForNavBar];
        case GTIOButtonTypeRequestedButtonForNavBar: return [self gtio_requestedButtonForNavBar];
        case GTIOButtonTypeMask: return [self gtio_maskButton];
        case GTIOButtonTypeFollowButtonRegular: return [self gtio_followButtonRegular];
        case GTIOButtonTypeFollowingButtonRegular: return [self gtio_followingButtonRegular];
        case GTIOButtonTypeRequestedButtonRegular: return [self gtio_requestedButtonRegular];
        case GTIOButtonTypeCloseButtonForNavBar: return [self gtio_closeButtonGrayTopMargin];
        case GTIOButtonTypeReload: return [self gtio_reloadButtonTopMargin];
        case GTIOButtonTypeFeedShopThisLook: return [self gtio_feedShopThisLook];
        case GTIOButtonTypeFindFriends: return [self gtio_findFriendsTopRightButton];
        case GTIOButtonTypeHeart: return [self gtio_heartButton];
        case GTIOButtonTypeFlag: return [self gtio_flagButton];
        case GTIOButtonTypeRemove: return [self gtio_removeButton];
        case GTIOButtonTypeLeaveAComment: return [self gtio_leaveACommentButton];
        case GTIOButtonTypePostRetry: return [self gtio_postRetryButton];
        case GTIOButtonTypeProductBack: return [self gtio_productBackButton];
        case GTIOButtonTypeProductPostThis: return [self gtio_productPostThisButton];
        case GTIOButtonTypeProductTopRightButton: return [self gtio_productTopRightButton];
        case GTIOButtonTypeProductShoppingList: return [self gtio_productShoppingListButton];
        case GTIOButtonTypeProductShoppingListChecked: return [self gtio_productShoppingListCheckedButton];
        case GTIOButtonTypeAutoCompleteHashtag: return [self gtio_autoCompleteHashtagButton];
        case GTIOButtonTypeAutoCompleteAttag: return [self gtio_autoCompleteAttagButton];
        case GTIOButtonTypeAutoCompleteBrandtag: return [self gtio_autoCompleteBrandtagButton];
        case GTIOButtonTypeProductShoppingListHeart: return [self gtio_productShoppingListHeartButton];
        case GTIOButtonTypeProductShoppingListEmail: return [self gtio_productListEmailButton];
        case GTIOButtonTypeProductShoppingListBuy: return [self gtio_productListBuyButton];
        case GTIOButtonTypeProductShoppingListDelete: return [self gtio_productShoppingListDeleteButton];
        case GTIOButtonTypeProductShoppingListEmailMyList: return [self gtio_productShoppingListEmailMyListButton];
        case GTIOButtonTypeProductShoppingListProductOption: return [self gtio_productShoppingListProductOptionButton];
        case GTIOButtonTypeProductShoppingListNav: return [self gtio_productShoppingListNavButton];
        case GTIOButtonTypeShopThisLookHeaderButton: return [self gtio_shopThisLookHeaderButton];
        case GTIOButtonTypeInviteFriendsSMS: return [self gtio_inviteFriendsSMSButton];
        case GTIOButtonTypeInviteFriendsEmail: return [self gtio_inviteFriendsEmailButton];
        case GTIOButtonTypeInviteFriendsTwitter: return [self gtio_inviteFriendsTwitterButton];
        case GTIOButtonTypeErrorRetry: return [self gtio_errorRetryButton];
        case GTIOButtonTypeCustom: return [self gtio_customButton];
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
    GTIOUIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.inactive.bottommargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.active.bottommargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateHighlighted];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_grayTextColor9C9C9C] forState:UIControlStateNormal];
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

+ (id)gtio_navBarTopMarginWithText:(NSString *)text tapHandler:(GTIOButtonDidTapHandler)tapHandler
{
    GTIOUIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.inactive.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.active.topmargin.png"] stretchableImageWithLeftCapWidth:3.0 topCapHeight:3.0] forState:UIControlStateHighlighted];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_grayTextColor8F8F8F] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:11.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 1.0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTapHandler:tapHandler];
    
    CGSize textSize = [text sizeWithFont:button.titleLabel.font forWidth:200 lineBreakMode:UILineBreakModeTailTruncation];
    [button setFrame:(CGRect){ 0, 0, textSize.width + 14, 30 }];
    
    return button;
}

+ (id)gtio_cancelButtonGrayTopMargin
{
    return [self gtio_navBarTopMarginWithText:@"cancel" tapHandler:nil];
}

+ (id)gtio_closeButtonGrayTopMargin
{
    return [self gtio_navBarTopMarginWithText:@"close" tapHandler:nil];
}

+ (id)gtio_saveButtonGrayTopMargin
{
    return [self gtio_navBarTopMarginWithText:@"save" tapHandler:nil];
}

+ (id)gtio_skipButtonGrayTopMargin
{
    return [self gtio_navBarTopMarginWithText:@" skip " tapHandler:nil];
}

+ (id)gtio_backButtonTopMargin
{
    GTIOUIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.inactive.topmargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"nav.button.back.active.topmargin.png"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:5.0] forState:UIControlStateHighlighted];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_grayTextColor9C9C9C] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 6.5, 0, 0)];
    [button setFrame:(CGRect){ 0, 0, 45, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_productBackButton
{
    GTIOUIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"product.nav.bar.back.inactive.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"product.nav.bar.back.active.png"] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ 0, 0, 45, 30 }];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_photoCloseButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"button.x.inactive.png"] hightlightImage:[UIImage imageNamed:@"button.x.active.png"]];
}

+ (id)gtio_photoSourceButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"button.source.inactive.png"] hightlightImage:[UIImage imageNamed:@"button.source.active.png"]];
}

+ (id)gtio_photoShootGridButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"button.shootgrid.inactive.png"] hightlightImage:[UIImage imageNamed:@"button.shootgrid.active.png"]];
}

+ (id)gtio_photoConfirmButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"button.check.inactive.png"] hightlightImage:[UIImage imageNamed:@"button.check.active.png"]];
}

+ (id)gtio_photoShutterButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"upload.bottom.bar.camera.button.icon.normal.png"] hightlightImage:nil];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.off.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"upload.bottom.bar.camera.button.bg.on.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 10, 9, 9, 9 }] forState:UIControlStateHighlighted];
    [button setFrame:(CGRect){ CGPointZero, { 93, 45 } }];
    return button;
}

+ (id)gtio_photoFlashButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"upload.flash-OFF.png"] hightlightImage:nil];
}

+ (id)gtio_photoCameraDirectionButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"camera-overlay-switcher-inactive.png"] hightlightImage:[UIImage imageNamed:@"camera-overlay-switcher-active.png"]];
}

+ (id)gtio_photoSelectBox
{
    GTIOUIButton *button = [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"frame-camera-icon-OFF.png"] hightlightImage:[UIImage imageNamed:@"frame-camera-icon-ON.png"]];
    [button setContentMode:UIViewContentModeCenter];
    return button;
}

+ (id)gtio_editPhotoButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"edit-photo-button-inactive.png"] hightlightImage:[UIImage imageNamed:@"edit-photo-button-active.png"]];
}

+ (id)gtio_postThisButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"post-button-OFF.png"] hightlightImage:[UIImage imageNamed:@"post-button-ON.png"]];
    [button setImage:[UIImage imageNamed:@"post-button-disabled.png"] forState:UIControlStateDisabled];
    return button;
}

+ (id)gtio_photoDeleteButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"remove-frame-OFF.png"] hightlightImage:[UIImage imageNamed:@"remove-frame-ON.png"]];
}

+ (id)gtio_notificationBubbleButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"nav.counter.inactive.png"] hightlightImage:[UIImage imageNamed:@"nav.counter.active.png"]];
}

+ (id)gtio_notificationBubbleEmptyButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"nav.counter.empty.inactive.png"] hightlightImage:[UIImage imageNamed:@"nav.counter.empty.active.png"]];
}

+ (id)gtio_editProfilePencilCircle
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"edit-info-inactive.png"] hightlightImage:[UIImage imageNamed:@"edit-info-active.png"]];
}

+ (id)gtio_quickAddCheckbox
{
    GTIOUIButton *button = [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"checkbox-off.png"] hightlightImage:[UIImage imageNamed:@"checkbox-off.png"]];
    [button setImage:[UIImage imageNamed:@"checkbox-on.png"] forState:UIControlStateSelected];
    return button;
}

+ (id)gtio_followButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-on.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-button-disabled.png"] forState:UIControlStateDisabled];
    [button setFrame:(CGRect){ 0, 0, [UIImage imageNamed:@"follow-button-off.png"].size }];
    [button.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(7.0, 0, 0, 0)];
    [button setTitle:@"follow" forState:UIControlStateDisabled];
    [button setTitleLabelText:@"follow"];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_uniqueNameSaveButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"save this username" forState:UIControlStateNormal];
    [button setTitle:@"save this username" forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageNamed:@"claim-username-green-inactive.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"claim-username-green-active.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"claim-username-gray-inactive.png"] forState:UIControlStateDisabled];
    [button setFrame:(CGRect){ 0, 0, [UIImage imageNamed:@"claim-username-gray-inactive.png"].size }];
    [button.titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateDisabled];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0.0, 0.0, 0.0)];
    return button;
}

+ (id)gtio_acceptButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.accept.off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.accept.on.png"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_blockButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.block.off.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"profile.top.button.block.on.png"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaBold size:11.0]];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_websiteLinkButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"profile.top.link.bg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:10.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_followButtonForNavBar
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button setTitle:@"follow" forState:UIControlStateNormal];
    [button setTitleLabelText:@"follow"];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

+ (id)gtio_followingButtonForNavBar
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"following-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"following-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button setTitle:@"following" forState:UIControlStateNormal];
    [button setTitleLabelText:@"following"];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

+ (id)gtio_followButtonRegular
{
    GTIOUIButton *button = [self gtio_followButtonForNavBar];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-OFF.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"follow-ON.png"] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return button;
}

+ (id)gtio_followingButtonRegular
{
    GTIOUIButton *button = [self gtio_followingButtonForNavBar];
    [button setBackgroundImage:[UIImage imageNamed:@"following-OFF.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"following-ON.png"] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return button;
}

+ (id)gtio_requestedButtonRegular
{
    GTIOUIButton *button = [self gtio_requestedButtonForNavBar];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-OFF.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-ON.png"] forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    return button;
}

+ (id)gtio_requestedButtonForNavBar
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-OFF-top-margin.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"requested-ON-top-margin.png"] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaRegular size:12.0]];
    [button setTitleColor:[UIColor gtio_grayTextColor515152] forState:UIControlStateNormal];
    [button setTitle:@"requested" forState:UIControlStateNormal];
    [button setTitleLabelText:@"requested"];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 0, 0, 0)];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:(CGRect){ 0, 0, 70, 30 }];
    return button;
}

+ (id)gtio_heartButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"reviews.cell.heart.inactive.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"reviews.cell.heart.active.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"reviews.cell.heart.hearted.inactive.png"] forState:UIControlStateSelected];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

+ (id)gtio_flagButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"reviews.cell.flag.inactive.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"reviews.cell.flag.active.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"reviews.cell.flag.flagged.inactive.png"] forState:UIControlStateSelected];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

+ (id)gtio_removeButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"reviews.cell.delete.inactive.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"reviews.cell.delete.active.png"] forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

+ (id)gtio_leaveACommentButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"reviews.top.input.box.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"reviews.top.input.box.png"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLightItalic size:14.0];
    [button setTitleColor:[UIColor gtio_grayTextColorB7B7B7] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:(UIEdgeInsets){ -5, -125, 0, 0 }];
    [button setTitle:@"Leave a comment!" forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (id)gtio_productPostThisButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.inactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.)] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0];
    [button setTitleColor:[UIColor gtio_grayTextColor555556] forState:UIControlStateNormal];
    [button setTitle:@"post this" forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *postButtonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product.info.button.icon.post.png"]];
    [postButtonIcon setFrame:(CGRect){ 24.0, 16.0, postButtonIcon.bounds.size }];
    [button addSubview:postButtonIcon];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 37.0, 0.0, 0.0)];
    [button setFrame:(CGRect){ 0.0, 0.0, 153.0, 46.0 }];
    return button;
}

+ (id)gtio_productShoppingListButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.inactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0];
    [button setTitleColor:[UIColor gtio_grayTextColor555556] forState:UIControlStateNormal];
    [button setTitle:@"shopping list" forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *postButtonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product.info.button.icon.shopping.png"]];
    [postButtonIcon setFrame:(CGRect){ 22.0, 15.0, postButtonIcon.bounds.size }];
    [button addSubview:postButtonIcon];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 23.0, 0.0, 0.0)];
    [button setFrame:(CGRect){ 0.0, 0.0, 153.0, 46.0 }];
    return button;
}

+ (id)gtio_productShoppingListCheckedButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.highlight.inactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"product.info.button.bg.highlight.active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:16.0];
    [button setTitleColor:[UIColor gtio_grayTextColor555556] forState:UIControlStateNormal];
    [button setTitle:@"shopping list" forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *postButtonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product.info.button.icon.checkmark.png"]];
    [postButtonIcon setFrame:(CGRect){ 19.0, 13.0, postButtonIcon.bounds.size }];
    [button addSubview:postButtonIcon];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(4.0, 23.0, 0.0, 0.0)];
    [button setFrame:(CGRect){ 0.0, 0.0, 153.0, 46.0 }];
    return button;
}

+ (id)gtio_productShoppingListDeleteButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"shopping.cell.close.inactive.png"] hightlightImage:[UIImage imageNamed:@"shopping.cell.close.active.png"]];
}

+ (id)gtio_productListEmailButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"shopping.button.email.inactive.png"] hightlightImage:[UIImage imageNamed:@"shopping.button.email.active.png"]];
}

+ (id)gtio_productListBuyButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"shopping.button.buy.inactive.png"] hightlightImage:[UIImage imageNamed:@"shopping.button.buy.active.png"]];
}

+ (id)gtio_photoFrameHandleButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"photo-frame-handle-inactive.png"] hightlightImage:nil];
}

+ (id)gtio_shopThisLookHeaderButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"shop-this-look-header.png"] hightlightImage:[UIImage imageNamed:@"shop-this-look-header.png"]];
}

+ (id)gtio_feedShopThisLook
{
    GTIOUIButton *button = [self buttonWithImage:[UIImage imageNamed:@"shop-this-look-button-inactive.png"] hightlightImage:[UIImage imageNamed:@"shop-this-look-button-active.png"]];
    return button;
}

+ (id)gtio_productShoppingListProductOptionButton
{
    GTIOUIButton *button = [self buttonWithImage:[UIImage imageNamed:@"shopping.bottom.image.overlay.png"] hightlightImage:[UIImage imageNamed:@"shopping.bottom.image.overlay.active.png"]];
    button.clipsToBounds = NO;
    UIImageView *plusSignView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping.bottom.plus.inactive.png"]];
    [plusSignView setFrame:(CGRect){ button.bounds.size.width - plusSignView.bounds.size.width + 7, -(plusSignView.bounds.size.height / 2) + 8, plusSignView.bounds.size }];
    [button addSubview:plusSignView];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:button action:@selector(buttonWasTouchedDraggedExited:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:button action:@selector(buttonWasTouchedDownInside:) forControlEvents:UIControlEventTouchDown];
    return button;
}

+ (id)gtio_productShoppingListNavButton
{
    GTIOUIButton *button = [self buttonWithImage:[UIImage imageNamed:@"nav.bar.dot.inactive.png"] hightlightImage:[UIImage imageNamed:@"nav.bar.dot.active.png"]];
    [button setImageEdgeInsets:(UIEdgeInsets){2, 0, -2, 0}];
    [button.imageView setFrame:(CGRect){ button.bounds.origin.x, button.bounds.origin.y, button.bounds.size.width, button.bounds.size.height	 }];
    return button;
}

+ (id)gtio_maskButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:button action:@selector(buttonWasTouchedDownInside:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:button action:@selector(buttonWasTouchedDraggedExited:) forControlEvents:UIControlEventTouchDragExit];
    return button;
}

+ (id)gtio_reloadButtonTopMargin
{
    return [self buttonWithImage:[UIImage imageNamed:@"nav.bar.icon.refresh.png"] hightlightImage:nil];
}

+ (id)gtio_findFriendsTopRightButton
{
    GTIOUIButton *button = [self buttonWithImage:[UIImage imageNamed:@"nav.search.icon.png"] hightlightImage:nil];
    [button setFrame:(CGRect){ button.bounds.origin, button.bounds.size.width + 10, button.bounds.size.height }];
    return button;
}

+ (id)gtio_productTopRightButton
{
    GTIOUIButton *button = [self buttonWithImage:[UIImage imageNamed:@"nav.bar.out.png"] hightlightImage:nil];
    [button setFrame:(CGRect){button.frame.origin, button.bounds.size.width + 10, button.bounds.size.height}];
    return button;
}

+ (id)gtio_postRetryButton
{
    return [self buttonWithImage:[UIImage imageNamed:@"uploading.fail.avatar.overlay.inactive.png"] hightlightImage:[UIImage imageNamed:@"uploading.fail.avatar.overlay.active.png"]];
}

+ (id)gtio_facebookShareButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"product.social.fb.inactive.png"] hightlightImage:[UIImage imageNamed:@"product.social.fb.active.png"]];
}

+ (id)gtio_twitterShareButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"product.social.twit.inactive.png"] hightlightImage:[UIImage imageNamed:@"product.social.twit.active.png"]];
}

+ (id)gtio_autoCompleteHashtagButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"keyboard-top-control-start-2-inactive.png"] hightlightImage:[UIImage imageNamed:@"keyboard-top-control-start-2-active.png"]];
}

+ (id)gtio_autoCompleteAttagButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"keyboard-top-control-start-1-inactive.png"] hightlightImage:[UIImage imageNamed:@"keyboard-top-control-start-1-active.png"]];
}

+ (id)gtio_autoCompleteBrandtagButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"keyboard-top-control-start-3-inactive.png"] hightlightImage:[UIImage imageNamed:@"keyboard-top-control-start-3-active.png"]];
}
+ (id)gtio_productShoppingListHeartButton
{
    GTIOUIButton *button = [[GTIOHeartToggleButton alloc] initWithFrame:CGRectZero];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

+ (id)gtio_productShoppingListEmailMyListButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"shopping.navigation.bar.button.share.inactive.png"] hightlightImage:[UIImage imageNamed:@"shopping.navigation.bar.button.share.active.png"]];
}

+ (id)gtio_inviteFriendsSMSButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"invite.topbuttons.sms.off.png"] hightlightImage:[UIImage imageNamed:@"invite.topbuttons.sms.on.png"]];
}

+ (id)gtio_inviteFriendsEmailButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"invite.topbuttons.email.off.png"] hightlightImage:[UIImage imageNamed:@"invite.topbuttons.email.on.png"]];
}

+ (id)gtio_inviteFriendsTwitterButton
{
    return [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"invite.topbuttons.twitter.off.png"] hightlightImage:[UIImage imageNamed:@"invite.topbuttons.twitter.on.png"]];
}

+ (id)gtio_errorRetryButton
{
    id button = [GTIOUIButton buttonWithImage:[UIImage imageNamed:@"connect-error-retry-inactive.png"] hightlightImage:[UIImage imageNamed:@"connect-error-retry-active.png"]];
    [button setTapAreaPadding:10.0f];
    return button;
}

+ (id)gtio_customButton
{
    GTIOUIButton *button = [GTIOUIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:button action:@selector(buttonWasTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Touch Handling

- (void)buttonWasTouchedUpInside:(id)sender
{
    if (self.tapHandler) {
        self.tapHandler(sender);
    }
}

- (void)buttonWasTouchedDownInside:(id)sender
{
    if (self.touchDownHandler) {
        self.touchDownHandler(sender);
    }
}

- (void)buttonWasTouchedDraggedExited:(id)sender
{
    if (self.touchDragExitHandler) {
        self.touchDragExitHandler(sender);
    }
}

- (void)showSpinner
{
    if (!self.titleLabelText && ![self.titleLabel.text isEqualToString:@""]){
        self.titleLabelText = [self.titleLabel text];
    }
    [self setTitle:@"" forState:UIControlStateNormal];
    
    CGRect innerFrame = CGRectMake( self.bounds.size.width/2 - kGTIOSpinnerSize/2 , self.bounds.size.height/2 - kGTIOSpinnerSize/2 , kGTIOSpinnerSize, kGTIOSpinnerSize);
    innerFrame = UIEdgeInsetsInsetRect(innerFrame, self.titleEdgeInsets);

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:innerFrame];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityIndicator.frame =innerFrame;

    self.activityIndicator.transform = CGAffineTransformMakeScale(kGTIOSpinnerSize/kGTIOSpinnerDefaultSize, kGTIOSpinnerSize/kGTIOSpinnerDefaultSize);

    [self.activityIndicator startAnimating];

    [self addSubview:self.activityIndicator];
}

- (void)hideSpinner
{
    if (self.titleLabelText) {
        [self setTitle:self.titleLabelText forState:UIControlStateNormal];
    }

    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
}


- (void)setTapAreaPadding:(CGFloat)tapAreaPadding
{
    _tapAreaPadding = tapAreaPadding;
    self.tapAreaPaddingInsets = UIEdgeInsetsMake(-tapAreaPadding, -tapAreaPadding, -tapAreaPadding, -tapAreaPadding);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect paddedFrame =  UIEdgeInsetsInsetRect(self.bounds, self.tapAreaPaddingInsets);
    return (CGRectContainsPoint(paddedFrame, point) == 1);
}

@end
