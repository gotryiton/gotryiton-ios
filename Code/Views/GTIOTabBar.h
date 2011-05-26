//
//  GTIOTabBar.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
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
    NSString* _subtitle;
    UILabel* _subtitleLabel;
}

@property (nonatomic, retain) NSArray* tabNames;
@property (nonatomic, readonly) NSArray* tabs;
@property (nonatomic, assign) id<GTIOTabBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedTabIndex;
@property (nonatomic, readonly) id selectedTab;
@property (nonatomic, retain) NSString* subtitle; // Shows up under the tab bar. centered. white.

@end


@interface GTIOTab : UIButton {
    UILabel* _badgeLabel;
    UIImageView* _badgeBackgroundImage;
}

@property (nonatomic, retain) NSNumber* badge;

- (void)setRelativePosition:(NSInteger)pos; // -1 for left, 0 for center, 1 for right;

@end