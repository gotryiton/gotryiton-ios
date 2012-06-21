//
//  GTIOPostHeaderView.h
//  GTIO
//
//  Created by Scott Penrose on 6/20/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"

@interface GTIOPostHeaderView : UIView

@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, assign, getter = isShowingShadow) BOOL showingShadow;

- (void)prepareForReuse;

@end
