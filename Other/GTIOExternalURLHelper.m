//
//  GTIOExternalURLHelper.m
//  GoTryItOn
//
//  Created by Blake Watters on 10/4/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOExternalURLHelper.h"
#import "GTIOUser.h"

@implementation GTIOExternalURLHelper

- (id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(loadURLOnLogin) 
													 name:kGTIOUserDidLoginNotificationName
												   object:nil];
	}
	
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_URLString release];
	[super dealloc];
}

- (void)loadOutfitID:(NSString*)outfitID toTab:(NSString*)tabName requireLogin:(BOOL)requireLogin {
	NSString* URLString = nil;
	if (outfitID) {
		URLString = [NSString stringWithFormat:@"gtio://%@/%@", tabName, outfitID];
	}
	
	// Ensure our target tab is available..
	[[TTNavigator globalNavigator] openURLAction:
	 [TTURLAction actionWithURLPath:[NSString stringWithFormat:@"gtio://%@", tabName]]];
	
	if ((requireLogin == NO || [GTIOUser currentUser].isLoggedIn) && URLString) {
		[[TTNavigator globalNavigator] openURLAction:
		 [TTURLAction actionWithURLPath:URLString]];
	} else {
		_URLString = URLString;
		[_URLString retain];
		
		[[TTNavigator globalNavigator] openURLAction:
		 [TTURLAction actionWithURLPath:@"gtio://login"]];
	}
}

- (void)requireLoginAndShowOutfitOnProfileTab:(NSString*)outfitID {
	[self loadOutfitID:outfitID toTab:@"profile" requireLogin:YES];
}

- (void)showOutfitOnProfileTab:(NSString*)outfitID {
	[self loadOutfitID:outfitID toTab:@"profile" requireLogin:NO];
}

- (void)requireLoginAndShowOutfitOnGiveAnOpinionTab:(NSString*)outfitID {
	[self loadOutfitID:outfitID toTab:@"giveAnOpinion" requireLogin:YES];
}

- (void)showOutfitOnGiveAnOpinionTab:(NSString*)outfitID {
	[self loadOutfitID:outfitID toTab:@"giveAnOpinion" requireLogin:NO];
}

- (void)loadURLOnLogin {
	if (_URLString) {
		TTURLAction* URLAction = [TTURLAction actionWithURLPath:_URLString];		
		[[TTNavigator globalNavigator] performSelector:@selector(openURLAction:) withObject:URLAction afterDelay:2.0];
		
		[_URLString release];
		_URLString = nil;
	}
}

@end
