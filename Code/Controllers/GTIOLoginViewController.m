//
//  GTIOLoginViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOLoginViewController.h"
#import "GTIOBarButtonItem.h"

@implementation GTIOLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStartedNotification:) name:kGTIOUserDidBeginLoginProcess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEndedNotification:) name:kGTIOUserDidEndLoginProcess object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loginStartedNotification:(NSNotification*)note {
    if (nil == [self.view viewWithTag:999]) {
        TTActivityLabel* activityLabel = [[TTActivityLabel alloc] initWithFrame:self.view.bounds style:TTActivityLabelStyleBlackBox text:NSLocalizedString(@"Logging In...", @"Logging in loading text")];
        activityLabel.tag = 999;
        [self.view addSubview:activityLabel];
        [activityLabel release];
    }
}

- (void)loginEndedNotification:(NSNotification*)note {
    [[self.view viewWithTag:999] removeFromSuperview];
}

- (IBAction)facebookButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://loginWithFacebook");
}

- (IBAction)otherProvidersButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://loginWithJanRain");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(dismiss)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"Title View" target:self action:@selector(dismiss) backButton:YES] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
