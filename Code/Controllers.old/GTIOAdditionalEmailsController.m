//
//  GTIOAdditionalEmailsController.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/15/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOAdditionalEmailsController.h"

@implementation GTIOAdditionalEmailsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(shareTitleImage)] autorelease];		
		self.navigationItem.leftBarButtonItem =
			[[[GTIOBarButtonItem alloc] initWithTitle: TTLocalizedString(@"cancel", @"")
											  style: UIBarButtonItemStylePlain												 
											 target: self										
											 action: @selector(cancel)] autorelease];
		self.navigationItem.rightBarButtonItem =
			[[[GTIOBarButtonItem alloc] initWithTitle: TTLocalizedString(@"done", @"")
											  style: UIBarButtonItemStylePlain
											 target: self
											 action: @selector(post)] autorelease];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	// Remove annoying auto-completion. Unnecessary for e-mail addresses
	self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
	self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.textView.keyboardType = UIKeyboardTypeEmailAddress;
	
	// Add the concrete background behind it
	UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44);
	[self.view insertSubview:bgImage atIndex:0];
	_innerView.backgroundColor = [UIColor clearColor];
	
	// Apply the custom style and inset the text editor
	_screenView.style = TTSTYLE(addAdditionalEmails);
	_textView.contentInset = UIEdgeInsetsMake(40, 4, 0, 4);
	_textView.keyboardAppearance = UIKeyboardAppearanceDefault;
	
	// Add an informational label and position nicely
	UILabel* label = [[[UILabel alloc] init] autorelease];
	label.font = [UIFont boldSystemFontOfSize:14];
	label.textColor = TTSTYLEVAR(greyTextColor);
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.text = @"enter email addresses separated by spaces.";
	[label sizeToFit];
	
	[_screenView addSubview:label];	
	label.frame = CGRectOffset(label.frame, 10, 10);
}

@end
