//
//  GTIOBannerImage.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOBannerImage : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) GTIOButtonAction *action;

@end
