//
//  GTIOButton.h
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOButtonAction.h"

typedef void(^GTIOButtonDidTapHandler)(id sender);

typedef enum GTIOButtonType {
    GTIOButtonTypeSignIn = 0,
    GTIOButtonTypeNext,
    GTIOButtonTypeFacebookSignUp,
    GTIOButtonTypeFacebookSignIn,
    GTIOButtonTypeAOL,
    GTIOButtonTypeGoogle,
    GTIOButtonTypeTwitter,
    GTIOButtonTypeYahoo,
    GTIOButtonTypeReturningUser,
    GTIOButtonTypeTryAgain,
    GTIOButtonTypeNewUser,
    GTIOButtonTypeEmailSupport,
    GTIOButtonTypeBack,
    GTIOButtonTypePhotoClose,
    GTIOButtonTypePhotoPicker,
    GTIOButtonTypePhotoShootGrid,
    GTIOButtonTypePhotoShutter,
    GTIOButtonTypePhotoFlash,
    GTIOButtonTypePhotoConfirm,
    GTIOButtonTypeBackBottomMargin,
    GTIOButtonTypeBackTopMargin,
    GTIOButtonTypeSaveGreenTopMargin,
    GTIOButtonTypeCancelGrayTopMargin,
    GTIOButtonTypeSaveGrayTopMargin,
    GTIOButtonTypePhotoSelectBox,
    GTIOButtonTypePostThis,
    GTIOButtonTypePhotoDelete,
    GTIOButtonTypeNotificationBubble,
    GTIOButtonTypeNotificationBubbleEmpty,
    GTIOButtonTypeEditProfilePencilCircle,
    GTIOButtonTypeQuickAddCheckbox,
    GTIOButtonTypeFollowButton,
    GTIOButtonTypeAccept,
    GTIOButtonTypeBlock,
    GTIOButtonTypeWebsiteLink,
    GTIOButtonTypeFollowButtonForNavBar,
    GTIOButtonTypeFollowingButtonForNavBar,
    GTIOButtonTypeRequestedButtonForNavBar,
    GTIOButtonTypeMask,
    GTIOButtonTypeActionSheetCancel
} GTIOButtonType;

@interface GTIOUIButton : UIButton

@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;
+ (id)largeButtonWithGTIOStyle:(GTIOLargeButtonStyle)largeButtonStyle;

+ (id)gtio_navBarTopMarginWithText:(NSString *)text tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
