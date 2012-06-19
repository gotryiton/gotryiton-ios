//
//  NSMutableDictionary+FilterTypeKeys.h
//  GTIO
//
//  Created by Scott Penrose on 6/14/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFilter.h"

@interface NSMutableDictionary (FilterTypeKeys)

- (id)objectForFilterType:(GTIOFilterType)filterType;
- (void)setObject:(id)object forFilterType:(GTIOFilterType)filterType;

@end
