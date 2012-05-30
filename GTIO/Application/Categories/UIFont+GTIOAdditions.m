//
//  UIFont+GTIOAdditions.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIFont+GTIOAdditions.h"

static NSString * const GTIOFontProximaNovaName[] = {
    [GTIOFontProximaNovaBold] = @"ProximaNova-Bold",
    [GTIOFontProximaNovaBoldItal] = @"ProximaNova-BoldIt",
    [GTIOFontProximaNovaLight] = @"ProximaNova-Light",
    [GTIOFontProximaNovaLightItal] = @"ProximaNova-LightIt",
    [GTIOFontProximaNovaRegular] = @"ProximaNova-Regular",
    [GTIOFontProximaNovaRegularItal] = @"ProximaNova-RegularIt",
    [GTIOFontProximaNovaSemiBold] = @"ProximaNova-Semibold",
    [GTIOFontProximaNovaSemiBoldItal] = @"ProximaNova-SemiboldIt",
    [GTIOFontProximaNovaThinItal] = @"ProximaNovaT-ThinIt",
    [GTIOFontProximaNovaThin] = @"ProximaNovaT-Thin"
};

static NSString * const GTIOFontArcherName[] = {
    [GTIOFontArcherBold] = @"Archer-Bold",
    [GTIOFontArcherBoldItal] = @"Archer-BoldItalic",
    [GTIOFontArcherBook] = @"Archer-Book",
    [GTIOFontArcherBookItal] = @"Archer-BookItalic",
    [GTIOFontArcherLight] = @"Archer-Light",
    [GTIOFontArcherLightItal] = @"Archer-LightItalic",
    [GTIOFontArcherMedium] = @"Archer-Medium",
    [GTIOFontArcherMediumItal] = @"Archer-MediumItalic",
    [GTIOFontArcherSemiBold] = @"Archer-Semibold",
    [GTIOFontArcherSemiBoldItal] = @"Archer-SemiboldItalic"
};

static NSString * const GTIOFontVerlagName[] = {
    [GTIOFontVerlagBlack] = @"Verlag-Black",
    [GTIOFontVerlagBlackItal] = @"Verlag-BlackItalic",
    [GTIOFontVerlagBold] = @"Verlag-Bold",
    [GTIOFontVerlagBoldItal] = @"Verlag-BoldItalic",
    [GTIOFontVerlagBook] = @"Verlag-Book",
    [GTIOFontVerlagBookItal] = @"Verlag-BookItalic",
    [GTIOFontVerlagLight] = @"Verlag-Light",
    [GTIOFontVerlagLightItal] = @"Verlag-LightItalic",
    [GTIOFontVerlagXLight] = @"Verlag-XLight",
    [GTIOFontVerlagXLightItal] = @"Verlag-XLightItalic"
};

@implementation UIFont (GTIOAdditions)

+ (UIFont *)gtio_proximaNovaFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size
{
    return [UIFont fontWithName:GTIOFontProximaNovaName[proximaNova] size:size];
}

+ (UIFont *)gtio_archerFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size
{
    return [UIFont fontWithName:GTIOFontArcherName[archer] size:size];
}

+ (UIFont *)gtio_verlagFontWithWeight:(GTIOFontVerlag)verlag size:(CGFloat)size
{
    return [UIFont fontWithName:GTIOFontVerlagName[verlag] size:size];
}

@end
