//
//  UIImage+Rotation.m
//  GoTryItOn
//
//  Created by Blake Watters on 8/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

// UKImage.mm -- extra UIImage methods
// by allen brunson  march 29 2009
// based on original code by Kevin Lohman:
// http://blog.logichigh.com/2008/06/05/uiimage-fix/

#include "UIImage+Manipulation.h"
#import "ImageHelper-ImageProcessing.h"

CGFloat DegreesToRadians(CGFloat degrees) {
	return degrees * M_PI / 180;
};

static CGRect swapWidthAndHeight(CGRect rect) {
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


@implementation UIImage (Manipulation)

-(UIImage*)rotate:(UIImageOrientation)orient {
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
	
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
    
    switch (orient)
    {
        case UIImageOrientationUp:
			// would get you an exact copy of the original
			assert(false);
			return nil;
			
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
			
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
			
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
			
        case UIImageOrientationLeft:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationLeftMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
			break;
			
        case UIImageOrientationRight:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        case UIImageOrientationRightMirrored:
			bnds = swapWidthAndHeight(bnds);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI / 2.0);
			break;
			
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
			
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
	
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	NSLog(@"Copy Size: %@", NSStringFromCGSize(copy.size));
	
    return copy;
}

-(UIImage*)imageWithBlurAroundPoint:(CGPoint)point {
	CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	int				   indx	= 0;
	
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
	// Cut out a sample out the image
	CGRect fillRect = CGRectMake(point.x - 10, point.y - 10, 20, 20);
	CGImageRef sampleImageRef = CGImageCreateWithImageInRect(self.CGImage, fillRect);
	
	// Flip the image right side up & draw
	CGContextSaveGState(ctxt);
	
	CGContextScaleCTM(ctxt, 1.0, -1.0);
	CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
	CGContextConcatCTM(ctxt, tran);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
	
	// Restore the context so that the coordinate system is restored
	CGContextRestoreGState(ctxt);
	
	// Cut out a sample image and redraw it over the source rect
	// several times, shifting the opacity and the positioning slightly
	// to produce a blurred effect
	for (indx = 0; indx < 5; indx++) {
		CGRect myRect = CGRectOffset(fillRect, 0.5 * indx, 0.5 * indx);
		CGContextSetAlpha(ctxt, 0.2 * indx);
		CGContextScaleCTM(ctxt, 1.0, -1.0);
		CGContextDrawImage(ctxt, myRect, sampleImageRef);
	}
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

-(UIImage*)imageWithScale:(float)scale {
	// Create the bitmap context
	CGContextRef    context = NULL;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	CGImageRef		imageRef = self.CGImage;
	
	// Get image width, height. We'll use the entire image.
	int width = CGImageGetWidth(imageRef) * scale;
	int height = CGImageGetHeight(imageRef) * scale;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (width * 4);
	bitmapByteCount     = (bitmapBytesPerRow * height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL)
	{
		return nil;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	CGColorSpaceRef colorspace = CGImageGetColorSpace(imageRef);
	context = CGBitmapContextCreate(bitmapData,width,height,8,bitmapBytesPerRow,
									colorspace,kCGImageAlphaNoneSkipFirst);
	CGColorSpaceRelease(colorspace);
	
	if (context == NULL) {
		// error creating context
		return nil;
	}
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(context, CGRectMake(0,0,width, height), imageRef);
	
	CGImageRef newImageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	free(bitmapData);
	
	return [UIImage imageWithCGImage:newImageRef];
}

- (UIImage*)imageResizedToWidth:(int)width andHeight:(int)height
{
	CGImageRef imageRef = self.CGImage;
	// create context, keeping original image properties
	CGColorSpaceRef colorspace = CGImageGetColorSpace(imageRef);
	CGContextRef context = CGBitmapContextCreate(NULL, width, height,
												 CGImageGetBitsPerComponent(imageRef),
												 CGImageGetBytesPerRow(imageRef),
												 colorspace,
												 CGImageGetAlphaInfo(imageRef));
	CGColorSpaceRelease(colorspace);
	
	if (context == NULL) {
		return nil;
	}
	
	// draw image to context (resizing it)
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	// extract resulting image from context
	CGImageRef newImageRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	return [UIImage imageWithCGImage:newImageRef];
}

//////////////////////
// Blurring

- (UIImage*)sampleImageForRegionAtRect:(CGRect)rect {
	CGImageRef sampleImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	return [[UIImage alloc] initWithCGImage:sampleImageRef];
}

- (UIImage*)blurredCopy {
  NSLog(@"Began blur operation");
	UIImage* blurredImage = [ImageHelper convolveImage:self withBlurRadius:4];
  NSLog(@"Finished blur operation");
  
	return blurredImage;
}

- (UIImage*)blurImageForRegionAtRect:(CGRect)blurRect {
	UIImage* sample = [self sampleImageForRegionAtRect:blurRect];
	return [sample blurredCopy];
}

- (UIImage*)imageWithBlurredRegionAtRect:(CGRect)blurRect withRadius:(float)radius {
	
	CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	
    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
	
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
	
	// Flip the image right side up & draw
	CGContextSaveGState(ctxt);
	
	CGContextScaleCTM(ctxt, 1.0, -1.0);
	CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
	CGContextConcatCTM(ctxt, tran);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
	
	// Restore the context so that the coordinate system is restored
	CGContextRestoreGState(ctxt);
	
	// ROUND CORNERS
	CGContextBeginPath(ctxt);
	addRoundedRectToPath(ctxt, blurRect, radius, radius);
	CGContextClosePath(ctxt);
	CGContextClip(ctxt);
	///////
	
	// Fix rect so we don't get square edges
	float scale = 0.2f;
	float border = 4.0f/scale;
	blurRect = CGRectInset(blurRect, -border, -border);

	UIImage* sample = [self sampleImageForRegionAtRect:blurRect];
	sample = [sample imageWithScale:scale];
	sample = [sample blurredCopy];
	[sample drawInRect:blurRect];
	
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return copy;
}

@end
