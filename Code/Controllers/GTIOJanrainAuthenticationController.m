//
//  GTIOJanrainAuthenticationController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOJanrainAuthenticationController.h"
#import "GTIOUser.h"
#import "GTIOTitleView.h"
#import "JREngage+CustomInterface.h"
#import "GTIOSignInTermsView.h"
@implementation GTIOJanrainAuthenticationController

+(void)showAuthenticationDialog {
	TTOpenURL(@"gtio://analytics/trackUserDidViewLogin");	
	NSString* authURL = [NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/auth/")];
	NSURL* url = [NSURL URLWithString:authURL];
	
	JREngage* engage = [JREngage jrEngageWithAppId:kGTIOJanRainEngageApplicationID
																		 andTokenUrl:[url absoluteString]
																				delegate:[GTIOUser currentUser]];
	GTIOTitleView* titleView = [GTIOTitleView title:@"SIGN IN"];
	UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]];
	UILabel* header = [[UILabel new] autorelease];
	[header setFrame:CGRectMake(0,0,320,40)];
	[header setTextAlignment:UITextAlignmentCenter];
	[header setText:@"returning? use your existing account."];
    [header setBackgroundColor:[UIColor clearColor]];
	[header setFont:[UIFont boldSystemFontOfSize:12]];
	[header setTextColor:[UIColor colorWithRed:0.506 green:0.506 blue:0.506 alpha:1]];
	
	UIView* terms = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
	[terms setBackgroundColor:[UIColor clearColor]];
	[terms addSubview:[GTIOSignInTermsView termsView]];
	
	NSArray* objects = [NSArray arrayWithObjects:backgroundImage,titleView,header,[UIColor clearColor],terms,nil]; 
	NSArray* keys = [NSArray arrayWithObjects:kJRAuthenticationBackgroundImageView,kJRProviderTableTitleView,kJRProviderTableHeaderView,kJRAuthenticationBackgroundColor,kJRProviderTableSectionFooterView,nil];
	NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[engage showAuthenticationDialogWithCustomInterface:params];	
}

@end
