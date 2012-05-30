//
//  GTIODoneToolBar.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIODoneToolBar : UIToolbar

- (id)initWithTarget:(id)target andAction:(SEL)action;
- (void)useNextButtonWithTarget:(id)target andAction:(SEL)action;
- (void)useDoneButtonWithTarget:(id)target andAction:(SEL)action;

@end
