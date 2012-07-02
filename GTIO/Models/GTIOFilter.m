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

#pragma mark - Properties

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
}

@end
