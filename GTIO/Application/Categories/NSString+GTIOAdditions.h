//
//  NSString+GTIOAdditions.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GTIOAdditions)

- (NSArray *)rangesOfHTMLBoldedText;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

@end
