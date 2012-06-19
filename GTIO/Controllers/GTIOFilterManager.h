//
//  GTIOFilterManager.h
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilter.h"

#import "GTIOFilterOperation.h"

@interface GTIOFilterManager : NSObject

@property (nonatomic, strong) UIImage *originalImage;

+ (id)sharedManager;

- (void)applyAllFilters;
- (void)clearFilters;
- (UIImage *)photoWithFilterType:(GTIOFilterType)filterType;
- (GTIOFilterOperation *)moveFilterToTopOfQueue:(GTIOFilterType)filterType;

@end
