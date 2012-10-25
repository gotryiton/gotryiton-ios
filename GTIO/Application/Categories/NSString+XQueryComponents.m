//
//  NSString+XQueryComponents.m
//  GTIO
//
//  Created by Simon Holroyd on 10/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "NSString+XQueryComponents.h"

@implementation NSString (XQueryComponents)

- (NSString*)stringByDecodingURLFormat
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)stringByEncodingURLFormat
{
    static NSString *unsafe = @" <>#%'\";?:@&=+$/,{}|\\^~[]`-*!()";
    CFStringRef resultRef = CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                    (__bridge CFStringRef)self,
                                                                    NULL,
                                                                    (__bridge CFStringRef)unsafe,
                                                                    kCFStringEncodingUTF8 );
    return (__bridge_transfer NSString*)resultRef;
}

- (NSDictionary*)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [ NSMutableDictionary new ];
    for (NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        
        // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        if ( [ keyValuePairArray count ] < 1 )
            continue;
        
        NSString* key   = [keyValuePairArray[0]stringByDecodingURLFormat];
        queryComponents[key] = [NSNull null];

        if ( [ keyValuePairArray count ] < 2 )
            continue;
        
        NSString* value = [keyValuePairArray[1]stringByDecodingURLFormat];
        queryComponents[key] = value;

    }
    return [queryComponents copy];
}

@end