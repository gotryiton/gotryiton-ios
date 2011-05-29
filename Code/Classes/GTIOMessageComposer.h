//
//  GTIOMessageComposer.h
//  GoTryItOn
//
//  Created by Blake Watters on 10/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOMessageComposer is a helper that generates a viewcontroller to share an outfit via either a SMS or email 

#import <MessageUI/MessageUI.h>

@interface GTIOMessageComposer : NSObject <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {}

/// Generates a view controller to share an outfit via email
- (UIViewController*)emailComposerWithOutfitID:(NSString*)outfitID subject:(NSString*)subject body:(NSString*)body;

/// Generates a view controller to share an outfit via sms
- (UIViewController*)textMessageComposerWithOutfitID:(NSString *)outfitID body:(NSString *)body;

@end
