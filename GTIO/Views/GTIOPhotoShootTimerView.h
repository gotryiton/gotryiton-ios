//
//  GTIOPhotoShootTimerView.h
//  GTIO
//
//  Created by Scott Penrose on 5/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOPhotoShootTimerView;

typedef void(^GTIOPhotoShootTimerCompletionHandler)(GTIOPhotoShootTimerView *photoShootTimerView);

@interface GTIOPhotoShootTimerView : UIView

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) GTIOPhotoShootTimerCompletionHandler completionHandler;

- (void)startWithDuration:(NSTimeInterval)duration completionHandler:(GTIOPhotoShootTimerCompletionHandler)completionHandler;

@end
