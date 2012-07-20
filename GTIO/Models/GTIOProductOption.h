//
//  GTIOProductOption.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/19/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProduct.h"

@interface GTIOProductOption : NSObject

@property (nonatomic, strong) NSNumber *productOptionID;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) GTIOButtonAction *action;

@end