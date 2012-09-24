//
//  GTIOUIImage.m
//  GTIO
//
//  Created by Simon Holroyd on 9/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//


#import "GTIOUIImage.h"


@implementation GTIOUIImage


+ (GTIOUIImage *)imageNamed:(NSString *)name
{
    GTIOUIImage *image = [[GTIOUIImage alloc] init];
    NSString *newName = [image deviceSpecificName:name];
    GTIOUIImage *response = (GTIOUIImage *)[super imageNamed:newName];
    
    return response;
}


- (NSString*)deviceSpecificName:(NSString*)name {
    
    NSError *error = NULL;
    NSString *template = [NSString stringWithFormat:@"%@.$1", [self retinaImageString]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(png|jpg|jpeg)$" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, [name length]) withTemplate:template];
}

- (NSString*)retinaImageString
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        if([[UIScreen mainScreen] bounds].size.height != 480.0){
            // @2x on iphone 5
            return [NSString stringWithFormat:@"-%ih",(int)[[UIScreen mainScreen] bounds].size.height];
        }
    } 
    return @"";
}

@end
