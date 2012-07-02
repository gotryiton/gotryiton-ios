//
//  UIImage+UIImage_Filter_m.m
//  GTIO
//
//  Updated by Simon Holroyd on 6/26/12.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef unsigned char Curve[256];

typedef struct {
    Curve r;
    Curve g;
    Curve b;
} RGBCurve;


@interface UIImage (Filter)

#pragma mark Base Method
- (CGContextRef) imageToContext: (UIImage *) image;
- (UIImage *) contextToImage: (CGContextRef) context;
- (UIImage *) normalize;

#pragma mark Resizing

- (UIImage *) resizeForFiltering;
- (UIImage *) resizeForFilteringToMatchImage: (UIImage *) image;

#pragma mark Core Method
- (UIImage *) applyBlend:(UIImage *) image Callback: (void (^)(unsigned char *, unsigned char *)) fn;
- (UIImage *) applyRGBCurve:(RGBCurve) curve;
- (UIImage *) applyValueCurve:(Curve) curve;
- (UIImage *) desaturateThroughRed;
- (UIImage *) addLinesWithBrightness: (double) brightness;
- (UIImage *) desaturate;
- (UIImage *) desaturateWithRatio: (double) ratio;
- (UIImage *) applyFilter: (void (^)(unsigned char * )) fn;

#pragma mark Blend Effect
- (UIImage *) screen: (UIImage *) image ratio: (double) ratio;
- (UIImage *) overlay: (UIImage *) image ratio: (double) ratio;
- (UIImage *) overlay: (UIImage *) image ratio: (double) ratio channel: (int) channel;
- (UIImage *) multiply: (UIImage *) image ratio: (double) ratio;
- (UIImage *) lighten: (UIImage *) image ratio: (double) ratio;
- (UIImage *) linearDodge: (UIImage *) image ratio: (double) ratio;
- (UIImage *) mask: (UIImage *) image;


@end
