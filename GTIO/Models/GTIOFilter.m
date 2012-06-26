//
//  GTIOFilter.m
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilter.h"

#import "GTIOFilterManager.h"
#import "GTIOFilterOperation.h"

#import "UIImage+Blend.h"
#import "UIImage+GTIOFilters.h"
#import "UIImage+Filter.h"

@interface GTIOFilter ()

- (UIImage *)filterImage:(UIImage *)image WithFilters:(NSMutableArray *)filters;

@end

@implementation GTIOFilter

@synthesize maskImage = _maskImage;
@synthesize blendMode = _blendMode;

@synthesize backgroundFilters = _backgroundFilters, maskingFilters = _maskingFilters, baseFilters = _baseFilters;
@synthesize originalImage = _originalImage;
@synthesize filterType = _filterType;

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundFilters = [[NSMutableArray alloc] init];
        _maskingFilters = [[NSMutableArray alloc] init];
        _baseFilters = [[NSMutableArray alloc] init];
        
        _maskImage = nil;
        
        _blendMode = kCGBlendModeNormal;
    }
    return self;
}



- (UIImage *)filterImage:(UIImage *)image WithFilters:(NSMutableArray *)filters
{
    if ([filters count] > 0) {
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
        
        [filters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (0 == idx) {
                [stillImageSource addTarget:obj];
            } else {
                [[filters objectAtIndex:idx-1] addTarget:obj];
            }
        }];
        
        id lastFilter = [filters objectAtIndex:[filters count] - 1];
        
        [stillImageSource addTarget:lastFilter];
        [stillImageSource processImage];

        UIImage *filteredImage = [lastFilter imageFromCurrentlyProcessedOutput];
        return filteredImage;
    } else {
        return image;
    }
}

#pragma mark - Properties

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
}

@end
