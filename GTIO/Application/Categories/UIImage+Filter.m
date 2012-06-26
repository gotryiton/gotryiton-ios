//
//  UIImage+UIImage_Filter_m.m
//  GTIO
//
//  Updated by Simon Holroyd on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "UIImage+Filter.h"

#define SAFE(color) MIN(255,MAX(0,color))

@implementation UIImage (Filter)
- (CGContextRef) ImageToContex: (UIImage *) image {
    // Get sizeof data buffer
    CGImageRef imageRef = image.CGImage;
    size_t pixelsWide = CGImageGetWidth(imageRef);
    size_t pixelsHigh = CGImageGetHeight(imageRef);
    size_t step = 4;
    int bufferSize = pixelsHigh * pixelsWide * step;
    
    // Alloc data buffer and Create contex
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void * buffer = malloc(bufferSize);
    CGContextRef context = CGBitmapContextCreate (
                                                  buffer,
                                                  pixelsWide,
                                                  pixelsHigh,
                                                  8,
                                                  pixelsWide * step,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedFirst);
    
    // Draw the image to bitmap context
    CGRect rect = {{0,0},{pixelsWide, pixelsHigh}}; 
    CGContextDrawImage(context, rect, imageRef);
    
    // release data
    CGColorSpaceRelease( colorSpace );
    
    // return result
    return context;
}


- (UIImage *) ContexToImage:(CGContextRef)contex {
    CGImageRef mCGImage = CGBitmapContextCreateImage(contex);
    UIImage * mUIImage = [UIImage imageWithCGImage: mCGImage];
    CGImageRelease(mCGImage);
    return mUIImage;
}


- (UIImage *) normalize {

    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL, 
                                                         self.size.width, 
                                                         self.size.height, 
                                                         8, (4 * self.size.width), 
                                                         genericColorSpace, 
                                                         kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);    
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);

    return result;    
}


- (UIImage *) applyBlend:(UIImage *) image Callback: (void (^)(unsigned char *, unsigned char *)) fn{
    size_t width0 = CGImageGetWidth(self.CGImage);
    size_t height0 = CGImageGetHeight(self.CGImage);
    size_t width1 = CGImageGetWidth(image.CGImage);
    size_t height1 = CGImageGetHeight(image.CGImage);
    size_t step = 4;
    if (width0 != width1 || height0 != height1) {
        return NULL;
    }
    
    CGContextRef contex0 = [self ImageToContex:self];
    CGContextRef contex1 = [self ImageToContex:image];
    unsigned char * data0 = (unsigned char *) CGBitmapContextGetData(contex0);
    unsigned char * data1 = (unsigned char *) CGBitmapContextGetData(contex1);
    
    int length = height0 * width0 * step;
    for (int i = 0; i < length; i += step) {
        fn(data0 + i, data1 + i);
    }
    UIImage * finalImage = [self ContexToImage:contex0];
    
    CGContextRelease(contex0);
    CGContextRelease(contex1);
    free(data0);
    free(data1);
    
    return finalImage;
}

- (UIImage *) applyCurve:(Curve)curve {
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    size_t step = 4;
    
    CGContextRef contex = [self ImageToContex:self];
    unsigned char * data = (unsigned char *) CGBitmapContextGetData(contex);
    
    int length = height * width * step;
    for (int i = 0; i < length; i += step) {
        data[i + 1] = SAFE(curve.r[data[i+1]]);
        data[i + 2] = SAFE(curve.g[data[i+2]]);
        data[i + 3] = SAFE(curve.b[data[i+3]]);
    }
    
    UIImage * finalImage = [self ContexToImage:contex];
    CGContextRelease(contex);
    free(data);
    return finalImage;
}

- (UIImage *) applyFilter:(void (^)(unsigned char *))fn {
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    size_t step = 4;
    
    CGContextRef contex = [self ImageToContex:self];
    unsigned char * data = (unsigned char *) CGBitmapContextGetData(contex);
    
    int length = height * width * step;
    for (int i = 0; i < length; i += step) {
        fn(data + i);
    }
    
    UIImage * finalImage = [self ContexToImage:contex];
    CGContextRelease(contex);
    free(data);
    return finalImage;
}

unsigned char calcBlend(unsigned char a, unsigned char b, double ratio) {
    return SAFE(a * ratio + b * (1 - ratio));
}

unsigned char calcScreen(unsigned char a, unsigned char b) {
    return SAFE(255 - (255 - a) * (255 - b) / 255);
}

- (UIImage *) screen: (UIImage *) image ratio: (double) ratio {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        for (int i = 1; i < 4; i++) {
            data0[i] = calcBlend(calcScreen(data0[i], data1[i]), data0[i], ratio);
        }
    }];
}

unsigned char calcOverlay(unsigned char a, unsigned char b) {
    return SAFE((a > 128.0f) ? 255.0f - 2.0f * (255.0f - b) * (255.0f - a) / 255.0f: (a * b * 2.0f) / 255.0f);
}

- (UIImage *) overlay: (UIImage *) image ratio: (double) ratio {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        for (int i = 1; i < 4; i++) {
            data0[i] = calcBlend(calcOverlay(data0[i], data1[i]), data0[i], ratio);
        }
    }];
}

- (UIImage *) overlay: (UIImage *) image ratio: (double) ratio channel:(int)channel {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        data0[channel] = calcBlend(calcOverlay(data0[channel], data1[channel]), data0[channel], ratio);
    }];
}

unsigned char calcMultiply(unsigned char a, unsigned char b) {
    return SAFE(1 * a * b / 255);
}

- (UIImage *) multiply:(UIImage *)image ratio:(double)ratio {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        for (int i = 1; i < 4; i++) {
            data0[i] = calcBlend(calcMultiply(data0[i], data1[i]), data0[i], ratio);
        }
    }];    
}

- (UIImage *) mask:(UIImage *)image {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        if (data1[0] != 0) {
            data0[1] = data1[1];
            data0[2] = data1[2];
            data0[3] = data1[3];
        }
    }];    
}

unsigned char calcLighten(unsigned char a, unsigned char b) {
    return SAFE(a > b ? a : b);
}

- (UIImage *) lighten:(UIImage *) image ratio:(double) ratio {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        for (int i = 1; i < 4; i++) {
            data0[i] = calcBlend(calcLighten(data0[i], data1[i]), data0[i], ratio);
        }
    }];    
}


unsigned char calcLinearDodge(unsigned char a, unsigned char b) {
    return SAFE(a + b);
}

- (UIImage *) linearDodge:(UIImage *) image ratio:(double) ratio {
    return [self applyBlend: image Callback:^ (unsigned char * data0, unsigned char * data1) {
        for (int i = 1; i < 4; i++) {
            data0[i] = calcBlend(calcLinearDodge(data0[i], data1[i]), data0[i], ratio);
        }
    }];    
}

- (UIImage *) ink{
    return [self applyFilter:^(unsigned char * data) {
        data[1] = data[2] = data[3] = data[1];
    }];
}
@end




