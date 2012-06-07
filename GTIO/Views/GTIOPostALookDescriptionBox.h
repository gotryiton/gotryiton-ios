//
//  GTIOPostALookDescriptionBox.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIOTextViewDidEndHandler)(UITextView *textView);

@interface GTIOPostALookDescriptionBox : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) GTIOTextViewDidEndHandler textViewDidEndHandler;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon nextTextView:(UITextView *)nextTextView;

@end
