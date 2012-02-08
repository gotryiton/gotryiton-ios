//
//  GTIOProduct.m
//  GTIO
//
//  Created by Jeremy Ellison on 2/3/12.
//  Copyright (c) 2012 Two Toasters, LLC. All rights reserved.
//

#import "GTIOProduct.h"

static NSCache *GTIO_webViewCache = nil;

@implementation GTIOProduct

@synthesize productID,
            brand,
            productName,
            price,
            buyUrl,
            thumbnail,
            descriptionString;

+ (void)initialize {
    if (self == [GTIOProduct class]) {
        GTIO_webViewCache = [[NSCache alloc] init];
        [GTIO_webViewCache setName:@"ProductWebViewCache"];
        [GTIO_webViewCache setEvictsObjectsWithDiscardedContent:YES];
    }
}

+ (RKObjectMapping*)productMapping
{
    return [RKObjectMapping mappingForClass:[GTIOProduct class] block:^(RKObjectMapping *mapping) {
        [mapping mapKeyPath:@"id" toAttribute:@"productID"];
        [mapping mapAttributes:@"brand", @"productName", @"price", @"buyUrl", @"thumbnail", nil];
        [mapping mapKeyPath:@"description" toAttribute:@"descriptionString"];
    }];
}

- (void)dealloc
{
    [productID release];
    [brand release];
    [productName release];
    [price release];
    [buyUrl release];
    [thumbnail release];
    [descriptionString release];
    [super dealloc];
}

+ (void)cacheWebView:(id)webView outfitId:(NSString *)outfitId {
    [GTIO_webViewCache setObject:webView forKey:outfitId];
}

+ (id)cachedWebViewForOutfitId:(NSString *)outfitId { 
    return [GTIO_webViewCache objectForKey:outfitId];
}

@end
