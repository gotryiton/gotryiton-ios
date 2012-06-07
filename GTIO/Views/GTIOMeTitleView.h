//
//  GTIOMeTitleView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOMeTitleView : UIView

- (id)initWithTapHandler:(GTIOButtonDidTapHandler)tapHandler notificationCount:(NSNumber *)notificationCount;

@end
