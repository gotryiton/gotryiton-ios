//
//  GTIOAppDelegate.h
//  GTIO
//
//  Created by Scott Penrose on 5/1/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

/** This is called when you are ready to display the tab bar.
 */
- (void)addTabBarToWindow;
- (void)selectTabAtIndex:(NSUInteger)index;

@end
