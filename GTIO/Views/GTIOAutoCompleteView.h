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
#import "GTIOCommentViewController.h"

@interface GTIOAutoCompleteView : UIView <UITextViewDelegate, GTIOAutoCompleteScrollViewDelegate>


@property (nonatomic, weak) id<GTIOAutoCompleteViewDelegate> delegate; 

@property (nonatomic, strong) NSMutableArray *autoCompleteArray;
@property (nonatomic, strong) GTIOAutoCompleteScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *autoCompleteButtonOptions;
@property (nonatomic, strong) UITextView *textInput;

@property (nonatomic, strong) UILabel *previewTextView;
@property (nonatomic, strong) NSMutableAttributedString *attrString;

@property (copy) NSString *inputText;
@property (assign) NSRange positionOfCursor;
@property (assign) NSRange positionOfLastWordTyped;
@property (assign) NSRange positionOfLastTwoWordsTyped;

@property (assign) BOOL isScrollViewShowing;
@property (assign) BOOL isTyping;
@property (assign) BOOL preventTyping;

@property (assign) int autoCompleteMatchCharacterCount;
@property (copy) NSString *autoCompleteMode;

@property (nonatomic, strong) NSTimer *searchTextTimer;

- (UIView *)initWithFrame:(CGRect)frame outerBox:(CGRect)outerFrame placeholder:(NSString *)text;
- (void)addCompleters:(NSMutableArray *)completers;
- (NSString *)processDescriptionString;
- (void) showPlaceholderText;
- (void) hidePlaceholderText;
- (void) resetView;
- (void) displayPlaceholderText;
- (BOOL)textView:(UITextView *)field shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)inputString;
- (void)textViewDidChange:(UITextView *)textView;

@end
