//
//  GTIOMasonGridItem.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridItem.h"

@interface GTIOMasonGridItem()

@property (nonatomic, strong) SDWebImageDownloader *imageDownloader;

@end

@implementation GTIOMasonGridItem

@synthesize image = _image, delegate = _delegate, imageDownloader = _imageDownloader;
@synthesize object = _object;

+ (id)itemWithObject:(id<GTIOGridItem>)object
{
    GTIOMasonGridItem *item = [[GTIOMasonGridItem alloc] init];
    item.object = object;
    return item;
}

- (void)downloadImage
{
    self.imageDownloader = [SDWebImageDownloader downloaderWithURL:self.object.photo.smallThumbnailURL delegate:self];
}

- (void)cancelImageDownload
{
    self.imageDownloader.delegate = nil;
    [self.imageDownloader cancel];
}

#pragma mark - SDWebImageDownloaderDelegate

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    self.image = image;
    
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingGridItem:)]) {
        [self.delegate didFinishLoadingGridItem:self];
    }
}

- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(gridItem:didFailToLoadWithError:)]) {
        [self.delegate gridItem:self didFailToLoadWithError:error];
    }
}

@end
