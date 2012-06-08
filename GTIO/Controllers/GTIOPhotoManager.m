//
//  GTIOPhotoManager.m
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoManager.h"

#import "GTIOProcessImageRequest.h"

#import "GTIOResizePhotoOperation.h"

@interface GTIOPhotoManager ()

@property (nonatomic, strong) NSMutableArray *processImageRequests;

@property (nonatomic, strong) NSOperationQueue *resizeQueue;

@end

@implementation GTIOPhotoManager

@synthesize processImageRequests = _processImageRequests;
@synthesize resizeQueue = _resizeQueue;

+ (GTIOPhotoManager *)sharedManager
{
    static GTIOPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _processImageRequests = [NSMutableArray array];
        
        _resizeQueue = [[NSOperationQueue alloc] init];
        [_resizeQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (NSInteger)photoCount
{
    return [self.processImageRequests count];
}

- (void)addPhoto:(UIImage *)photo
{
    GTIOProcessImageRequest *processImageRequest = [[GTIOProcessImageRequest alloc] init];
    processImageRequest.rawImage = photo;
    [_processImageRequests addObject:processImageRequest];
}

- (NSArray *)thumbnailPhotos
{
    NSMutableArray *thumbnails = [NSMutableArray array];
    for (GTIOProcessImageRequest *processImageRequest in self.processImageRequests) {
        [thumbnails addObject:[processImageRequest thumbnail]];
    }
    return thumbnails;
}

- (UIImage *)photoAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.processImageRequests count]) {
        GTIOProcessImageRequest *processImageRequest = [self.processImageRequests objectAtIndex:index];
        return processImageRequest.processedImage;
    }
    return nil;
}

- (void)removeAllPhotos
{
    [self.processImageRequests removeAllObjects];
}

- (void)resizeAllImages
{
    for (GTIOProcessImageRequest *processImageRequest in self.processImageRequests) {
        GTIOResizePhotoOperation *resizePhotoOperation = [[GTIOResizePhotoOperation alloc] initWithPhoto:processImageRequest];
        [self.resizeQueue addOperation:resizePhotoOperation];
    }
}

@end
