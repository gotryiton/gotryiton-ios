//
//  GTIOPullToRefreshContentView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefresh.h"

@interface GTIOPullToRefreshContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, assign) UIEdgeInsets scrollInsets;
@property (nonatomic, strong) UIImageView *background;

@end
