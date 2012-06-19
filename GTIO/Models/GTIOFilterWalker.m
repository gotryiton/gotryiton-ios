//
//  GTIOFilterWalker.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  Walker
//  filter details:  subtle highlights
//

#import "GTIOFilterWalker.h"

@implementation GTIOFilterWalker

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeWalker;
        
        //Background Filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.05];

        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.27];

        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:0.7];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.3];
        
        GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
        [sepiaFilter setIntensity:0.3];

        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {1.12, 0.0, 0.0, 0.0}, // RED
            {0.0, 0.9, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 0.78, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];

        GPUImageGaussianBlurFilter *gaussianBlurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter setBlurSize:0.17];

        self.backgroundFilters = [NSMutableArray arrayWithObjects: colorMatrixFilter, sepiaFilter, brightnessFilter, contrastFilter, gaussianBlurFilter, nil];
        
        // Masking Filters
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        [exposureFilter setExposure:-0.3];
        
        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.13];
        
        GPUImageGaussianBlurFilter *gaussianBlurFilter2 = [[GPUImageGaussianBlurFilter alloc] init];
        [gaussianBlurFilter2 setBlurSize:0.23];
        
        self.maskingFilters = [NSMutableArray arrayWithObjects:brightnessFilter2, gaussianBlurFilter2, exposureFilter, nil];
        
        self.maskImage = [UIImage imageNamed:@"filter-mask-2WB.png"];
        self.blendMode = kCGBlendModeNormal;
    }
    return self;
}

@end
