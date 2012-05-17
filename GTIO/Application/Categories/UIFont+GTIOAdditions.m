//
//  UIFont+GTIOAdditions.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIFont+GTIOAdditions.h"

static NSString * const GTIOFontProximaNovaName[] = {
    [GTIOFontProximaNovaRegular] = @"ProximaNova-Regular",
    [GTIOFontProximaNovaLight] = @"ProximaNova-Light",
    [GTIOFontProximaNovaSemiBold] = @"ProximaNova-Semibold",
    [GTIOFontProximaNovaBold] = @"ProximaNova-Bold",
    [GTIOFontProximaNovaThin] = @"ProximaNovaT-Thin"
};

static NSString * const GTIOFontArcherName[] = {
    [GTIOFontArcherBold] = @"Archer-Bold",
    [GTIOFontArcherBook] = @"Archer-Book",
    [GTIOFontArcherMedium] = @"Archer-Medium",
    [GTIOFontArcherSemiBold] = @"Archer-Semibold",
    [GTIOFontArcherLight] = @"Archer-Light"
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

@end
