//
//  GTIOFilterDiesel.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//
//  filter name:  Diesel
//  filter details:   almost black and white
//

#import "GTIOFilterDiesel.h"

@implementation GTIOFilterDiesel

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeDiesel;
        
        //base filters
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.05];

        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:0.22];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.2];
        
        GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
        [colorMatrixFilter setIntensity:0.7];
        [colorMatrixFilter setColorMatrix:(GPUMatrix4x4){
            {1.08, 0.0, 0.0, 0.0}, // RED
            {0.0, 0.92, 0.0, 0.0}, // GREEN
            {0.0, 0.0, 1.05, 0.0}, // BLUE
            {0.0, 0.0, 0.0, 1.0}, // ALPHA
        }];
        
        GPUImageSharpenFilter *sharpnessFilter = [[GPUImageSharpenFilter alloc] init];
        [sharpnessFilter setSharpness:0.5];
        
        self.baseFilters = [NSMutableArray arrayWithObjects: sharpnessFilter, contrastFilter, gammaFilter, colorMatrixFilter,  saturationFilter, nil];

        // Background filters
         GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.28];

        self.backgroundFilters = [NSMutableArray arrayWithObjects: brightnessFilter,  nil];        

        // Masking Filters
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        [exposureFilter setExposure:-0.09];
        
        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.08];
       
        self.maskingFilters = [NSMutableArray arrayWithObjects: brightnessFilter2, exposureFilter, nil];
        
        self.maskImage = [UIImage imageNamed:@"filter-mask-2WB.png"];
        self.blendMode = kCGBlendModeNormal;
    }
    return self;
}

@end
