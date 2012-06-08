//
//  GTIOProcessImageRequest.h
//  GTIO
//
//  Created by Scott Penrose on 6/7/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOProcessImageRequest : NSObject

@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, strong, readonly) UIImage *processedImage;
@property (nonatomic, strong, readonly) UIImage *thumbnail;

- (void)resize;

@end
