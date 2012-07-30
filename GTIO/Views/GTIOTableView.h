//
//  GTIOTableView.h
//  GTIO
//
//  Created by Scott Penrose on 7/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOTableView : UITableView

@property (nonatomic, assign) BOOL resizeForKeyboard;
@property (nonatomic, assign) NSInteger offsetFromBottom;
@property (nonatomic, assign, getter = isKeyboardShowing) BOOL keyboardShowing;

@end
