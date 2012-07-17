//
//  GTIOProductHeartControl.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/17/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOProductHeartControl : UIView

@property (nonatomic, strong) NSNumber *heartState;
@property (nonatomic, strong) NSNumber *heartCount;

@property (nonatomic, copy) GTIOButtonDidTapHandler heartTapHandler;
@property (nonatomic, copy) GTIOButtonDidTapHandler countTapHandler;

@end
