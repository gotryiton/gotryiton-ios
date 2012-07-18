//
//  GTIOPostButtonColumnView.h
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPost.h"

#import "GTIOPostSideButton.h"

@interface GTIOPostButtonColumnView : UIView

@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, copy) GTIOButtonDidTapHandler ellipsisButtonTapHandler;
@property (nonatomic, strong) GTIOPostSideButton *ellipsisButton;

- (void)prepareForReuse;

@end
