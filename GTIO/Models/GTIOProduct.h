//
//  GTIOProduct.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOPhoto.h"

@interface GTIOProduct : NSObject

@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, strong) NSURL *buyURL;
@property (nonatomic, copy) NSString *prettyPrice;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, copy) NSString *brands;
@property (nonatomic, strong) NSArray *buttons;

+ (void)loadProductWithProductID:(NSNumber *)productID completionHandler:(GTIOCompletionHandler)completionHandler;

@end
