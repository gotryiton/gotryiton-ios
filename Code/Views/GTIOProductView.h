//
//  GTIOProductView.h
//  GTIO
//
//  Created by Joshua Johnson on 2/7/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOProduct;

@interface GTIOProductView : UIView <TTImageViewDelegate>

@property (nonatomic, copy) NSString *suggestionText;
@property (nonatomic, retain) GTIOProduct *product;

+ (CGFloat)productViewHeightForProduct:(GTIOProduct *)product;

@end
