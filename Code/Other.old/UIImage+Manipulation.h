//
//  UIImage+Manipulation.h
//  GoTryItOn
//
//  Created by Blake Watters on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// UKImage.h -- extra UIImage methods
/// by allen brunson  march 29 2009

#import <UIKit/UIKit.h>

@interface UIImage (Manipulation)

/**
 * Rotates the image with the specified orientation
 */
-(UIImage*)rotate:(UIImageOrientation)orient;

/**
 * Returns a new image with a blur applied at the specified point
 */
-(UIImage*)imageWithBlurAroundPoint:(CGPoint)point;

/**
 * Return a new UIImage scaled to a percentage of the original dimensions
 */
-(UIImage*)imageWithScale:(float)scale;

/**
 * Resize an image to the specified width & height
 */
- (UIImage*)imageResizedToWidth:(int)width andHeight:(int)height;

/**
 * Perform a blurr within the given rect
 */
- (UIImage*)imageWithBlurredRegionAtRect:(CGRect)blurRect withRadius:(float)radius;

/**
 * returns the region specified as a blurred image
 */
- (UIImage*)blurImageForRegionAtRect:(CGRect)blurRect;


- (UIImage*)blurredCopy;
- (UIImage*)sampleImageForRegionAtRect:(CGRect)rect;

@end
