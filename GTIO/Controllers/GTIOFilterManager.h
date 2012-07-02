//
//  GTIOFilterManager.h
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "UIImage+GTIOFilters.h"
#import "UIImage+Filter.h"

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

@class GTIOFilterOperation;

@interface GTIOFilterManager : NSObject

@property (nonatomic, strong) UIImage *originalImage;

+ (id)sharedManager;

- (void)applyAllFilters;
- (void)clearFilters;
- (UIImage *)photoWithFilterType:(GTIOFilterType)filterType;
- (GTIOFilterOperation *)moveFilterToTopOfQueue:(GTIOFilterType)filterType;

@end
