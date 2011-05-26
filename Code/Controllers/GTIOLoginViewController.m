//
//  GTIOLoginViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOLoginViewController.h"
#import "GTIOBarButtonItem.h"
#import "GTIOSignInTermsView.h"
#import "GTIOTitleView.h"

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
	GTIOBarButtonItem* cancelButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"cancel" target:self action:@selector(dismiss)] autorelease];
	[[self navigationItem] setLeftBarButtonItem:cancelButton];
	
	UILabel* titleLabel = [[UILabel new] autorelease];
	[titleLabel setText:@"SIGN IN"];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setFrame:CGRectMake(0,0,85,30)];
	[titleLabel setFont:[UIFont fontWithName:@"Fette Engschrift" size:25]];
	[titleLabel setShadowOffset:CGSizeMake(0, -1)];
	[titleLabel setShadowColor:[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1.0]];
	self.navigationItem.titleView = [GTIOTitleView title:@"SIGN IN"];
	//[label setFrame:];
	UIView* termsView = [GTIOSignInTermsView termsView];
	[termsView setFrame:CGRectMake(20, self.view.frame.size.height-100, 280, 100)];
	[self.view addSubview:termsView];
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
