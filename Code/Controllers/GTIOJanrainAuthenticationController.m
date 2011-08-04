//
//  GTIOJanrainAuthenticationController.m
//  GTIO
//
//  Created by Daniel Hammond on 5/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "GTIOJanrainAuthenticationController.h"
#import "GTIOUser.h"
#import "GTIOHeaderView.h"
#import "JREngage+CustomInterface.h"
#import "GTIOSignInTermsView.h"
@implementation GTIOJanrainAuthenticationController

+(void)showAuthenticationDialog {
    GTIOAnalyticsEvent(kUserDidViewLoginEventName);
	NSString* authURL = [NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, GTIORestResourcePath(@"/auth/")];
	NSURL* url = [NSURL URLWithString:authURL];
	
	JREngage* engage = [JREngage jrEngageWithAppId:kGTIOJanRainEngageApplicationID
																		 andTokenUrl:[url absoluteString]
																				delegate:[GTIOUser currentUser]];
	GTIOHeaderView* titleView = [GTIOHeaderView viewWithText:@"SIGN IN"];
	UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"full-wallpaper.png"]];
    UIView* header = [[UIView new] autorelease];
	[header setFrame:CGRectMake(0,0,320,40)];
    
    UILabel* headerLabel = [[UILabel new] autorelease];
	[headerLabel setTextAlignment:UITextAlignmentCenter];
	[headerLabel setText:@"returning? use your existing account."];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
	[headerLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[headerLabel setTextColor:[UIColor colorWithRed:0.506 green:0.506 blue:0.506 alpha:1]];
	headerLabel.frame = CGRectMake(0,10,320,30);
    [header addSubview:headerLabel];
	
	NSArray* objects = [NSArray arrayWithObjects:backgroundImage,titleView,header,[UIColor clearColor],nil]; 
	NSArray* keys = [NSArray arrayWithObjects:kJRAuthenticationBackgroundImageView,kJRProviderTableTitleView,kJRProviderTableHeaderView,kJRAuthenticationBackgroundColor,nil];
	NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	[engage showAuthenticationDialogWithCustomInterface:params];	
}

@end
