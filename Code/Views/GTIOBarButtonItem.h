//
//  GTIOBarButtonItem.h
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTIOBarButtonItem : 	UIBarButtonItem {}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action backButton:(BOOL)backButton;
- (id)initWithImage:(UIImage*)image target:(id)target action:(SEL)action;
+ (id)homeBackBarButtonWithTarget:(id)target action:(SEL)action;
+ (id)backButton;
+ (void)backButtonAction;

@end
