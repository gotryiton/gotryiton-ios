//
//  GTIOPopOverView.h
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTIOPopOverButton.h"

typedef void(^GTIOPopOverViewButtonTapHandler)(GTIOButton *buttonModel);

@interface GTIOPopOverView : UIView

@property (nonatomic, strong, readonly) NSArray *buttonModels;
@property (nonatomic, copy) GTIOPopOverViewButtonTapHandler tapHandler;

+ (id)popOverForCameraSources;
+ (id)popOverForPostDotDotDotWithButtonModels:(NSArray *)buttonModels;

@end
