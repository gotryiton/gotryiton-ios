//
//  GTIOLookSelectorControl.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOLookSelectorControlDelegate.h"

@interface GTIOLookSelectorControl : UIView

@property (nonatomic, unsafe_unretained) id<GTIOLookSelectorControlDelegate> delegate;

@end
