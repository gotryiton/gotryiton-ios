//
//  GTIOPostList.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/21/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOPagination.h"

@interface GTIOPostList : NSObject

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) GTIOPagination *pagination;

@end