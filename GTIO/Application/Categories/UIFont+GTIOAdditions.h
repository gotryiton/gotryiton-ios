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
    GTIOFontProximaNovaSemiBold,
    GTIOFontProximaNovaBold,
    GTIOFontProximaNovaThin
} GTIOFontProximaNova;

typedef enum GTIOFontArcher {
    GTIOFontArcherBold = 0,
    GTIOFontArcherBook,
    GTIOFontArcherMedium,
    GTIOFontArcherSemiBold,
    GTIOFontArcherLight
} GTIOFontArcher;

@interface UIFont (GTIOAdditions)

+ (UIFont *)gtio_proximaNovaFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size;
+ (UIFont *)gtio_archerFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size;

@end
