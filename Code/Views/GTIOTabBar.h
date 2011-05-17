//
//  GTIOTabBar.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/17/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOTabBar;

@protocol GTIOTabBarDelegate <NSObject>

- (void)tabBar:(GTIOTabBar*)tabBar selectedTabAtIndex:(NSUInteger)index;

@end

@interface GTIOTabBar : UIView {
    NSArray* _tabNames;
    NSMutableArray* _tabs; // Subviews
    NSUInteger _selectedTabIndex;
    id _delegate;
}

@property (nonatomic, retain) NSArray* tabNames;
@property (nonatomic, assign) id<GTIOTabBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedTabIndex;

@end
