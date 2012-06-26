//
//  GTIOAutoCompleteView.m
//  auto complete stand alone app for GTIOv4
//
//  Created by Simon Holroyd on 6/12/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#import "GTIOAutoCompleteScrollView.h"
#import "GTIOAutoCompleter.h"


@interface GTIOAutoCompleteView : UIView <UITextViewDelegate, GTIOAutoCompleteScrollViewDelegate>


@property (nonatomic, strong) NSMutableArray *autoCompleteArray;
@property (nonatomic, strong) GTIOAutoCompleteScrollView *scrollView;
@property (nonatomic, strong) UIImageView *scrollViewBackground;
@property (nonatomic, strong) NSMutableArray *autoCompleteButtonOptions;
@property (nonatomic, strong) UITextView *textInput;

@property (nonatomic, strong) CATextLayer *previewTextView;
@property (nonatomic, strong) CATextLayer *textView;
@property (nonatomic, strong) NSMutableAttributedString *attrString;


@property (assign) CTFontRef ACInputFont;
@property (assign) CGColorRef ACInputColor;
@property (assign) CTFontRef ACPlaceholderFont;
@property (assign) CGColorRef ACPlaceholderColor;
@property (assign) CTFontRef ACHighlightFont;
@property (assign) CGColorRef ACHighlightColor;

@property (copy) NSString *inputText;
@property (copy) NSString *submissionText;
@property (copy) NSString *dataText;
@property (assign) NSRange positionOfLastWordTyped;
@property (assign) NSRange positionOfLastTwoWordsTyped;

@property (assign) BOOL isScrollViewShowing;

-(UIView *) initWithFrame:(CGRect) frame withOuterBox:(CGRect) outerFrame;

-(void) addCompleters:(NSMutableArray * ) completers;
- (NSString *) processDescriptionString;

@end
