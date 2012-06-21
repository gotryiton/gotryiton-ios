//
//  GTIOFollowRequestAcceptBarView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOFollowRequestAcceptBar.h"

@protocol GTIOFollowRequestAcceptBarViewDelegate <NSObject>

@optional
- (void)removeAcceptBar;
- (void)acceptBarRemoved;

@end

@interface GTIOFollowRequestAcceptBarView : UIView

@property (nonatomic, strong) GTIOFollowRequestAcceptBar *followRequestAcceptBar;
@property (nonatomic, assign) id<GTIOFollowRequestAcceptBarViewDelegate> delegate;

@end
