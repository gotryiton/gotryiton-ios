//
//  GTIOFilter.h
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GPUImage.h"

typedef enum {
    GTIOFilterTypeOriginal = 0,
    GTIOFilterTypeClementine,
    GTIOFilterTypeColombe,
    GTIOFilterTypeDiesel,
    GTIOFilterTypeHenrik,
    GTIOFilterTypeIIRG,
    GTIOFilterTypeLafayette,
    GTIOFilterTypeLispenard,
    GTIOFilterTypeWalker
} GTIOFilterType;

static NSString * const GTIOFilterTypeName[] = {
    [GTIOFilterTypeOriginal] = @"Original",
    [GTIOFilterTypeClementine] = @"Clementine",
    [GTIOFilterTypeColombe] = @"Colombe",
    [GTIOFilterTypeDiesel] = @"Diesel",
    [GTIOFilterTypeHenrik] = @"Henrik",
    [GTIOFilterTypeIIRG] = @"II-RG",
    [GTIOFilterTypeLafayette] = @"Lafayette",
    [GTIOFilterTypeLispenard] = @"Lispenard",
    [GTIOFilterTypeWalker] = @"Walker"
};

static NSString * const GTIOFilterTypeSelectors[] = {
    [GTIOFilterTypeOriginal] = @"GTIOFilterOriginal",
    [GTIOFilterTypeClementine] = @"GTIOFilterClementine",
    [GTIOFilterTypeColombe] = @"GTIOFilterColombe",
    [GTIOFilterTypeDiesel] = @"GTIOFilterDiesel",
    [GTIOFilterTypeHenrik] = @"GTIOFilterHenrik",
    [GTIOFilterTypeIIRG] = @"GTIOFilterIIRG",
    [GTIOFilterTypeLafayette] = @"GTIOFilterLafayette",
    [GTIOFilterTypeLispenard] = @"GTIOFilterLispenard",
    [GTIOFilterTypeWalker] = @"GTIOFilterWalker"
};

static NSInteger const GTIOFilterOrder[] = { GTIOFilterTypeOriginal,  GTIOFilterTypeColombe, GTIOFilterTypeHenrik, GTIOFilterTypeDiesel, GTIOFilterTypeIIRG, GTIOFilterTypeWalker, GTIOFilterTypeClementine, GTIOFilterTypeLafayette, GTIOFilterTypeLispenard };

@interface GTIOFilter : NSObject

@property (nonatomic, strong) UIImage *maskImage;
@property (nonatomic, assign) CGBlendMode blendMode;

@property (nonatomic, strong) NSMutableArray *baseFilters;
@property (nonatomic, strong) NSMutableArray *backgroundFilters;
@property (nonatomic, strong) NSMutableArray *maskingFilters;

@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, assign) GTIOFilterType filterType;


@end
