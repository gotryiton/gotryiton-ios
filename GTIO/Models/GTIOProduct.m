//
//  GTIOProduct.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProduct.h"
#import "GTIOButton.h"
#import <RestKit/RestKit.h>

@implementation GTIOProduct

@synthesize productID = _productID, productName = _productName, buyURL = _buyURL, prettyPrice = _prettyPrice, photo = _photo, brands = _brands, buttons = _buttons, hearted = _hearted;

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

+ (void)emailProductWithProductID:(NSNumber *)productID completionHandler:(GTIOCompletionHandler)completionHandler
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/product/%i/email-to-me", productID.intValue] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObjects = ^(NSArray *loadedObjects) {
            if (completionHandler) {
                completionHandler(loadedObjects, nil);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
}

- (void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    
    for (GTIOButton *button in _buttons) {
        if ([button.name isEqualToString:kGTIOProductHeartButton]) {
            self.hearted = button.state.boolValue;
        }
    }
}

@end
