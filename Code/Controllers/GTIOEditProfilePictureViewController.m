//
//  GTIOEditProfilePictureViewController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOEditProfilePictureViewController.h"
#import "GTIOBarButtonItem.h"
#import "GTIOUser.h"

@implementation GTIOEditProfilePictureViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
														[[GTIOUser currentUser] token], @"gtioToken",
														nil];
    params = [GTIOUser paramsByAddingCurrentUserIdentifier:params];
		[[RKObjectManager sharedManager] loadObjectsAtResourcePath:GTIORestResourcePath(@"/user-icons") queryParams:params delegate:self];
	}
	return self;
}

- (void)loadView {
	[super loadView];
	UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]];
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	UIImageView* topContainer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"container.png"]];
	
	UIImageView* bottomContainer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"container.png"]];
	[self.view addSubview:topContainer];
	[topContainer release];
	[bottomContainer release];
	302 * 206;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	GTIOBarButtonItem* cancelButton = [[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(cancelButtonWasPressed:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)cancelButtonWasPressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary {
	NSLog(@"dictionary: %@", dictionary);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	NSLog(@"Error:%@",[error localizedDescription]);
}

@end
