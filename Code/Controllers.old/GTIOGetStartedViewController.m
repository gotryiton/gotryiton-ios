//
//  GTIOGetStartedViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOGetStartedViewController.h"


// DEFUNKT. Pending Delete.
@implementation GTIOGetStartedViewController

- (void)loadView {
	[super loadView];
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(getStartedBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20);
	[self.view insertSubview:bgImage atIndex:0];
	
	UIButton* getAnOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	// TODO: Use stylesheet...
	[getAnOpinionButton setImage:[UIImage imageNamed:@"getstarted_get.png"] forState:UIControlStateNormal];
	[getAnOpinionButton setImage:[UIImage imageNamed:@"getstarted_get_active.png"] forState:UIControlStateHighlighted];
	[getAnOpinionButton sizeToFit];
	getAnOpinionButton.backgroundColor = [UIColor clearColor];
	getAnOpinionButton.frame = CGRectMake(10, 340, 300, 54);
	[getAnOpinionButton addTarget:self action:@selector(getButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:getAnOpinionButton];
	
	UIButton* giveAnOpinionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[giveAnOpinionButton setImage:[UIImage imageNamed:@"getstarted_give.png"] forState:UIControlStateNormal];
	[giveAnOpinionButton setImage:[UIImage imageNamed:@"getstarted_give_active.png"] forState:UIControlStateHighlighted];
	[giveAnOpinionButton sizeToFit];
	giveAnOpinionButton.backgroundColor = [UIColor clearColor];
	giveAnOpinionButton.frame = CGRectOffset(getAnOpinionButton.frame, 0, 54);
	[giveAnOpinionButton addTarget:self action:@selector(giveButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:giveAnOpinionButton];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	TTOpenURL(@"gtio://analytics/trackUserDidViewHomepage");
}

- (void)getButtonWasPressed:(id)sender {
	TTOpenURL(@"gtio://analytics/trackUserDidTouchGetAnOpinionFromHomepage");
	
	UITabBarController* controller = (UITabBarController*) TTOpenURL(@"gtio://tabbar");
	[controller setSelectedIndex:0];
}

- (void)giveButtonWasPressed:(id)sender {
	TTOpenURL(@"gtio://analytics/trackUserDidTouchGiveAnOpinionFromHomepage");
	
	UITabBarController* controller = (UITabBarController*) TTOpenURL(@"gtio://tabbar");
	[controller setSelectedIndex:1];	
}

@end
