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

@property (nonatomic, assign) CGSize photoCanvasSize;
@property (nonatomic, assign) BOOL photoSet;

- (id)initWithFrame:(CGRect)frame photoSet:(BOOL)photoSet;
- (void)hideDeleteButtons:(BOOL)hidden;
- (BOOL)selectionsComplete;
- (UIView *)compositeCanvas;

@end
