//
//  GTIODoneToolBar.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIODoneToolBar.h"

@implementation GTIODoneToolBar

- (id)initWithTarget:(id)target andAction:(SEL)action
{
    self = [super init];
    if (self) {
        [self setBarStyle:UIBarStyleBlack];
        [self setTranslucent:YES];
        [self setTintColor:nil];
        [self sizeToFit];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:target action:action];
        [self setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    }
    return self;
}

@end
