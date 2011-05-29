//
//  GTIOTitleView.h
//  GTIO
//
//  Created by Daniel Hammond on 5/11/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOTitleView is a subclass of uillabel that is properly styled for the titleview of any view in the GTIO app

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTIOTitleView : UILabel {}

/// Returns a GTIOTitleView item with correct styling
+ (GTIOTitleView*)title:(NSString*)title;

@end
