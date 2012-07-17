//
//  GTIOViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIONavigationTitleView.h"

@interface GTIOViewController : UIViewController

@property (nonatomic, strong) UIButton *leftNavigationButton;
@property (nonatomic, strong) UIButton *rightNavigationButton;

- (void)useTitleView:(UIView *)titleView;
- (void)showStatusBarBackgroundWithoutNavigationBar;

@end
