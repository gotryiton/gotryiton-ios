//
//  GTIOPostBrandButtonsView.h
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButton.h"

@interface GTIOPostBrandButtonsView : UIView

@property (nonatomic, strong) NSArray *buttons;

+ (CGFloat)heightWithWidth:(CGFloat)width buttons:(NSArray *)buttons;

@end
