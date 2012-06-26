//
//  UIFont+GTIOAdditions.h
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

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

+ (CTFontRef)gtio_proximaNovaCoreTextFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size;
+ (CTFontRef)gtio_archerCoreTextFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size;
+ (CTFontRef)gtio_verlagCoreTextFontWithWeight:(GTIOFontVerlag)verlag size:(CGFloat)size;

@end
