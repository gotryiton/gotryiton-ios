//
//  GTIOFilterClementine.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  Clementine
//  filter details:  Sepia style filter (like Hefe on instagram)
//

#import "GTIOFilterClementine.h"

@implementation GTIOFilterClementine

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeClementine;
        
        // Base filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.09];

        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.1];

        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:0.7];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.3];
        
        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {1.25, 0.0, 0.0, 0.0}, // RED
            {0.0, 0.95, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 0.6, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];

        GPUImageGaussianBlurFilter *gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter setBlurSize:0.15];
        
        self.baseFilters = [NSMutableArray arrayWithObjects:saturationFilter, colorMatrixFilter, brightnessFilter, contrastFilter, gaussianBlurFilter, nil];
        
        //background filters
        GPUImageBrightnessFilter *brightnessFilter3 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter3 setBrightness:0.1];

        self.backgroundFilters = [NSMutableArray arrayWithObjects: brightnessFilter3, nil];
        
        // Masking Filters
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        [exposureFilter setExposure:-0.1];
        
        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.20];
        
        GPUImageGaussianBlurFilter *gaussianBlurFilter2 = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter2 setBlurSize:0.10];
       
        self.maskingFilters = [NSMutableArray arrayWithObjects: brightnessFilter2, exposureFilter, nil];
        
        self.maskImage = [UIImage imageNamed:@"filter-mask-1WB.png"];
        self.blendMode = kCGBlendModeNormal;
    }
    return self;
}

@end
