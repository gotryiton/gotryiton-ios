//
//  GTIOResizePhotoOperation.m
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOResizePhotoOperation.h"

@implementation GTIOResizePhotoOperation

@synthesize processImageRequest = _processImageRequest;

- (id)initWithPhoto:(GTIOProcessImageRequest *)processImageRequest
{
    self = [super init];
    if (self) {
        _processImageRequest = processImageRequest;
    }
    return self;
}

- (void)main 
{        
    [self.processImageRequest resize];
}

@end
