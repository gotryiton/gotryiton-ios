//
//  GTIOImageManager.h
//  GTIO
//
//  Created by Duncan Lewis on 9/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@interface GTIOImageManager : NSObject <SDWebImageManagerDelegate>

@property (nonatomic, assign) NSInteger maxConcurrentDownloads;
@property (nonatomic, assign) BOOL retryFailedDownloads;

/**
 Image URLs that have yet to begin downloading
 */
@property (nonatomic, strong) NSMutableArray *imageURLs;

- (void)queueImageURL:(NSURL *)imageURL;
- (void)queueImageURLs:(NSArray *)imageURLs;

/**
 Sends a image URL to the front of the queue of URL not yet downloaded
 */
- (void)prioritizeImageURL:(NSURL *)imageURL;

@end
