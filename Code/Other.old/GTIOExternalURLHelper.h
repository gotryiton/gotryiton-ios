//
//  GTIOExternalURLHelper.h
//  GoTryItOn
//
//  Created by Blake Watters on 10/4/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOExternalURLHelper : NSObject {
	NSString* _URLString;
}

/**
 * Ensure the user is logged in and then show the specified
 * outfit on the Profile tab
 */
- (void)requireLoginAndShowOutfitOnProfileTab:(NSString*)outfitID;

/**
 * Shows an outfit on the Profile tab
 */
- (void)showOutfitOnProfileTab:(NSString*)outfitID;

/**
 * Ensures that the user is logged in and then loads the
 * specified outfit on to the Give an Opinion tab
 */
- (void)requireLoginAndShowOutfitOnGiveAnOpinionTab:(NSString*)outfitID;

/**
 * Loads the specified outfit on to the Give an Opinion tab
 */
- (void)showOutfitOnGiveAnOpinionTab:(NSString*)outfitID;

@end
