//
//  NSMutableDictionary+FilterTypeKeys.m
//  GTIO
//
//  Created by Scott Penrose on 6/14/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "NSMutableDictionary+FilterTypeKeys.h"

@implementation NSMutableDictionary (FilterTypeKeys)

- (id)objectForFilterType:(GTIOFilterType)filterType
{
    NSNumber *wrappedFilterType = [NSNumber numberWithInt:filterType];
    return [self objectForKey:wrappedFilterType];
}

- (void)setObject:(id)object forFilterType:(GTIOFilterType)filterType
{
    NSNumber *wrappedFilterType = [NSNumber numberWithInt:filterType];
    [self setObject:object forKey:wrappedFilterType];
}

@end
