//
//  GTIOMeTitleView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIONavTitleTapHandler)();

@interface GTIONavigationNotificationTitleView : UIView

@property (nonatomic, copy) GTIONavTitleTapHandler tapHandler;

- (id)initWithTapHandler:(GTIONavTitleTapHandler)tapHandler;

@end
