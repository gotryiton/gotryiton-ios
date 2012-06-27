//
//  GTIOPostALookDescriptionBox.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostAutoCompleteView.h"

@interface GTIOPostALookDescriptionBox : UIView <UITextViewDelegate>

@property (nonatomic, strong) GTIOPostAutoCompleteView *textView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon;

@end
