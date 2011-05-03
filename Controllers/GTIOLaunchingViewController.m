//
//  GTIOLaunchingViewController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/31/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOLaunchingViewController.h"

@implementation GTIOLaunchingViewController

- (void)loadView {
	[super loadView];
	
	[self.navigationController setNavigationBarHidden:YES];
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]] autorelease];
	imageView.frame = CGRectOffset(TTScreenBounds(), 0, -20);
	[self.view addSubview:imageView];
}

@end
