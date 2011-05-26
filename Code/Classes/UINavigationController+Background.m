//
//  UINavigationController+Background.m
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "UINavigationController+Background.h"

@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect  
{
    UIImage *image = [UIImage imageNamed:@"navbar.png"];  
    NSLog(@"top view controller: %@",[TTNavigator globalNavigator].topViewController);
    if ([[[TTNavigator globalNavigator].topViewController class] isEqual:NSClassFromString(@"GTIOOutfitViewController")]) {
        image = [UIImage imageNamed:@"outfit-navbar.png"];
    }
	[image drawInRect:rect];
}

@end
