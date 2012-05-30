//
//  UIColor+GTIOAdditions.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIColor+GTIOAdditions.h"

@implementation UIColor (GTIOAdditions)

+ (UIColor *)gtio_linkColor
{
    return UIColorFromRGB(0xFF6A72);
}

+ (UIColor *)gtio_signInColor
{
    return UIColorFromRGB(0x8F8F8F);
}

+ (UIColor *)gtio_lightGrayBorderColor
{
    return UIColorFromRGB(0xE6E6E6);
}

+ (UIColor *)gtio_darkGrayTextColor
{
    return UIColorFromRGB(0xA0A0A0);
}

+ (UIColor *)gtio_reallyDarkGrayTextColor
{
    return UIColorFromRGB(0x515152);
}

+ (UIColor *)gtio_photoBorderColor
{
    return UIColorFromRGB(0xCCCBC6);
}

+ (UIColor *)gtio_profilePictureBorderColor
{
    return UIColorFromRGB(0xF3F3F3);
}

+ (UIColor *)gtio_pinkTextColor
{
    return UIColorFromRGB(0xFF8285);
}

+ (UIColor *)gtio_greenBorderColor
{
    return UIColorFromRGB(0xB2EED6);
}

@end
