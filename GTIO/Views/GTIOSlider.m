//
//  GTIOSlider.m
//  GTIO
//
//  Created by Scott Penrose on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOSlider.h"

#import <QuartzCore/QuartzCore.h>

@implementation GTIOSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    CGRect r = [super thumbRectForBounds:bounds trackRect:rect value:value];
//    NSLog(@"Thumb Bounds: %@, thumbRect: %@, trackRect: %@, value %f", NSStringFromCGRect(bounds), NSStringFromCGRect(r), NSStringFromCGRect(rect), value);
//    return r;
//}

- (void)valueChanged:(id)sender
{
    NSLog(@"Value: %f", self.value);
    if (self.value >= .99) {
        [self setThumbImage:[UIImage imageNamed:@"upload.bottom.bar.switch.shadow.left.png"] forState:UIControlStateNormal];
    } else if (self.value <= .01) {
        [self setThumbImage:[UIImage imageNamed:@"upload.bottom.bar.switch.shadow.right.png"] forState:UIControlStateNormal];        
    } else {
        [self setThumbImage:[UIImage imageNamed:@"upload.bottom.bar.switch.png"] forState:UIControlStateNormal];
    }
}

@end
