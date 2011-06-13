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
    UIImage *image = [UIImage imageNamed:@"navbar.png"];  
    NSLog(@"top view controller: %@",[TTNavigator globalNavigator].topViewController);
    if ([[[TTNavigator globalNavigator].topViewController class] isEqual:NSClassFromString(@"GTIOOutfitViewController")] ||
        // sometimes we push the outfit view controller behind the welcome view.
        [[[TTNavigator globalNavigator].topViewController class] isEqual:NSClassFromString(@"GTIOWelcomeViewController")]) {
        image = [UIImage imageNamed:@"outfit-navbar.png"];
    }
	[image drawInRect:rect];
}

@end
