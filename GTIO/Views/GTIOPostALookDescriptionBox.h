//
//  GTIOPostALookDescriptionBox.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTIOPostALookDescriptionBox : UIView <UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andIcon:(UIImage *)icon;

@end
