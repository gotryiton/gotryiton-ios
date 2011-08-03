//
//  GTIOBarButtonItem.h
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOBarButtonItem is a subclass of [UIBarButtonItem](UIBarButtonItem) that uses the correct GTIO specific styling

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTIOBarButtonItem : 	UIBarButtonItem {}

/// returns button with the special styling for back buttons that return to the [GTIOHomeViewController](GTIOHomeViewController).
/// This must be seperate from the initWithImage:target:action: method because the spacing is not correct with the home image
+ (id)homeBackBarButtonWithTarget:(id)target action:(SEL)action;
+ (id)listBackBarButtonWithTarget:(id)target action:(SEL)action;

/// returns correctly styled backbutton based on the top view in the [TTNavigator](TTNavigator)
+ (id)backButton;

+ (id)myStylistsButtonWithTarget:(id)target action:(SEL)action;

///class level helper that pops the [TTNavigator](TTNavigator) top view controller
+ (void)backButtonAction;

/// init normal button (not a back button arrow) with GTIO styling and given title, target, and action
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/// init button with GTIO styling and given title, target, action, and boolean flag as to whether or not it is a back button
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action backButton:(BOOL)backButton;

/// init button with GTIO styling and given image, target, and action
- (id)initWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end
