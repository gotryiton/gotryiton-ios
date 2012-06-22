//
//  UIFont+GTIOAdditions.m
//  GTIO
//
//  Created by Scott Penrose on 5/16/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "UIFont+GTIOAdditions.h"

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

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
    [GTIOFontVerlagBold] = @"Verlag-Bold",
    [GTIOFontVerlagBoldItalic] = @"Verlag-BoldItalic",
    [GTIOFontVerlagBlack] = @"Verlag-Black",
    [GTIOFontVerlagBlackItalic] = @"Verlag-BlackItalic",
    [GTIOFontVerlagBook] = @"Verlag-Book",
    [GTIOFontVerlagBookItalic] = @"Verlag-BookItalic",
    [GTIOFontVerlagLight] = @"Verlag-Light",
    [GTIOFontVerlagLightItalic] = @"Verlag-LightItalic",
    [GTIOFontVerlagXLight] = @"Verlag-XLight",
    [GTIOFontVerlagXLightItalic] = @"Verlag-XLightItalic"
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


+ (CTFontRef)gtio_proximaNovaCoreTextFontWithWeight:(GTIOFontProximaNova)proximaNova size:(CGFloat)size
{
    return [self newCustomFontWithName:GTIOFontProximaNovaName[proximaNova] 
        ofType: @"otf"
        size:size];
}

+ (CTFontRef)gtio_archerCoreTextFontWithWeight:(GTIOFontArcher)archer size:(CGFloat)size
{
    return [self newCustomFontWithName:GTIOFontArcherName[archer] 
        ofType: @"otf"
        size:size];
}


+ (CTFontRef)gtio_verlagCoreTextFontWithWeight:(GTIOFontVerlag)verlag size:(CGFloat)size
{
    return [self newCustomFontWithName:GTIOFontVerlagName[verlag] 
        ofType: @"otf"
        size:size];
}



/// custom font loading for CoreText
+ (CTFontRef)newCustomFontWithName:(NSString *)fontName
                            ofType:(NSString *)type
                        size:(CGFloat)size
{

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat: size] 
        forKey:(NSString *)kCTFontSizeAttribute];

    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];

    NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
    CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);


    CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
    CGDataProviderRelease(fontProvider);

    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attributes);
    CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
    CFRelease(fontDescriptor);
    CGFontRelease(cgFont);
    return font;
}

@end
