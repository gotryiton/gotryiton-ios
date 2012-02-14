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
            prettyPrice,
            buyUrl,
            smallThumbnail,
            descriptionString;

+ (RKObjectMapping*)productMapping
{
    return [RKObjectMapping mappingForClass:[GTIOProduct class] block:^(RKObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toAttribute:@"productID"];
        [mapping mapAttributes:@"brand", @"productName", @"prettyPrice", @"buyUrl", @"smallThumbnail", nil];
        [mapping mapKeyPath:@"description" toAttribute:@"descriptionString"];
    }];
}

- (void)dealloc
{
    [productID release];
    [brand release];
    [productName release];
    [prettyPrice release];
    [buyUrl release];
    [smallThumbnail release];
    [descriptionString release];
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ - %@",
            [super description],
            [[RKObjectSerializer serializerWithObject:self mapping:[[[GTIOProduct class] productMapping] inverseMapping]] serializedObject:nil]];
}

@end
