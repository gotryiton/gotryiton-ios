//
//  NSObject_Additions.m
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "NSObject_Additions.h"

@implementation NSObject (GTIOAdditions)

- (id)jsonEncode {
    id<RKParser> parser = [[NSClassFromString(@"RKParserRegistry") sharedRegistry] parserForMIMEType:@"application/json"];
    return [parser stringFromObject:self error:nil];
}

- (id)jsonDecode {
    id<RKParser> parser = [[NSClassFromString(@"RKParserRegistry") sharedRegistry] parserForMIMEType:@"application/json"];
    return [parser objectFromString:self error:nil];
}

@end
