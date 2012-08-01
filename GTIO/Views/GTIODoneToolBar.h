//
//  GTIODoneToolBar.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIODoneToolBar : UIToolbar

- (id)initWithTarget:(id)target action:(SEL)action;
- (void)useNextButtonWithTarget:(id)target action:(SEL)action;
- (void)useDoneButtonWithTarget:(id)target action:(SEL)action;
- (void)useNextAndDoneButtonWithTarget:(id)target doneAction:(SEL)doneAction nextAction:(SEL)nextAction;

@end
