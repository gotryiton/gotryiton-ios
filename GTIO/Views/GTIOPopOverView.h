//
//  GTIOPopOverView.h
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPopOverView : UIView

@property (nonatomic, strong, readonly) NSArray *buttonModels;

- (id)initWithButtonModels:(NSArray *)buttonModels;

@end
