//
//  GTIOImageManager.m
//  GTIO
//
//  Created by Duncan Lewis on 9/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOImageManager.h"

@interface GTIOImageManager()

@property (nonatomic, strong) NSMutableArray *downloadQueue;

@end

@implementation GTIOImageManager

- (id)init
{
    self = [super init];
    if(self) {
        _maxConcurrentDownloads = 3;
        _retryFailedDownloads = NO;
        
        _imageURLs = [NSMutableArray array];
        _downloadQueue = [NSMutableArray array];
    }
    return self;
}

- (void)queueImageURL:(NSURL *)imageURL
{
    // don't add duplicates
    if([self findDuplicateURL:imageURL] != nil) {
        return;
    }
    
    [self.imageURLs addObject:imageURL];
    [self downloadNextImage];
}

- (void)queueImageURLs:(NSArray *)imageURLs
{
    // check array is of NSURL's
    for (id obj in imageURLs) {
        if([obj isKindOfClass:[NSURL class]]) {
            [self queueImageURL:(NSURL *)obj];
        }
    }
}

// doesn't currently take into account url's that might be
// in the download queue
- (void)prioritizeImageURL:(NSURL *)imageURL
{
    NSURL *existingURL = [self findDuplicateURL:imageURL];
    if(existingURL == nil) {
        [self.imageURLs insertObject:imageURL atIndex:0];
    } else {
        [self.imageURLs removeObject:existingURL];
        [self.imageURLs insertObject:existingURL atIndex:0];
    }
}

#pragma mark - Utility methods

/**
 Returns a NSURL object living in self.imageURLs if a duplicate exists
 Returns nil otherwise
 */
- (NSURL *)findDuplicateURL:(NSURL *)testURL
{
    for(NSURL *URL in self.imageURLs) {
        if([[URL absoluteString] isEqualToString:[testURL absoluteString]]) {
            return URL;
        }
    }
    return nil;
}

- (void)downloadNextImage
{
    if([self.downloadQueue count] < self.maxConcurrentDownloads && [self.imageURLs count] > 0) {
        NSURL *URL = [self.imageURLs objectAtIndex:0];
        [self.imageURLs removeObject:URL];
        [self.downloadQueue addObject:URL];
//        NSLog(@"downloading image at: %@", [URL absoluteString]);
        [[SDWebImageManager sharedManager] downloadWithURL:URL delegate:self];
    }
}

#pragma mark - SDWebImageManagerDelegate methods

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url
{
//    NSLog(@"downloaded image at: %@", [url absoluteString]);
    [self.downloadQueue removeObject:url];
    [self downloadNextImage];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error forURL:(NSURL *)url
{
//    NSLog(@"failed to download image: %@", [url absoluteString]);
    [self.downloadQueue removeObject:url];
    [self downloadNextImage];
}

@end