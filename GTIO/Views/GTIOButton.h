//
//  GTIOButton.h
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

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
    GTIOButtonTypeBackBottomMargin,
    GTIOButtonTypeSaveGreenTopMargin,
    GTIOButtonTypeDoneGrayTopMargin,
    GTIOButtonTypeSaveGrayTopMargin
} GTIOButtonType;

@interface GTIOButton : UIButton

@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
