//
//  GTIOButton.h
//  GTIO
//
//  Created by Scott Penrose on 5/17/12.
//  Copyright (c) 2012 . All rights reserved.
//

typedef void(^GTIOButtonDidTapHandler)(id sender);

typedef enum GTIOButtonType {
    GTIOButtonTypeSignInButton = 0,
    GTIOButtonTypeNextButton,
    GTIOButtonTypeFacebookSignUpButton,
    GTIOButtonTypeFacebookSignInButton,
    GTIOButtonTypeAOLButton,
    GTIOButtonTypeGoogleButton,
    GTIOButtonTypeTwitterButton,
    GTIOButtonTypeYahooButton,
    GTIOButtonTypeReturningUserButton,
} GTIOButtonType;

@interface GTIOButton : UIButton

@property (nonatomic, copy) GTIOButtonDidTapHandler tapHandler;

+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType;
+ (id)buttonWithGTIOType:(GTIOButtonType)buttonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
