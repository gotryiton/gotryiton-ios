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
    return [self gtio_pinkTextColor];
}

+ (UIColor *)gtio_signInColor
{
    return [self gtio_grayTextColor];
}

+ (UIColor *)gtio_toolbarBGColor
{
    return UIColorFromRGB(0xF0F0F0);
}

+ (UIColor *)gtio_lightGrayBorderColor
{
    return UIColorFromRGB(0xE6E6E6);
}

+ (UIColor *)gtio_grayTextColor
{
    return UIColorFromRGB(0x8F8F8F);
}

+ (UIColor *)gtio_darkGrayTextColor
{
    return UIColorFromRGB(0x9C9C9C);
}

+ (UIColor *)gtio_reallyDarkGrayTextColor
{
    return UIColorFromRGB(0x515152);
}

+ (UIColor *)gtio_darkGray3TextColor 
{
    return UIColorFromRGB(0x232323);
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
    return UIColorFromRGB(0xFF6A72);
}

+ (UIColor *)gtio_greenBorderColor
{
    return UIColorFromRGB(0xB2EED6);
}

+ (UIColor *)gtio_progressBarColor
{
    return UIColorFromRGB(0x5EE4B7);
}

+ (UIColor *)gtio_lightGrayTextColor
{
    return UIColorFromRGB(0xB3B3B3);
}

+ (UIColor *)gtio_groupedTableBorderColor
{
    return UIColorFromRGB(0xD9D7CE);
}

+ (UIColor *)gtio_lightestGrayTextColor
{
    return UIColorFromRGB(0xDADADA);
}

+ (UIColor *)gtio_404040GrayTextColor
{
    return UIColorFromRGB(0x404040);
}

+ (UIColor *)gtio_grayTextColor585858
{
    return UIColorFromRGB(0x585858);
}

+ (UIColor *)gtio_grayTextColorACACAC
{
    return UIColorFromRGB(0xACACAC);
}

+ (UIColor *)gtio_profileDescriptionTextColor
{
    return UIColorFromRGB(0xBABABA);
}

+ (UIColor *)gtio_ActionSheetButtonTextColor
{
    return UIColorFromRGB(0x555556);
}

+ (UIColor *)gtio_semiTransparentBackgroundColor
{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.22];
}

+ (UIColor *)gtio_postReviewCountButtonTextColor
{
    // R: 143, G: 204, B: 177
    return UIColorFromRGB(0x8FCCB1);
}

+ (UIColor *)gtio_findMyFriendsTableCellActiveColor
{
    return UIColorFromRGB(0xEDEBE0);
}

+ (UIColor *)gtio_friendsGreenCellColor
{
    return UIColorFromRGB(0xEBF2EF);
}

@end
