//
//  GTIOFilterWalker.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  lispenard
//  filter details:  high contrast with desaturated greens
//

#import "GTIOFilterLispenard.h"

@implementation GTIOFilterLispenard

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeLispenard;
        
        // Base filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.076];

        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.16];
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:0.74];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.2];
        
        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {0.97, 0.0, 0.0, 0.0}, // RED
            {0.0, 1.02, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 0.85, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];

        GPUImageGaussianBlurFilter *gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter setBlurSize:0.10];

        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.07];
        
        self.baseFilters = [NSMutableArray arrayWithObjects:gammaFilter, brightnessFilter, contrastFilter, colorMatrixFilter, saturationFilter, brightnessFilter2, nil];
    }
    return self;
}

@end
