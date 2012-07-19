//
//  GTIOProduct.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProduct.h"
#import <RestKit/RestKit.h>

@implementation GTIOProduct

@synthesize productID = _productID, productName = _productName, buyURL = _buyURL, prettyPrice = _prettyPrice, brands = _brands;
@synthesize photo = _photo, buttons = _buttons, action = _action;

+ (void)loadProductWithProductID:(NSNumber *)productID completionHandler:(GTIOCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%i", productID.intValue] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            if (completionHandler) {
                completionHandler(loadedObjects, nil);
            }
        };
        loader.onDidFailLoadWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

@end
