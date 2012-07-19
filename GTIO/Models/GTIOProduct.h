//
//  GTIOProduct.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTIOPhoto.h"

#import "GTIOGridItem.h"

@interface GTIOProduct : NSObject <GTIOGridItem>

@property (nonatomic, strong) NSNumber *productID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, strong) NSURL *buyURL;
@property (nonatomic, copy) NSString *prettyPrice;
@property (nonatomic, copy) NSString *brands;

// Relationships
@property (nonatomic, strong) GTIOButtonAction *action;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) NSArray *buttons;

+ (void)loadProductWithProductID:(NSNumber *)productID completionHandler:(GTIOCompletionHandler)completionHandler;

@end
