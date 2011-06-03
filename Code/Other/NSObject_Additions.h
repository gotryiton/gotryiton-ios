//
//  NSObject_Additions.h
//  GTIO
//
//  Created by Jeremy Ellison on 5/19/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// NSObject+Additions provides helper method to serialize a NSObject in JSON with RestKit
#import <Foundation/Foundation.h>


@interface NSObject (GTIOAdditions)
/// encode object in json using RKParser
- (id)jsonEncode;

@end

@interface NSString (JSONDecode)

- (id)jsonDecode;

@end