//
//  GTIOActionSheet.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOButton.h"

@class GTIOActionSheet;

typedef void(^GTIOActionSheetBlock)(GTIOActionSheet *actionSheet);
typedef void(^GTIOActionSheetIndexBlock)(GTIOActionSheet *actionSheet, NSUInteger index);

@interface GTIOActionSheet : UIView

- (id)initWithCancelButton:(GTIOButton *)cancelButton otherButtons:(GTIOButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;
- (void)showWithBlock:(GTIOActionSheetBlock)block;

@end