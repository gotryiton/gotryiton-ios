//
//  GTIOMasonGridItem.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"

@class GTIOMasonGridItem;

@protocol GTIOMasonGridItemDelegate <NSObject>

@required
- (void)didFinishLoadingGridItem:(GTIOMasonGridItem *)gridItem;
- (void)gridItem:(GTIOMasonGridItem *)gridItem didFailToLoadWithError:(NSError *)error;

@end

@interface GTIOMasonGridItem : NSObject <SDWebImageDownloaderDelegate>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<GTIOMasonGridItemDelegate>delegate;

+ (id)itemWithURL:(NSURL *)URL;

@end
