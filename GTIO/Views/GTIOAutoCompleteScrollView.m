//
//  ACScrollView.m
//  WebViewDemo
//
//  Created by Simon Holroyd on 6/10/12.
//  Copyright (c) 2012 GO TRY IT ON. All rights reserved.
//

#import "GTIOAutoCompleteScrollView.h"

#import "GTIOAutoCompleteButton.h"

@implementation GTIOAutoCompleteScrollView

@synthesize autoCompleteDelegate = _autoCompleteDelegate;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    	self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    return self;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view { 
    return ![view isKindOfClass:[UISlider class]]; 
}



#pragma mark UIScrollView methods

- (void) clearScrollView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setContentSize:CGSizeMake( 0, 45 )];
    
}

- (void) hideScrollView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.65];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    

    [self setFrame:(CGRect){ 0, 205, 420, 45 }];
    
    [UIView commitAnimations];
    
    [self clearScrollView];
    
    [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        [self setFrame:(CGRect){ 0, 205, 420, 45 }];
    } completion:^(BOOL finished) {
        [self clearScrollView];
    }];
}



- (void) showButtonsWithAutoCompleters:(NSArray *) buttons {
        
    [self clearScrollView];
    
    [self addButtonOptionsToScrollViewWithAutoCompleters:buttons];
    
    
    self.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    
    if (buttons.count>0) {
        
        [self setFrame:(CGRect){ 0, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) }];
        
    }
    else {
        [self setFrame:(CGRect){ 0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(self.frame) + CGRectGetHeight(self.frame) }];
        
    }
    
    [UIView commitAnimations];
    
       
}



- (void) addButtonOptionsToScrollViewWithAutoCompleters:(NSArray *) buttons{
    
    int btnWidth = 0;
    int i = 0;
    
    for (GTIOAutoCompleter *option in buttons){
        NSLog(@"show button: %@", option.name);
        GTIOAutoCompleteButton *optionButton = [[GTIOAutoCompleteButton alloc] initWithFrame:(CGRect){ btnWidth,0,30,45 } withCompleter:option];

        [optionButton setTapHandler:^(id sender) {
            [self AutoCompleterButtonTouched:((GTIOAutoCompleteButton *)sender).completer];
        }];

        [self addSubview:optionButton];
        btnWidth += CGRectGetWidth(optionButton.frame);
        i++;
    }
            
}

#pragma mark - Buttons

- (void)AutoCompleterButtonTouched:(GTIOAutoCompleter* )completer
{
    NSLog(@"tap on button %@", completer.name);
    // if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleterIdSelected:)]) {



    //     // [self.autoCompleteDelegate autoCompleterIdSelected:((GTIOAutoCompleteButton *)sender).tag];
    // }
    
    // [self hideScrollView];
}



@end
