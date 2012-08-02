//
//  GTIODoneToolBar.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIODoneToolBar.h"

@interface GTIODoneToolBar()

@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@end

@implementation GTIODoneToolBar

@synthesize flexibleSpace = _flexibleSpace, doneButton = _doneButton, nextButton = _nextButton;

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        [self setBarStyle:UIBarStyleBlack];
        [self setTranslucent:YES];
        [self setTintColor:nil];
        [self sizeToFit];
        self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:target action:action];
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:target action:action];
        [self setItems:[NSArray arrayWithObjects:self.flexibleSpace, self.doneButton, nil]];
    }
    return self;
}

- (void)useNextButtonWithTarget:(id)target action:(SEL)action
{
    [self.nextButton setTarget:target];
    [self.nextButton setAction:action];
    [self setItems:[NSArray arrayWithObjects:self.flexibleSpace, self.nextButton, nil]];
}

- (void)useDoneButtonWithTarget:(id)target action:(SEL)action
{
    [self.doneButton setTarget:target];
    [self.doneButton setAction:action];
    [self setItems:[NSArray arrayWithObjects:self.flexibleSpace, self.doneButton, nil]];
}

- (void)useNextAndDoneButtonWithTarget:(id)target doneAction:(SEL)doneAction nextAction:(SEL)nextAction
{
    [self.nextButton setTarget:target];
    [self.nextButton setAction:nextAction];
    [self.doneButton setTarget:target];
    [self.doneButton setAction:doneAction];
    [self setItems:[NSArray arrayWithObjects: self.doneButton, self.flexibleSpace, self.nextButton, nil]];
}


@end
