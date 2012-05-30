//
//  GTIOLookSelectorView.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOLookSelectorControlDelegate.h"

@interface GTIOLookSelectorView : UIView <GTIOLookSelectorControlDelegate>

- (id)initWithFrame:(CGRect)frame asPhotoSet:(BOOL)photoSet;
- (BOOL)selectionsComplete;

@end
