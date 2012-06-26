//
//  UIImage+Blend.h
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blend)

+ (UIImage *)overlayTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage;
+ (UIImage *)blendTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage blendMode:(CGBlendMode)blendMode;

@end
