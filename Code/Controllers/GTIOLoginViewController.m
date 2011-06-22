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
#import "GTIOHeaderView.h"

@implementation GTIOLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStartedNotification:) name:kGTIOUserDidBeginLoginProcess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStopped:) name:kGTIOUserDidEndLoginProcess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedInNotification:) name:kGTIOUserDidLoginNotificationName object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loginStartedNotification:(NSNotification*)note {
    if (nil == [self.view viewWithTag:999]) {
        TTActivityLabel* activityLabel = [[TTActivityLabel alloc] initWithFrame:self.view.bounds style:TTActivityLabelStyleBlackBox text:NSLocalizedString(@"logging in...", @"Logging in loading text")];
        activityLabel.tag = 999;
        [self.view addSubview:activityLabel];
        [activityLabel release];
    }
}

- (IBAction)facebookButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://loginWithFacebook");
}

- (IBAction)otherProvidersButtonWasPressed:(id)sender {
    TTOpenURL(@"gtio://loginWithJanRain");
}

- (void)popViewController {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    [self popViewController];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)loginStopped:(NSNotification*)note {
    [[self.view viewWithTag:999] removeFromSuperview];
}

- (void)loggedInNotification:(NSNotification*)note {
    [self dismiss];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem homeBackBarButtonWithTarget:self action:@selector(popViewController)];    
    
    self.navigationItem.titleView = [GTIOHeaderView viewWithText:@"SIGN IN"];
    
	UIView* termsView = [GTIOSignInTermsView termsView];
	[termsView setFrame:CGRectMake(20, self.view.frame.size.height-50, 280, 100)];
	[self.view addSubview:termsView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
