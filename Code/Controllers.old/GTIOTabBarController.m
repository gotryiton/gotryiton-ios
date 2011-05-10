//
//  GTIOTabBarController.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTabBarController.h"

@implementation GTIOTabBarController

- (id)init {
	if (self = [super init]) {
		[self setTabURLs:[NSArray arrayWithObjects:
						  @"gtio://getAnOpinion",
						  @"gtio://giveAnOpinion",
						  @"gtio://profile",
						  @"gtio://settings",
						  nil]];
	}
	
	return self;
}

@end
