//
//  UIImage+Blend.m
//  GTIO
//
//  Created by Scott Penrose on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "UIImage+Blend.h"

@implementation UIImage (Blend)

+ (UIImage *)overlayTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage
{
    UIGraphicsBeginImageContextWithOptions(bottomImage.size, YES, [[UIScreen mainScreen] scale]);
    
    [bottomImage drawInRect:(CGRect){ CGPointZero, { 42, 42 } }];
    [topImage drawInRect:(CGRect){ CGPointZero, topImage.size }];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return blendedImage;
}

+ (UIImage *)blendTopImage:(UIImage *)topImage bottomImage:(UIImage *)bottomImage blendMode:(CGBlendMode)blendMode
{
    UIGraphicsBeginImageContextWithOptions(bottomImage.size, YES, [[UIScreen mainScreen] scale]);
    
    [bottomImage drawInRect:(CGRect){ CGPointZero, bottomImage.size }];
    [topImage drawInRect:(CGRect){ CGPointZero, bottomImage.size } blendMode:blendMode alpha:1.0];
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return blendedImage;
}

@end
