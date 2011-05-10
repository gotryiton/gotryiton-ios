//
//  TTViewController+GTIOAdditions.m
//  GoTryItOn
//
//  Created by Blake Watters on 9/16/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "TTViewController+GTIOAdditions.h"

@implementation TTViewController (GTIOAdditions)

- (void)setConcreteBackgroundImage {
	UIImageView* bgImage = [[[UIImageView alloc] initWithImage:TTSTYLEVAR(modalBackgroundImage)] autorelease];
	bgImage.frame = CGRectOffset(TTScreenBounds(), 0, -20 - 44);
	[self.view insertSubview:bgImage atIndex:0];
}

@end
