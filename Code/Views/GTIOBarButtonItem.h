//
//  GTIOBarButtonItem.h
//  GTIO
//
//  Created by Daniel Hammond on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTIOBarButtonItem : 	UIBarButtonItem {}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action backButton:(BOOL)backButton;
+ (id)homeBackButton;


@end
