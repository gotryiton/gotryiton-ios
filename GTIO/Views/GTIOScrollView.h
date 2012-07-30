//
//  GTIOScrollView.h
//  GTIO
//
//  Created by Scott Penrose on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOScrollView : UIScrollView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL resizeForKeyboard;
@property (nonatomic, assign) NSInteger offsetFromBottom;
@property (nonatomic, assign, getter = isKeyboardShowing) BOOL keyboardShowing;

@end
