//
//  GTIOCollection.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOBannerImage.h"

@interface GTIOCollection : NSObject

@property (nonatomic, strong) NSNumber *collectionID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) GTIOBannerImage *bannerImage;
@property (nonatomic, copy) NSURL *customNavigationImageURL;
@property (nonatomic, strong) NSArray *dotOptions;
@property (nonatomic, copy) NSString *footerText;

@end
