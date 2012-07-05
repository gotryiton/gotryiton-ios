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

static NSString * const GTIOPopOverButtonPositionButtonName[] = {
    [GTIOPopOverButtonPositionTop] = @"top",
    [GTIOPopOverButtonPositionMiddle] = @"middle",
    [GTIOPopOverButtonPositionBottom] = @"bottom"
};

@interface GTIOPopOverButton : GTIOUIButton

@property (nonatomic, strong) GTIOButton *buttonModel;

+ (id)gtio_popOverButtonWithPosition:(GTIOPopOverButtonPosition)position;

@end
