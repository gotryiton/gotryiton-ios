//
//  GTIOProduct.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/3/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProduct.h"

@implementation GTIOProduct

@synthesize productID,
            brand,
            productName,
            price,
            buyUrl,
            thumbnail,
            descriptionString;

+ (RKObjectMapping*)productMapping
{
    return [RKObjectMapping mappingForClass:[GTIOProduct class] block:^(RKObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toAttribute:@"productID"];
        [mapping mapAttributes:@"brand", @"productName", @"price", @"buyUrl", @"thumbnail", nil];
        [mapping mapKeyPath:@"description" toAttribute:@"descriptionString"];
    }];
}

@end
