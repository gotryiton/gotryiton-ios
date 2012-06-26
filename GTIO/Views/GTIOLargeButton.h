//
//  GTIOLargeButton.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

typedef enum GTIOLargeButtonStyle {
    GTIOLargeButtonStyleGray = 0,
    GTIOLargeButtonStyleGreen,
    GTIOLargeButtonStyleRed
} GTIOLargeButtonStyle;

@interface GTIOLargeButton : GTIOUIButton

+ (id)largeButtonWithGTIOStyle:(GTIOLargeButtonStyle)largeButtonStyle;
+ (id)gtio_largeCancelButton;

@end
