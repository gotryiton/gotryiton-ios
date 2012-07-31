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
    GTIOButtonTypePhotoClose,
    GTIOButtonTypePhotoSource,
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
    GTIOButtonTypeEditPhoto,
    GTIOButtonTypePostThis,
    GTIOButtonTypePhotoFrameHandle,
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
    GTIOButtonTypeFollowButtonRegular,
    GTIOButtonTypeFollowingButtonRegular,
    GTIOButtonTypeRequestedButtonRegular,
    GTIOButtonTypeCloseButtonForNavBar,
    GTIOButtonTypeHeart,
    GTIOButtonTypeFlag,
    GTIOButtonTypeRemove,
    GTIOButtonTypeLeaveAComment,
    GTIOButtonTypeReload,
    GTIOButtonTypeFindFriends,
    GTIOButtonTypePostRetry,
    GTIOButtonTypeProductBack,
    GTIOButtonTypeProductShareFacebook,
    GTIOButtonTypeProductShareTwitter,
    GTIOButtonTypeProductPostThis,
    GTIOButtonTypeProductShoppingList,
    GTIOButtonTypeProductShoppingListChecked,
    GTIOButtonTypeProductShoppingListHeart,
    GTIOButtonTypeProductShoppingListEmail,
    GTIOButtonTypeProductShoppingListBuy,
    GTIOButtonTypeProductShoppingListDelete,
    GTIOButtonTypeProductShoppingListEmailMyList,
    GTIOButtonTypeProductShoppingListProductOption,
    GTIOButtonTypeProductShoppingListNav,
    GTIOButtonTypeInviteFriendsSMS,
    GTIOButtonTypeInviteFriendsEmail,
    GTIOButtonTypeInviteFriendsFacebook,
    GTIOButtonTypeErrorRetry,
} GTIOButtonType;

@interface GTIOUIButton : UIButton

@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler touchDownHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler touchDragExitHandler;
@property (nonatomic, assign) UIEdgeInsets tapAreaPaddingInsets;
@property (nonatomic, assign) CGFloat tapAreaPadding;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

+ (id)gtio_navBarTopMarginWithText:(NSString *)text tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
