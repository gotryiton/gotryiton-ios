//
//  GTIOProcessImageRequest.m
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProcessImageRequest.h"

#import "UIImage+Resize.h"

static NSInteger const kGTIOPhotoResizeWidth = 640;
static CGSize const kGTIOThumbnailSize = { 84, 112 };

@implementation GTIOProcessImageRequest

@synthesize processedImage = _processedImage, rawImage = _rawImage, thumbnail = _thumbnail;

- (UIImage *)processedImage
{
    if (!_processedImage) {
        [self resize];
    }
    return _processedImage;
}

- (void)setRawImage:(UIImage *)rawImage
{
    _rawImage = rawImage;
    [self rendorThumbnail];
}

- (void)rendorThumbnail
{
    UIGraphicsBeginImageContextWithOptions(kGTIOThumbnailSize, NO, [[UIScreen mainScreen] scale]);
    [self.rawImage drawInRect:(CGRect){ CGPointZero, kGTIOThumbnailSize }];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _thumbnail = thumbnail;
}

- (void)resize
{
    if (_processedImage) {
        return;
    }
    
    @synchronized(self) {
        NSLog(@"--Start processing image");       
        _processedImage = [_rawImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:(CGSize){ kGTIOPhotoResizeWidth, CGFLOAT_MAX } interpolationQuality:kCGInterpolationHigh];
        _rawImage = nil;
        NSLog(@"--End processing image");
    };
}

@end
