//
//  UINavigationBar+Background.m
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// UINavigationController+Background overides the drawrect for the UINavigationBar to include a custom background image

#import "SupersequentImplementation.h"

@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect  
{   
    NSLog(@"title: %@", self.topItem.title);
    UIImage *image = [UIImage imageNamed:@"navbar.png"];  
    TTBaseNavigator* navigator = [TTNavigator globalNavigator];
    TTNavigationController* navigationController = (TTNavigationController*)navigator.rootViewController;
    NSLog(@"top view controller: %@", [navigationController viewControllers]);
    UIViewController* viewController = [[navigationController viewControllers] lastObject];
    NSLog(@"Visible: %@", navigationController.visibleViewController);
    NSLog(@"Modal View Controller: %@", viewController.modalViewController);
    while (viewController.modalViewController && ![viewController isKindOfClass:NSClassFromString(@"GTIOOutfitViewController")]) {
        viewController = viewController.modalViewController;
    }
    if ([viewController  isKindOfClass:NSClassFromString(@"UIImagePickerController")]) {
        invokeSupersequent(rect);
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"GTIOOutfitViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"GTIOHomeViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"GTIOSuggestViewController")]) {
        image = [UIImage imageNamed:@"outfit-navbar.png"];
    }
	[image drawInRect:rect];
}

@end
