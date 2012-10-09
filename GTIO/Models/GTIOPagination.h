//
//  GTIOPagination.h
//  GTIO
//
//  Created by Scott Penrose on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOPagination : NSObject

@property (nonatomic, strong) NSString *previousPage;
@property (nonatomic, strong) NSString *nextPage;

/**
 Use this to keep track when a pagination object is loading its next or previous page
 */
@property (nonatomic, assign) BOOL loading;

@end
