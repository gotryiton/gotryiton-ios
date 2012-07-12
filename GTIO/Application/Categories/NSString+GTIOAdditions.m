//
//  NSString+GTIOAdditions.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "NSString+GTIOAdditions.h"

@implementation NSString (GTIOAdditions)

- (NSArray *)rangesOfHTMLBoldedText
{
    NSMutableArray *rangesOfBoldedText = [NSMutableArray array];
    NSString *stringToEdit = [NSString stringWithString:self];
    int locationAdjustment = 0;
    while (TRUE) {
        NSRange rangeOfFirstOpenBoldTag = [stringToEdit rangeOfString:@"<b>" options:NSCaseInsensitiveSearch];
        NSRange rangeOfFirstCloseBoldTag = [stringToEdit rangeOfString:@"</b>" options:NSCaseInsensitiveSearch];
        if (rangeOfFirstOpenBoldTag.length > 0 && rangeOfFirstCloseBoldTag.length > 0) {
            int lengthOfFirstBoldString = rangeOfFirstCloseBoldTag.location - (rangeOfFirstOpenBoldTag.location + rangeOfFirstOpenBoldTag.length);
            if (lengthOfFirstBoldString == 0) {
                return [NSArray arrayWithArray:rangesOfBoldedText];
            }
            int locationOfFirstBoldString = (rangeOfFirstCloseBoldTag.location - lengthOfFirstBoldString) + locationAdjustment;
            NSRange boldTextRange = NSMakeRange(locationOfFirstBoldString, lengthOfFirstBoldString);
            [rangesOfBoldedText addObject:[NSValue valueWithRange:boldTextRange]];
            locationAdjustment += (rangeOfFirstCloseBoldTag.location + rangeOfFirstCloseBoldTag.length);
            stringToEdit = [stringToEdit substringFromIndex:(rangeOfFirstCloseBoldTag.location + rangeOfFirstCloseBoldTag.length)];
        } else {
            break;
        }
    }
    return [NSArray arrayWithArray:rangesOfBoldedText];
}

@end
