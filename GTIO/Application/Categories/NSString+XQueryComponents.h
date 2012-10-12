//
//  NSString+XQueryComponents.h
//  GTIO
//
//  Created by Simon Holroyd on 10/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XQueryComponents)

-(NSString*)stringByDecodingURLFormat;
-(NSString*)stringByEncodingURLFormat;
-(NSDictionary*)dictionaryFromQueryComponents;

@end
