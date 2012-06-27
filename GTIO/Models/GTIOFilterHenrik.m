//
//  GTIOFilterHenrik.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  Henrik
//  filter details:  
//

#import "GTIOFilterHenrik.h"

@implementation GTIOFilterHenrik

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeHenrik;
        
        // base filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.13];

        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.2];

        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:1.4];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.3];
        
        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {0.95, 0.0, 0.0, 0.0}, // RED
            {0.0, 1.0, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 1.1, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];

        GPUImageGaussianBlurFilter *gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter setBlurSize:0.17];
        
        self.baseFilters = [NSMutableArray arrayWithObjects:contrastFilter, brightnessFilter, saturationFilter, gammaFilter, colorMatrixFilter, gaussianBlurFilter, nil];
    }
    return self;
}

@end
