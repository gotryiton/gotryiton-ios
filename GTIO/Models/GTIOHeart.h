//
//  GTIOHeart.h
//  GTIO
//
//  Created by Simon Holroyd on 8/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTIOGridItem.h"
#import "GTIOPhoto.h"
#import "GTIOProduct.h"
#import "GTIOPost.h"

@interface GTIOHeart : NSObject <GTIOGridItem>

@property (nonatomic, strong) NSNumber *heartID;
@property (nonatomic, strong) GTIOPost *post;
@property (nonatomic, strong) GTIOProduct *product;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) GTIOButtonAction *action;


@end
