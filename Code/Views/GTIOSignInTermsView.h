//
//  GTIOSignInTermsView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOSignInTermsView is a subview that displays a short stylized string stating the user is agreeing to the terms and conditions by continuing
#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface GTIOSignInTermsView : TTTAttributedLabel {}

/// Returns a correctly styled and isntantiated terms view
+ (id)termsView;

@end
