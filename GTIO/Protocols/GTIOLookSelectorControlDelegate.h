//
//  GTIOLookSelectorControlDelegate.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTIOLookSelectorControl;

@protocol GTIOLookSelectorControlDelegate <NSObject>

@required
- (void)lookSelectorControl:(GTIOLookSelectorControl *)lookSelectorControl photoSet:(BOOL)photoSet;

@end