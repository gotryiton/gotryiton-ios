//
//  GTIOMessageComposer.h
//  GoTryItOn
//
//  Created by Blake Watters on 10/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface GTIOMessageComposer : NSObject <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {

}

- (UIViewController*)emailComposerWithOutfitID:(NSString*)outfitID subject:(NSString*)subject body:(NSString*)body;
- (UIViewController*)textMessageComposerWithOutfitID:(NSString *)outfitID body:(NSString *)body;

@end
