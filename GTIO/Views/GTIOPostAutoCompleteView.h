//
//  GTIOPostAutoCompleteView.h
//  GTIO
//
//  Created by Scott Penrose on 6/26/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAutoCompleteView.h"

@class GTIOPostAutoCompleteView;

typedef void(^GTIOTextViewDidEndHandler)(GTIOPostAutoCompleteView *descriptionBox, BOOL scrollToTop);
typedef void(^GTIOTextViewWillBecomeActiveHandler)(GTIOPostAutoCompleteView *descriptionBox);
typedef void(^GTIOTextViewDidBecomeActiveHandler)(GTIOPostAutoCompleteView *descriptionBox);

@interface GTIOPostAutoCompleteView : GTIOAutoCompleteView

@property (nonatomic, copy) GTIOTextViewDidEndHandler textViewDidEndHandler;
@property (nonatomic, copy) GTIOTextViewWillBecomeActiveHandler textViewWillBecomeActiveHandler;
@property (nonatomic, copy) GTIOTextViewDidBecomeActiveHandler textViewDidBecomeActiveHandler;
@property (nonatomic, assign) BOOL forceBecomeFirstResponder;

@property (nonatomic, strong) UIView *placeHolderLabelView;


- (id)initWithFrame:(CGRect)frame outerBox:(CGRect) outerFrame title:(NSString *)title icon:(UIImage *)icon;

@end
