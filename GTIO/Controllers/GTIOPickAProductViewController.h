//
//  GTIOPickAProductViewController.h
//  GTIO
//
//  Created by Scott Penrose on 7/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOViewController.h"

#import "GTIOProduct.h"

typedef enum GTIOProductType {
    GTIOProductTypeHearted = 0,
    GTIOProductTypePopular
} GTIOProductType;

typedef void(^GTIOPickAProductDidSelectProductHandler)(GTIOProduct *product);

@interface GTIOPickAProductViewController : GTIOViewController

@property (nonatomic, assign) GTIOProductType startingProductType;
@property (nonatomic, copy) GTIOPickAProductDidSelectProductHandler didSelectProductHandler;

@end
