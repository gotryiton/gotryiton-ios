//
//  GTIOToolBarButton.h
//  GTIO
//
//  Created by Scott Penrose on 7/13/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOUIButton.h"

typedef enum GTIOToolBarButtonType {
    GTIOToolBarButtonTypeBack = 0,
    GTIOToolBarButtonTypeForward,
    GTIOToolBarButtonTypeReload,
    GTIOToolBarButtonTypeAction
} GTIOToolBarButtonType;

static NSString * const GTIOToolBarButtonName[] = {
    [GTIOToolBarButtonTypeBack] = @"back",
    [GTIOToolBarButtonTypeForward] = @"forward",
    [GTIOToolBarButtonTypeReload] = @"reload",
    [GTIOToolBarButtonTypeAction] = @"options",
};

@interface GTIOToolBarButton : UIBarButtonItem

+ (id)buttonWithToolBarButtonType:(GTIOToolBarButtonType)toolBarButtonType tapHandler:(GTIOButtonDidTapHandler)tapHandler;

@end
