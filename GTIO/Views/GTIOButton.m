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
        case GTIOButtonTypeSignInButton: return [self gtio_signInButton];
        case GTIOButtonTypeNextButton: return [self gtio_nextButton];
        case GTIOButtonTypeFacebookSignInButton: return [self gtio_facebookSignInButton];
        case GTIOButtonTypeFacebookSignUpButton: return [self gtio_facebookSignUpButton];
        case GTIOButtonTypeAOLButton: return [self gtio_aolButton];
        case GTIOButtonTypeGoogleButton: return [self gtio_googleButton];
        case GTIOButtonTypeTwitterButton: return [self gtio_twitterButton];
        case GTIOButtonTypeYahooButton: return [self gtio_yahooButton];
        case GTIOButtonTypeReturningUserButton: return [self gtio_returningUserButton];
        default: return nil;
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

#pragma mark - Touch Handling

- (void)buttonWasTouchedUpInside:(id)sender
{
    if (self.tapHandler) {
        self.tapHandler(sender);
    }
}

@end
