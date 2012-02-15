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

- (void)dealloc {
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
	
    if (URLString) {
        if (NO == requireLogin) {
            [[TTNavigator globalNavigator] openURLAction:
             [TTURLAction actionWithURLPath:URLString]];
        } else {
            [[GTIOUser currentUser] ensureLoggedInAndExecute:^{
                [[TTNavigator globalNavigator] openURLAction:
                 [TTURLAction actionWithURLPath:URLString]];
            }];
        }
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
