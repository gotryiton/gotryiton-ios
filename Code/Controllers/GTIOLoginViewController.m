//
//  GTIOLoginViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOLoginViewController.h"
#import "GTIOBarButtonItem.h"
#import "TTTAttributedLabel.h"

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
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign-in.png"]] autorelease];
	
	//TODO: Clean up all the attribute setting with some abstractions and move it elsewhere
	NSString* text = @"by continuing you agree to our terms and conditions of use, privacy policy, legal terms, and community standards.";
	NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:text];

	id normal = (id)[UIColor colorWithRed:.243 green:.243 blue:.243 alpha:1].CGColor;
	id highlight = (id)[UIColor colorWithRed:1 green:0 blue:.588 alpha:1].CGColor;

	NSString* underlineAttributeName = (NSString*)kCTUnderlineStyleAttributeName;
	NSString* colorAttributeName = (NSString*)kCTForegroundColorAttributeName;

	[attributedText addAttribute:colorAttributeName value:normal range:NSMakeRange(0, attributedText.length)];
	[attributedText addAttribute:colorAttributeName value:highlight range:NSMakeRange(31, 20)];
	[attributedText addAttribute:underlineAttributeName value:[NSNumber numberWithBool:YES] range:NSMakeRange(31, 20)];		
	[attributedText addAttribute:colorAttributeName value:highlight range:NSMakeRange(60, 14)];
	[attributedText addAttribute:underlineAttributeName value:[NSNumber numberWithBool:YES] range:NSMakeRange(60, 14)];		
	[attributedText addAttribute:colorAttributeName value:highlight range:NSMakeRange(76, 11)];
	[attributedText addAttribute:underlineAttributeName value:[NSNumber numberWithBool:YES] range:NSMakeRange(76, 11)];		
	[attributedText addAttribute:colorAttributeName value:highlight range:NSMakeRange(93, 19)];
	[attributedText addAttribute:underlineAttributeName value:[NSNumber numberWithBool:YES] range:NSMakeRange(93, 19)];

	NSString* fontFamily = [UIFont systemFontOfSize:12].familyName;
	CGFloat size = 10;
	BOOL isBold = YES;
	BOOL isItalic = NO;
	NSRange range = NSMakeRange(0, attributedText.length);
	
	CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
	NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
	NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
												fontFamily,kCTFontFamilyNameAttribute,
												trait,kCTFontTraitsAttribute,nil];
	
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attr);
	if (!desc) return;
	CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
	if (!aFont) return;
	[attributedText addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
	CFRelease(desc);
	
	TTTAttributedLabel* label = [TTTAttributedLabel new];
	[label setFrame:CGRectMake(20, self.view.frame.size.height-100, 280, 100)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setNumberOfLines:2];
	[label setText:attributedText];
	[self.view addSubview:label];
	[label release];
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
