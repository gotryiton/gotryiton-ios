//
//  NSURL+XQueryComponents.m
//  GTIO
//
//  Created by Simon Holroyd on 10/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "NSURL+XQueryComponents.h"

#import "NSString+XQueryComponents.h"

@implementation NSURL (XQueryComponents)

- (NSDictionary*)queryComponents
{
    return [[self query] dictionaryFromQueryComponents];
}

@end
