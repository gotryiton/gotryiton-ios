//
//  GTIOPhotoGuidelinesViewController.m
//  GoTryItOn
//
//  Created by Timothy Kerchmar on 11/29/10.
//  Copyright 2010 The Night School, LLC. All rights reserved.
//

#import "GTIOPhotoGuidelinesViewController.h"

@implementation GTIOPhotoGuidelinesViewController

- (void)loadView {
	[super loadView];
	
	TTOpenURL(@"gtio://analytics/trackUserDidViewPhotoGuidelines");
	
	self.navigationItem.hidesBackButton = YES;
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(photoGuidelinesHeaderImage)] autorelease];
	
	UIButton* backgroundImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backgroundImageButton setImage:TTSTYLEVAR(photoGuidelinesBackgroundImage) forState:UIControlStateNormal];
	[backgroundImageButton setImage:TTSTYLEVAR(photoGuidelinesBackgroundImage) forState:UIControlStateHighlighted];
	[backgroundImageButton addTarget:self action:@selector(okButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	backgroundImageButton.frame = CGRectOffset(TTScreenBounds(), 0, -56); // Status Bar + Navigation Bar
	[self.view addSubview:backgroundImageButton];
	
	UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[okButton setImage:TTSTYLEVAR(photoGuidelinesButtonImageNormal) forState:UIControlStateNormal];
	[okButton setImage:TTSTYLEVAR(photoGuidelinesButtonImageHighlighted) forState:UIControlStateHighlighted];
	[okButton sizeToFit];
	[okButton addTarget:self action:@selector(okButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	okButton.frame = CGRectMake(6, 311, 307, 50);
	[self.view addSubview:okButton];		
}

- (void)okButtonWasPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
	 
@end
