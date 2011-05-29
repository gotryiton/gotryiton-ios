//
//  GTIOTabBar.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOTabBar;

/// GTIOTabBarDelegate provides a protocol for delegates of the [GTIOTabBar](GTIOTabBar)
@protocol GTIOTabBarDelegate <NSObject>
/// Called when a new [GTIOTab](GTIOTab) is selected on the [GTIOTabBar](GTIOTabBar)
- (void)tabBar:(GTIOTabBar*)tabBar selectedTabAtIndex:(NSUInteger)index;

@end

/// ======================================================================================

/// GTIOTab is a single button element on a [GTIOTabBar](GTIOTabBar)
@interface GTIOTab : UIButton {
    UILabel* _badgeLabel;
    UIImageView* _badgeBackgroundImage;
}
/// badge number for tab
@property (nonatomic, retain) NSNumber* badge;
/// Sets the tab's position within the GTIOTabBar (-1 for left, 0 for center, 1 for right)
- (void)setRelativePosition:(NSInteger)pos;

@end

/// ======================================================================================
/// GTIOTabBar is a uiview that displays a view with multiple [GTIOTab](GTIOTab) elements

@interface GTIOTabBar : UIView {
    NSArray* _tabNames;
    NSMutableArray* _tabs; // Subviews
    NSUInteger _selectedTabIndex;
    id _delegate;
    NSString* _subtitle;
    UILabel* _subtitleLabel;
}
/// Array of the tab names
@property (nonatomic, retain) NSArray* tabNames;
/// Array of the child [GTIOTab](GTIOTab) objects
@property (nonatomic, readonly) NSArray* tabs;
/// Delegate that conforms to <[GTIOTabBarDelegate](GTIOTabBarDelegate)>
@property (nonatomic, assign) id<GTIOTabBarDelegate> delegate;
/// Index of the currently selected tab
@property (nonatomic, assign) NSUInteger selectedTabIndex;
/// Reference of the selected [GTIOTab](GTIOTab) object
@property (nonatomic, readonly) id selectedTab;
/// Subtitle string that is displayed below the tab bar, centered, in white
@property (nonatomic, retain) NSString* subtitle;

@end