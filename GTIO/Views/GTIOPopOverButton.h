//
//  GTIOPopOverButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

#import "GTIOButton.h"

typedef enum GTIOPopOverButtonPosition {
    GTIOPopOverButtonPositionTop = 0,
    GTIOPopOverButtonPositionMiddle,
    GTIOPopOverButtonPositionBottom,
} GTIOPopOverButtonPosition;

typedef enum GTIOPopOverButtonType {
    GTIOPopOverButtonTypeDot = 0,
    GTIOPopOverButtonTypeSource,
} GTIOPopOverButtonType;

static NSString * const GTIOPopOverButtonPositionButtonName[] = {
    [GTIOPopOverButtonPositionTop] = @"top",
    [GTIOPopOverButtonPositionMiddle] = @"middle",
    [GTIOPopOverButtonPositionBottom] = @"bottom"
};

static NSString * const GTIOPopOverButtonTypeImagePrefix[] = {
    [GTIOPopOverButtonTypeDot] = @"dot-menu",
    [GTIOPopOverButtonTypeSource] = @"source-menu"
};

@interface GTIOPopOverButton : GTIOUIButton

@property (nonatomic, strong) GTIOButton *buttonModel;

+ (id)gtio_popOverButtonWithButtonType:(GTIOPopOverButtonType)buttonType position:(GTIOPopOverButtonPosition)position;

@end
