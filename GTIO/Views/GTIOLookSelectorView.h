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
@property (nonatomic, assign) BOOL isPhotoSet;

- (id)initWithFrame:(CGRect)frame asPhotoSet:(BOOL)photoSet;
- (void)setDeleteButtonsHidden:(BOOL)hidden;
- (BOOL)selectionsComplete;
- (UIView *)getCompositeCanvas;

@end
