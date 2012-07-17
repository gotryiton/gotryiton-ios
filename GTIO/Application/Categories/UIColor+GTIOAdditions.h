//
//  UIColor+GTIOAdditions.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

//RGB color macro
//Usage: UIColorFromRGB(0xAE66CC);
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
//Usage: UIColorFromRGBWithAlpha(0xAE66CC, 0.8);
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface UIColor (GTIOAdditions)

+ (UIColor *)gtio_linkColor;
+ (UIColor *)gtio_signInColor;
+ (UIColor *)gtio_toolbarBGColor;
+ (UIColor *)gtio_profilePictureBorderColor;
+ (UIColor *)gtio_pinkTextColor;
+ (UIColor *)gtio_greenBorderColor;
+ (UIColor *)gtio_photoBorderColor;
+ (UIColor *)gtio_progressBarColor;
+ (UIColor *)gtio_groupedTableBorderColor;
+ (UIColor *)gtio_semiTransparentBackgroundColor;
+ (UIColor *)gtio_profileDescriptionTextColor;
+ (UIColor *)gtio_ActionSheetButtonTextColor;
+ (UIColor *)gtio_postReviewCountButtonTextColor;
+ (UIColor *)gtio_findMyFriendsTableCellActiveColor;
+ (UIColor *)gtio_friendsGreenCellColor;
+ (UIColor *)gtio_grayTextColorB7B7B7;
+ (UIColor *)gtio_grayTextColorBCBCBC;
+ (UIColor *)gtio_grayTextColorDCDCDC;
+ (UIColor *)gtio_grayTextColor626262;
+ (UIColor *)gtio_lightGrayBorderColor;
+ (UIColor *)gtio_grayTextColor9C9C9C;
+ (UIColor *)gtio_reallyDarkGrayTextColor;
+ (UIColor *)gtio_lightGrayTextColor;
+ (UIColor *)gtio_grayTextColor404040;
+ (UIColor *)gtio_grayTextColor585858;
+ (UIColor *)gtio_grayTextColorACACAC;
+ (UIColor *)gtio_lightestGrayTextColor;
+ (UIColor *)gtio_grayTextColor;
+ (UIColor *)gtio_darkGray3TextColor;
+ (UIColor *)gtio_grayTextColor555556;

@end
