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
    GTIOButtonTypeMask
} GTIOButtonType;

typedef enum GTIOFollowButtonState {
    GTIOFollowButtonStateFollow = 0,
    GTIOFollowButtonStateFollowing,
    GTIOFollowButtonStateRequested
} GTIOFollowButtonState;

typedef enum GTIOAcceptRelationshipButtonState {
    GTIOAcceptRelationshipButtonStateBlock = 0,
    GTIOAcceptRelationshipButtonStateAccept
} GTIOAcceptRelationshipButtonState;

@interface GTIOButton : UIButton

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *chevron;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) GTIOButtonAction *action;
@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
