//
//  GTIOPhotoGuidelinesViewController.m
//  GoTryItOn
//
//  Created by Timothy Kerchmar on 11/29/10.
//  Copyright 2010 The Night School, LLC. All rights reserved.
//

#import "GTIOPhotoGuidelinesViewController.h"
#import "GTIOHeaderView.h"

@implementation GTIOPhotoGuidelinesViewController

- (void)loadView {
	[super loadView];
    
	GTIOAnalyticsEvent(kUserDidViewPhotoGuidelinesEventName);
	
	self.navigationItem.hidesBackButton = YES;
	
	self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"PHOTO GUIDELINES"];
	
	UIButton* backgroundImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backgroundImageButton setImage:TTSTYLEVAR(photoGuidelinesBackgroundImage) forState:UIControlStateNormal];
	[backgroundImageButton setImage:TTSTYLEVAR(photoGuidelinesBackgroundImage) forState:UIControlStateHighlighted];
	[backgroundImageButton addTarget:self action:@selector(okButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	backgroundImageButton.frame = self.view.bounds;
	[self.view addSubview:backgroundImageButton];
	
	UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[okButton setImage:TTSTYLEVAR(photoGuidelinesButtonImageNormal) forState:UIControlStateNormal];
	[okButton setImage:TTSTYLEVAR(photoGuidelinesButtonImageHighlighted) forState:UIControlStateHighlighted];
	[okButton sizeToFit];
	[okButton addTarget:self action:@selector(okButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	okButton.frame = CGRectMake(8, self.view.bounds.size.height - 48 - 6, 304, 48);
	[self.view addSubview:okButton];		
}

- (void)okButtonWasPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
	 
@end
