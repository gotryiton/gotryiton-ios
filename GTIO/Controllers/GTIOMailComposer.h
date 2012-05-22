//
//  GTIOMailComposer.h
//  GTIO
//
//  Created by Scott Penrose on 5/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <MessageUI/MessageUI.h>

typedef void(^GTIOMailComposerDidFinishHandler)(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error);

@interface GTIOMailComposer : NSObject <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;
@property (nonatomic, copy) GTIOMailComposerDidFinishHandler didFinishHandler;

/** Create a Mail Compose view to be presented. This will return nil if device can not
    send mail.
 */
- (id)initWithSubject:(NSString *)subject recipients:(NSArray *)toRecipients didFinishHandler:(GTIOMailComposerDidFinishHandler)didFinishHandler;

@end
