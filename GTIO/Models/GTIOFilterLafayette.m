//
//  GTIOFilterTakk.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  Lafayette
//  filter details:  tilt shift with reds and blues
//

#import "GTIOFilterLafayette.h"

@implementation GTIOFilterLafayette

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeLafayette;
        
        // Base filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.02];

        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.1];
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:1.14];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:0.95];
        
        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {1.02, 0.0, 0.0, 0.0}, // RED
            {0.0, 0.93, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 1.01, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];

        GPUImageGaussianBlurFilter *gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter setBlurSize:0.10];
        
        self.baseFilters = [NSMutableArray arrayWithObjects:gammaFilter, brightnessFilter, contrastFilter, colorMatrixFilter, saturationFilter, nil];
        
        // Background filters
        self.backgroundFilters = [NSMutableArray array];
        
        // Masking Filters
        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.13];
    
        GPUImageGaussianBlurFilter *gaussianBlurFilter2 = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter2 setBlurSize:1.3];
       
        self.maskingFilters = [NSMutableArray arrayWithObjects: gaussianBlurFilter2, nil];
        
        self.maskImage = [UIImage imageNamed:@"filter-mask-3-blur.png"];
        self.blendMode = kCGBlendModeNormal;
    }
    return self;
}

@end
