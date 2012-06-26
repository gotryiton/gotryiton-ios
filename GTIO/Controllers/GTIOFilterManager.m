//
//  GTIOFilterManager.m
//  GTIO
//
//  Created by Scott Penrose on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilterManager.h"

#import "NSMutableDictionary+FilterTypeKeys.h"

@interface GTIOFilterManager ()

@property (nonatomic, strong) NSOperationQueue *filterQueue;
@property (nonatomic, strong) NSMutableDictionary *filteredImages;

@end

@implementation GTIOFilterManager

@synthesize originalImage = _originalImage;
@synthesize filterQueue = _filterQueue;
@synthesize filteredImages = _filteredImages;

+ (id)sharedManager
{
    static GTIOFilterManager *gtio_shared_filterManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gtio_shared_filterManager = [[self alloc] init];
    });
    return gtio_shared_filterManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _filterQueue = [[NSOperationQueue alloc] init];
        [_filterQueue setMaxConcurrentOperationCount:1];
        
        _filteredImages = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)applyAllFilters
{
    for (int i = 0; i < (sizeof GTIOFilterOrder)/(sizeof GTIOFilterOrder[0]); i++) {
        GTIOFilterType filterType = GTIOFilterOrder[i];
        SEL selector = NSSelectorFromString(GTIOFilterTypeSelectors[filterType]);
        if ([self.originalImage respondsToSelector:selector]) {
            GTIOFilterOperation *filterOperation = [[GTIOFilterOperation alloc] initWithFilterType:filterType];
            [filterOperation setOriginalImage:self.originalImage];
            [filterOperation setFinishedHandler:^(GTIOFilterType filterType, UIImage *filteredImage) {
                [self.filteredImages setObject:filteredImage forFilterType:filterType];
            }];
            [self.filterQueue addOperation:filterOperation];
        } else {
            NSLog(@"Could not load filter: %@", filterType);
        }
    }
}

- (UIImage *)photoWithFilterType:(GTIOFilterType)filterType
{
    UIImage *filteredImage = [self.filteredImages objectForFilterType:filterType];
    if (!filteredImage) {
        GTIOFilterOperation *operation = [self moveFilterToTopOfQueue:filterType];
        [operation waitUntilFinished];
        filteredImage = operation.filteredImage;
    }
    
    return filteredImage;
}

- (void)clearFilters
{
    [self.filterQueue cancelAllOperations];
    [self.filteredImages removeAllObjects];
}

- (GTIOFilterOperation *)moveFilterToTopOfQueue:(GTIOFilterType)filterType
{
    for (GTIOFilterOperation *operation in self.filterQueue.operations) {
        if (filterType == operation.filterType) {
            [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            return operation;
        }
    }
    return nil;
}

#pragma mark - Properties

- (void)setOriginalImage:(UIImage *)originalImage
{
    [self clearFilters];
    _originalImage = originalImage;
}

@end
