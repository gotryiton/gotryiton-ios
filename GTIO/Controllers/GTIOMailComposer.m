//
//  GTIOMailComposer.m
//  GTIO
//
//  Created by Scott Penrose on 5/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMailComposer.h"

@implementation GTIOMailComposer

@synthesize mailComposeViewController = _mailComposeViewController;
@synthesize didFinishHandler = _didFinishHandler;

- (id)init
{
    self = [super init];
    if (self) {
        if ([MFMailComposeViewController canSendMail]) {
            _mailComposeViewController = [[MFMailComposeViewController alloc] init];
            [_mailComposeViewController setMailComposeDelegate:self];
        } else {
            return nil;
        }
    }
    return self;
}

- (id)initWithSubject:(NSString *)subject recipients:(NSArray *)toRecipients didFinishHandler:(GTIOMailComposerDidFinishHandler)didFinishHandler
{
    self = [self init];
    if (self) {
        [_mailComposeViewController setSubject:subject];
        [_mailComposeViewController setToRecipients:toRecipients];
        
        self.didFinishHandler = didFinishHandler;
    }
    return self;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    if (self.didFinishHandler) {
        self.didFinishHandler(controller, result, error);
    }
}

@end
