//
//  GTIOPhotoFilterView.h
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GTIOFilterOriginal = 0,
    GTIOFilterClementine,
    GTIOFilterColombe,
    GTIOFilterDiesel,
    GTIOFilterHenrik,
    GTIOFilterIIRG,
    GTIOFilterLafayette,
    GTIOFilterLispenard,
    GTIOFilterWalker
} GTIOFilter;

static NSString * const GTIOFilterName[] = {
    [GTIOFilterOriginal] = @"Original",
    [GTIOFilterClementine] = @"Clementine",
    [GTIOFilterColombe] = @"Colombe",
    [GTIOFilterDiesel] = @"Diesel",
    [GTIOFilterHenrik] = @"Henrik",
    [GTIOFilterIIRG] = @"II-RG",
    [GTIOFilterLafayette] = @"Lafayette",
    [GTIOFilterLispenard] = @"Lispenard",
    [GTIOFilterWalker] = @"Walker"
};

@interface GTIOPhotoFilterView : UIView

@property (nonatomic, assign) GTIOFilter filter;

@property (nonatomic, assign, getter = isFilterSelected) BOOL filterSelected;

- (id)initWithFrame:(CGRect)frame filter:(GTIOFilter)filter filterSelected:(BOOL)filterSelected;

@end
