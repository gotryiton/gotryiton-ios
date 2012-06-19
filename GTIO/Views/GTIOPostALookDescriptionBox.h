//
//  GTIOPostALookDescriptionBox.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOPostALookDescriptionBox;

typedef void(^GTIOTextViewDidEndHandler)(UITextView *textView);
typedef void(^GTIOTextViewDidBecomeActiveHandler)(GTIOPostALookDescriptionBox *textView);

@interface GTIOPostALookDescriptionBox : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) GTIOTextViewDidEndHandler textViewDidEndHandler;
@property (nonatomic, copy) GTIOTextViewDidBecomeActiveHandler textViewDidBecomeActiveHandler;
@property (nonatomic, assign) BOOL forceBecomeFirstResponder;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title icon:(UIImage *)icon nextTextView:(UITextView *)nextTextView;

@end
