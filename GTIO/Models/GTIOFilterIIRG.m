//
//  GTIOFilterIIRG.m
//  GTIO
//
//  Created by Simon Holroyd on 5/9/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//


#import "GTIOFilterIIRG.h"

@implementation GTIOFilterIIRG

- (id)init
{
    self = [super init];
    if (self) {
        self.filterType = GTIOFilterTypeIIRG;
        
        // base filters
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        [contrastFilter setContrast:1.53];

        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        [saturationFilter setSaturation:0];
        
        GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
        [gammaFilter setGamma:1.5];

        self.baseFilters = [NSMutableArray arrayWithObjects:  contrastFilter, gammaFilter,  saturationFilter,  nil];

        // Background filters
        GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter setBrightness:0.23];

        self.backgroundFilters = [NSMutableArray arrayWithObjects: brightnessFilter,  nil];
        
        // Masking Filters
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        [exposureFilter setExposure:-0.09];
        
        GPUImageBrightnessFilter *brightnessFilter2 = [[GPUImageBrightnessFilter alloc] init];
        [brightnessFilter2 setBrightness:-0.08];

        self.maskingFilters = [NSMutableArray arrayWithObjects: brightnessFilter2, exposureFilter, nil];
        
        self.maskImage = [UIImage imageNamed:@"filter-mask-1WB.png"];
        self.blendMode = kCGBlendModeNormal;
    }
    return self;
}

@end
