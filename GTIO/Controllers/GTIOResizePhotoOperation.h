//
//  GTIOResizePhotoOperation.h
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOProcessImageRequest.h"

@interface GTIOResizePhotoOperation : NSOperation

@property (nonatomic, strong) GTIOProcessImageRequest *processImageRequest;

- (id)initWithPhoto:(GTIOProcessImageRequest *)processImageRequest;

@end
