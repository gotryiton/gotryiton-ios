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

static int const kOverlayViewTag = 9999;

@implementation GTIOGetAnOpinionViewController

- (id)init {
	if (self = [super init]) {
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"get an opinion" 
														 image:TTSTYLEVAR(getAnOpinionTabBarImage) 
														   tag:0] autorelease];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(getAnOpinionOverlayTitleImage)] autorelease];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"cancel" 
																			  style:UIBarButtonItemStyleBordered 
																			 target:nil 
																			 action:nil] autorelease];
	
	UIButton* backgroundImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backgroundImageButton setImage:TTSTYLEVAR(stepsBackgroundImage) forState:UIControlStateNormal];
	[backgroundImageButton setImage:TTSTYLEVAR(stepsBackgroundImage) forState:UIControlStateHighlighted];
	[backgroundImageButton addTarget:self action:@selector(getStartedButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	backgroundImageButton.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44); // Status Bar + Navigation Bar
	[self.view addSubview:backgroundImageButton];
	
	UIButton* getStartedButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[getStartedButton setImage:TTSTYLEVAR(getStartedButtonImageNormal) forState:UIControlStateNormal];
	[getStartedButton setImage:TTSTYLEVAR(getStartedButtonImageHighlighted) forState:UIControlStateHighlighted];
	[getStartedButton sizeToFit];
	[getStartedButton addTarget:self action:@selector(getStartedButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	getStartedButton.frame = CGRectMake(10, 310, 300, 50);
	[self.view addSubview:getStartedButton];		
}

- (void)getStartedButtonWasPressed:(id)sender {
	TTOpenURL(@"gtio://getAnOpinion/start");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:[GTIOBarButtonItem homeBackBarButtonWithTarget:self action:@selector(backButtonAction)]];
	if ([[GTIOOpinionRequestSession globalSession].opinionRequest.photos count] > 0) {
		if ([self.view viewWithTag:kOverlayViewTag] == nil) {
			UIImageView* overlayView = [[UIImageView alloc] initWithImage:TTSTYLEVAR(getAnOpinionOverlayImage)];
			overlayView.frame = self.view.frame;
			overlayView.tag = kOverlayViewTag;
			[self.view addSubview:overlayView];			
			[overlayView release];
		}
	} else {
		[[self.view viewWithTag:kOverlayViewTag] removeFromSuperview];
	}
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
