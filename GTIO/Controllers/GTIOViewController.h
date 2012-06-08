//
//  GTIOViewController.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOViewController : UIViewController

-(id)initWithTitle:(NSString *)title italic:(BOOL)italic leftNavBarButton:(UIButton *)leftButton rightNavBarButton:(UIButton *)rightButton;
- (void)useTitleView:(UIView *)titleView;
- (void)useTitle:(NSString *)title;

@end
