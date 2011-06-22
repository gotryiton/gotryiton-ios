//
//  UINavigationBar+Background.m
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// UINavigationController+Background overides the drawrect for the UINavigationBar to include a custom background image

@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect  
{   
    NSLog(@"title: %@", self.topItem.title);
    UIImage *image = [UIImage imageNamed:@"navbar.png"];  
    TTBaseNavigator* navigator = [TTNavigator globalNavigator];
    NSLog(@"top view controller: %@",[(TTNavigationController*)navigator.rootViewController viewControllers]);
    if ([[[(TTNavigationController*)navigator.rootViewController viewControllers] lastObject] isKindOfClass:NSClassFromString(@"GTIOOutfitViewController")]) {
        image = [UIImage imageNamed:@"outfit-navbar.png"];
    }
	[image drawInRect:rect];
}

@end
