//
//  GTIOPostUploadView.h
//  GTIO
//
//  Created by Scott Penrose on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostManager.h"

@interface GTIOPostUploadView : UIView

@property (nonatomic, assign, getter = isShowingShadow) BOOL showingShadow;
@property (nonatomic, assign) BOOL clearBackground;

@property (nonatomic, assign) GTIOPostState state;
@property (nonatomic, assign) CGFloat progress;

- (void)prepareForReuse;

@end
