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
    GTIOButtonTypeSignInClose,
    GTIOButtonTypeSignInNav,
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
    GTIOButtonTypePhotoCameraDirection,
    GTIOButtonTypePhotoConfirm,
    GTIOButtonTypeBackBottomMargin,
    GTIOButtonTypeBackTopMargin,
    GTIOButtonTypeSaveGreenTopMargin,
    GTIOButtonTypeSkipGrayTopMargin,
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
    GTIOButtonTypeUniqueNameSave,
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
    GTIOButtonTypeFeedShopThisLook,
    GTIOButtonTypeReload,
    GTIOButtonTypeFindFriends,
    GTIOButtonTypePostRetry,
    GTIOButtonTypeProductBack,
    GTIOButtonTypeProductShareFacebook,
    GTIOButtonTypeProductShareTwitter,
    GTIOButtonTypeProductPostThis,
    GTIOButtonTypeProductTopRightButton,
    GTIOButtonTypeProductShoppingList,
    GTIOButtonTypeProductShoppingListChecked,
    GTIOButtonTypeAutoCompleteHashtag,
    GTIOButtonTypeAutoCompleteAttag,
    GTIOButtonTypeAutoCompleteBrandtag,
    GTIOButtonTypeProductShoppingListHeart,
    GTIOButtonTypeProductShoppingListEmail,
    GTIOButtonTypeProductShoppingListBuy,
    GTIOButtonTypeProductShoppingListDelete,
    GTIOButtonTypeProductShoppingListEmailMyList,
    GTIOButtonTypeProductShoppingListProductOption,
    GTIOButtonTypeProductShoppingListNav,
    GTIOButtonTypeInviteFriendsSMS,
    GTIOButtonTypeInviteFriendsEmail,
    GTIOButtonTypeInviteFriendsTwitter,
    GTIOButtonTypeErrorRetry,
    GTIOButtonTypeShopThisLookHeaderButton,
    GTIOButtonTypeProductBigBuyButton,
    GTIOButtonTypeCustom,
} GTIOButtonType;

@interface GTIOUIButton : UIButton

@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler touchDownHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler touchDragExitHandler;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *titleLabelText;
@property (nonatomic, assign) UIEdgeInsets tapAreaPaddingInsets;
@property (nonatomic, assign) CGFloat tapAreaPadding;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

+ (id)gtio_navBarTopMarginWithText:(NSString *)text tapHandler:(GTIOButtonDidTapHandler)tapHandler;

- (void)showSpinner;
- (void)hideSpinner;

@end
