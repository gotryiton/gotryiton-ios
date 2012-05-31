//
//  UIFont+GTIOAdditions.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

typedef enum GTIOFontProximaNova {
    GTIOFontProximaNovaRegular = 0,
    GTIOFontProximaNovaLight,
    GTIOFontProximaNovaLightItal,
    GTIOFontProximaNovaSemiBold,
    GTIOFontProximaNovaBold,
    GTIOFontProximaNovaThin
} GTIOFontProximaNova;

typedef enum GTIOFontArcher {
    GTIOFontArcherBold = 0,
    GTIOFontArcherBook,
    GTIOFontArcherMedium,
    GTIOFontArcherMediumItal,
    GTIOFontArcherSemiBold,
    GTIOFontArcherLight,
    GTIOFontArcherLightItal
} GTIOFontArcher;

typedef enum GTIOFontVerlag {
    GTIOFontVerlagBold = 0,
    GTIOFontVerlagBoldItalic,
    GTIOFontVerlagBlack,
    GTIOFontVerlagBlackItalic,
    GTIOFontVerlagBook,
    GTIOFontVerlagBookItalic,
    GTIOFontVerlagLight,
    GTIOFontVerlagLightItalic,
    GTIOFontVerlagXLight,
    GTIOFontVerlagXLightItalic
} GTIOFontVerlag;

@interface UIFont (GTIOAdditions)

+ (UIFont *)gtio_proximaNovaFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size;
+ (UIFont *)gtio_archerFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size;
+ (UIFont *)gtio_verlagFontWithWeight:(GTIOFontVerlag)verlag size:(CGFloat)size;

@end
