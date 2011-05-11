//
//  GTIOAppStatusAlert.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOAppStatusAlert.h"
#import "GTIOAppStatusAlertButton.h"

@implementation GTIOAppStatusAlert

@synthesize alertID = _alertID;
@synthesize title = _title;
@synthesize message = _message;
@synthesize cancelButtonTitle = _cancelButtonTitle;
@synthesize buttons = _buttons;

- (void)dealloc {
	[_title release];
	_title = nil;
	[_message release];
	_message = nil;
	[_cancelButtonTitle release];
	_cancelButtonTitle = nil;
	[_buttons release];
	_buttons = nil;

	[_alertID release];
	_alertID = nil;

	[super dealloc];
}

+ (int)lastDisplayedAlert {
	return [[[NSUserDefaults standardUserDefaults] valueForKey:@"LastDisplayedAlert"] intValue];
}

+ (void)setLastDisplayedAlert:(int)value {
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:value] forKey:@"LastDisplayedAlert"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)show {
	if (_alertID && [_alertID intValue] <= [GTIOAppStatusAlert lastDisplayedAlert]) {
		return;
	}
	[self retain];
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:_title
														message:_message
													   delegate:self
											  cancelButtonTitle:_cancelButtonTitle
											  otherButtonTitles:nil];
	for (GTIOAppStatusAlertButton* button in _buttons) {
		[alertView addButtonWithTitle:button.title];
	}
	[alertView show];
	[alertView release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (_alertID) {
		[GTIOAppStatusAlert setLastDisplayedAlert:[_alertID intValue]];
	}
	if (buttonIndex == 0) {
		// cancel
		return;
	}
	GTIOAppStatusAlertButton* button = [_buttons objectAtIndex:buttonIndex - 1];
	NSLog(@"Opening URL: %@", button.url);
	TTOpenURL(button.url);
	[self release];
}

@end
