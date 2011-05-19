//
//  NSObject_Additions.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "NSObject_Additions.h"
// TODO: figure out how to get at this without all tthe warnings.
@class RKParserRegistry;

@implementation NSObject (GTIOAdditions)

- (id)jsonEncode {
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:@"application/json"];
    return [parser stringFromObject:self error:nil];
}

@end
