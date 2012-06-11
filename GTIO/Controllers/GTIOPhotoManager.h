//
//  GTIOPhotoManager.h
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPhotoManager : NSObject

+ (GTIOPhotoManager *)sharedManager;

- (NSInteger)photoCount;
- (NSArray *)thumbnailPhotos;
- (void)addPhoto:(UIImage *)photo;
- (UIImage *)photoAtIndex:(NSInteger)index;
- (void)removeAllPhotos;

- (void)resizeAllImages;

@end
