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
        SEL selector = NSSelectorFromString(GTIOFilterTypeSelectors[self.filterType]);
        if ([self.originalImage respondsToSelector:selector]) {

            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            self.filteredImage = [self.originalImage performSelector:selector];
            #pragma clang diagnostic pop
            
            if (self.finishedHandler) {
                self.finishedHandler(self.filterType, self.filteredImage);
            }
        }
    }
}

@end
