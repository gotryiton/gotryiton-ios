//
//  GTIOUIImage.m
//  GTIO
//
//  Created by Simon Holroyd on 9/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//


#import "GTIOUIImage.h"

CGFloat const kGTIOIphoneDefaultScreenHeight = 480.0;

@implementation GTIOUIImage


+ (GTIOUIImage *)imageNamed:(NSString *)name
{
    return (GTIOUIImage *)[super imageNamed:[GTIOUIImage deviceSpecificName:name]];
}


+ (NSURL*)deviceSpecificURL:(NSURL*)url {
    return [NSURL URLWithString:[GTIOUIImage deviceSpecificName:[url absoluteString] forUIImage:NO]];
}

+ (NSString*)deviceSpecificName:(NSString*)name {
    return [GTIOUIImage deviceSpecificName:name forUIImage:YES];
}

+ (NSString*)deviceSpecificName:(NSString*)name forUIImage:(BOOL)forUIImage {
    
    NSError *error = NULL;
    NSString *template = [NSString stringWithFormat:@"%@.$1", [GTIOUIImage retinaImageStringForUIImage:forUIImage]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(png|jpg|jpeg)$" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, [name length]) withTemplate:template];
}

+ (NSString*)retinaImageStringForUIImage:(BOOL)hide2X
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        if([[UIScreen mainScreen] bounds].size.height != kGTIOIphoneDefaultScreenHeight){
            if (!hide2X) {
                return [NSString stringWithFormat:@"-%ih@2x",(int)[[UIScreen mainScreen] bounds].size.height];
            }
            // @2x on iphone 5
            return [NSString stringWithFormat:@"-%ih",(int)[[UIScreen mainScreen] bounds].size.height];
        }
        if (!hide2X) {
            return @"@2x";
        }
    } 
    return @"";
}

@end
