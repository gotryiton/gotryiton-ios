//
//  ACScrollView.h
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/10/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTIOAutoCompleter.h"

@class GTIOAutoCompleteScrollView;

@protocol GTIOAutoCompleteScrollViewDelegate <NSObject>

@optional
- (void)autoCompleterIDSelected:(NSString*)completerID;
- (void)autoCompleterModeSelected:(NSString*)mode;

@end

@interface GTIOAutoCompleteScrollView : UIScrollView

@property (nonatomic, strong) UIView *autoCompleteNav;
@property (nonatomic, strong) UILabel *autoCompleteHelperText;
@property (assign) BOOL isScrollViewNavShowing;


@property (nonatomic, assign) id<GTIOAutoCompleteScrollViewDelegate> autoCompleteDelegate;

- (void)showButtonsWithAutoCompleters:(NSArray *)buttons;
- (void)clearScrollView;
- (void)showScrollViewNav;
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;
- (void)showPromptTextForMode:(NSString *)mode;

@end
