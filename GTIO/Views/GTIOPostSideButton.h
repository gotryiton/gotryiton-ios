//
//  GTIOPostSideButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/27/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

typedef enum GTIOPostSideButtonType {
    GTIOPostSideButtonTypeDotDotDot = 0,
    GTIOPostSideButtonTypeShopping,
    GTIOPostSideButtonTypeReview,
} GTIOPostSideButtonType;

static NSString * const GTIOPostSideButtonTypeName[] = {
    [GTIOPostSideButtonTypeReview] = @"review",
    [GTIOPostSideButtonTypeDotDotDot] = @"dot",
    [GTIOPostSideButtonTypeShopping] = @"shopbag"
};

@interface GTIOPostSideButton : GTIOUIButton

+ (id)gtio_postSideButtonType:(GTIOPostSideButtonType)postSideButton tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
