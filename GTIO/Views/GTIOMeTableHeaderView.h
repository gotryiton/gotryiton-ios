//
//  GTIOMeTableHeaderView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOMeViewController.h"

@interface GTIOMeTableHeaderView : UIView

@property (nonatomic, strong) NSArray *userInfoButtons;
@property (nonatomic, weak) id<GTIOMeTableHeaderViewDelegate> delegate;

- (void)refreshUserData;

@end
