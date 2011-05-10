//
//  GTIOMessageComposer.m
//  GoTryItOn
//
//  Created by Blake Watters on 10/8/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOMessageComposer.h"

@implementation GTIOMessageComposer

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (UIViewController*)emailComposerWithOutfitID:(NSString*)outfitID subject:(NSString*)subject body:(NSString*)body {
	if (NO == [MFMailComposeViewController canSendMail]) {
		[self showAlertWithTitle:@"whoops!" message:@"it looks like your device can't send e-mail. sorry!"];
		return nil;
	}
	
	MFMailComposeViewController* composeViewController = [[[MFMailComposeViewController alloc] init] autorelease];
	composeViewController.navigationBar.tintColor = [UIColor blackColor];
	composeViewController.mailComposeDelegate = self;
	[composeViewController setSubject:subject];
	NSString* unescapedBody = [body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[composeViewController setMessageBody:unescapedBody isHTML:NO];
	return composeViewController;
}

- (UIViewController*)textMessageComposerWithOutfitID:(NSString *)outfitID body:(NSString *)body {
	// Handle iOS < 4.0
	if (nil == NSClassFromString(@"MFMessageComposeViewController")) {
		[self showAlertWithTitle:@"whoops!" message:@"text messaging is only available on iOS 4 and higher. sorry!"];
		return nil;
	}
	
	if (NO == [MFMessageComposeViewController canSendText]) {
		[self showAlertWithTitle:@"whoops!" message:@"it looks like your device can't send texts. sorry!"];
		return nil;
	}
	
	MFMessageComposeViewController* composeViewController = [[[MFMessageComposeViewController alloc] init] autorelease];
	composeViewController.navigationBar.tintColor = [UIColor blackColor];
	composeViewController.messageComposeDelegate = self;
	NSString* unescapedBody = [body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[composeViewController setBody:unescapedBody];
	return composeViewController;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	if (MFMailComposeResultFailed == result) {		
		NSString* message = [NSString stringWithFormat:@"mail failed to send: %@", [error localizedDescription]];
		[self showAlertWithTitle:@"whoops!" message:message];
	} else {
        TTOpenURL(@"gtio://analytics/trackShareViaEmail");
    }
	
	[controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	if (MessageComposeResultFailed == result) {
		[self showAlertWithTitle:@"whoops!" message:@"text failed to send. sorry!"];
	} else {
        TTOpenURL(@"gtio://analytics/trackShareViaSMS");
    }
	
	[controller dismissModalViewControllerAnimated:YES];
}

@end
