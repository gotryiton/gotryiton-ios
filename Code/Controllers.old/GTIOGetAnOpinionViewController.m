//
//  GTIOGetAnOpinionViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOGetAnOpinionViewController.h"
#import "GTIOUser.h"
#import "GTIOOpinionRequestSession.h"
#import "GTIOBarButtonItem.h"
#import "GTIOHeaderView.h"

static int const kOverlayViewTag = 9999;

@implementation GTIOGetAnOpinionViewController

- (void)setupTitleView {
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"UPLOAD"];
}

- (void)loadView {
	[super loadView];

	[self setupTitleView];
	self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel"
																			 target:nil 
																			 action:nil] autorelease];
	
	UIButton* backgroundImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backgroundImageButton setImage:TTSTYLEVAR(stepsBackgroundImage) forState:UIControlStateNormal];
	[backgroundImageButton setImage:TTSTYLEVAR(stepsBackgroundImage) forState:UIControlStateHighlighted];
	[backgroundImageButton addTarget:self action:@selector(getStartedButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	backgroundImageButton.frame = self.view.bounds;
	[self.view addSubview:backgroundImageButton];
	
	UIButton* getStartedButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[getStartedButton setImage:TTSTYLEVAR(getStartedButtonImageNormal) forState:UIControlStateNormal];
	[getStartedButton setImage:TTSTYLEVAR(getStartedButtonImageHighlighted) forState:UIControlStateHighlighted];
	[getStartedButton sizeToFit];
	[getStartedButton addTarget:self action:@selector(getStartedButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	getStartedButton.frame = CGRectMake(8, 361, 304, 48);
	[self.view addSubview:getStartedButton];		
}

- (void)getStartedButtonWasPressed:(id)sender {
	TTOpenURL(@"gtio://getAnOpinion/start");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([[GTIOOpinionRequestSession globalSession].opinionRequest.photos count] > 0) {
		if ([self.view viewWithTag:kOverlayViewTag] == nil) {
			UIImageView* overlayView = [[UIImageView alloc] initWithImage:TTSTYLEVAR(getAnOpinionOverlayImage)];
			overlayView.frame = self.view.frame;
			overlayView.tag = kOverlayViewTag;
			[self.view addSubview:overlayView];			
			[overlayView release];
            self.navigationItem.titleView = nil;
		}
	} else {
        [self setupTitleView];
		[[self.view viewWithTag:kOverlayViewTag] removeFromSuperview];
	}
}

@end
