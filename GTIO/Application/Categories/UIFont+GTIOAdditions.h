//
//  UIFont+GTIOAdditions.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

typedef enum GTIOFontProximaNova {
    GTIOFontProximaNovaRegular = 0,
    GTIOFontProximaNovaRegularItal,
    GTIOFontProximaNovaBold,
    GTIOFontProximaNovaBoldItal,
    GTIOFontProximaNovaSemiBold,
    GTIOFontProximaNovaSemiBoldItal,
    GTIOFontProximaNovaLight,
    GTIOFontProximaNovaLightItal,
    GTIOFontProximaNovaThin,
    GTIOFontProximaNovaThinItal
} GTIOFontProximaNova;

typedef enum GTIOFontArcher {
    GTIOFontArcherBold = 0,
    GTIOFontArcherBoldItal,
    GTIOFontArcherBook,
    GTIOFontArcherBookItal,
    GTIOFontArcherLight,
    GTIOFontArcherLightItal,
    GTIOFontArcherMedium,
    GTIOFontArcherMediumItal,
    GTIOFontArcherSemiBold,
    GTIOFontArcherSemiBoldItal,
} GTIOFontArcher;

typedef enum GTIOFontVerlag {
    GTIOFontVerlagBlack = 0,
    GTIOFontVerlagBlackItal,
    GTIOFontVerlagBold,
    GTIOFontVerlagBoldItal,
    GTIOFontVerlagBook,
    GTIOFontVerlagBookItal,
    GTIOFontVerlagLight,
    GTIOFontVerlagLightItal,
    GTIOFontVerlagXLight,
    GTIOFontVerlagXLightItal
} GTIOFontVerlag;

@interface UIFont (GTIOAdditions)

+ (UIFont *)gtio_proximaNovaFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size;
+ (UIFont *)gtio_archerFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size;
+ (UIFont *)gtio_verlagFontWithWeight:(GTIOFontVerlag)verlag size:(CGFloat)size;

@end
