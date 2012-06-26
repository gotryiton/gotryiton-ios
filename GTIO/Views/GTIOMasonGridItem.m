//
//  GTIOMasonGridItem.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridItem.h"

@implementation GTIOMasonGridItem

@synthesize URL = _URL, image = _image, delegate = _delegate;

+ (id)itemWithURL:(NSURL *)URL
{
    GTIOMasonGridItem *item = [[GTIOMasonGridItem alloc] init];
    item.URL = URL;
    return item;
}

- (void)downloadImage
{
    [SDWebImageDownloader downloaderWithURL:self.URL delegate:self];
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
