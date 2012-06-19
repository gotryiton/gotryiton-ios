//
//  GTIOFilterOperation.m
//  GTIO
//
//  Created by Scott Penrose on 6/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilterOperation.h"

@implementation GTIOFilterOperation

@synthesize filterType = _filterType;
@synthesize originalImage = _originalImage;
@synthesize filteredImage = _filteredImage;
@synthesize finishedHandler = _finishedHandler;

- (id)initWithFilterType:(GTIOFilterType)filterType
{
    self = [super init];
    if (self) {
        _filterType = filterType;
    }
    return self;
}

- (void)main
{
    if (![self isCancelled]) {
        NSLog(@"Start filter: %@", GTIOFilterTypeName[self.filterType]);
        
        Class filterClass = NSClassFromString(GTIOFilterTypeClass[self.filterType]);
        if (filterClass) {
            GTIOFilter *filter = [[filterClass alloc] init];
            [filter setOriginalImage:self.originalImage];
            self.filteredImage = [filter applyFilters];
            filter = nil;
            
            if (self.finishedHandler) {
                self.finishedHandler(self.filterType, self.filteredImage);
            }
        }
        
        NSLog(@"Finish filter");
    }
}

@end
