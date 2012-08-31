//
//  GTIOHeartList.h
//  GTIO
//
//  Created by Simon Holroyd on 8/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOPagination.h"

@interface GTIOHeartList : NSObject

@property (nonatomic, strong) NSMutableArray *hearts;
@property (nonatomic, strong) GTIOPagination *pagination;

@end
