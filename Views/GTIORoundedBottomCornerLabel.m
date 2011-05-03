//
//  GTIORoundedBottomCornerLabel.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIORoundedBottomCornerLabel.h"


@implementation GTIORoundedBottomCornerLabel

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext(); 
	CGMutablePathRef outlinePath = CGPathCreateMutable(); 
	
	UIColor* bgColor = RGBACOLOR(255,255,255,0.1);
	[bgColor set];
	
	float radius = 3.0; 
	float w  = [self bounds].size.width; 
	float h  = [self bounds].size.height;
	CGPathMoveToPoint(outlinePath, nil, 0, 0);
	CGPathAddLineToPoint(outlinePath, nil, w, 0); 
	CGPathAddLineToPoint(outlinePath, nil, w, h - radius); 
	CGPathAddArcToPoint(outlinePath, nil, w, h, w-radius, h, radius);
	CGPathAddLineToPoint(outlinePath, nil, radius, h); 
	CGPathAddArcToPoint(outlinePath, nil, 0, h, 0, h-radius, radius);
	
	CGPathCloseSubpath(outlinePath); 
	CGContextSaveGState(ctx); 
	CGContextSetShadow(ctx, CGSizeMake(3,-4), 4); 
	CGContextAddPath(ctx, outlinePath); 
	CGContextFillPath(ctx); 
	CGContextRestoreGState(ctx); 
	CGContextAddPath(ctx, outlinePath); 
	CGContextClip(ctx); 
	[super drawRect:rect]; 
	CGPathRelease(outlinePath);
}

@end
