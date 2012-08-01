//
//  GTIOButtonAction.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOButtonAction.h"

@implementation GTIOButtonAction

+ (id)buttonActionWithDestination:(NSString *)destination
{
    GTIOButtonAction *buttonAction = [[self alloc] init];
    buttonAction.destination = destination;
    return buttonAction;
}

@end
