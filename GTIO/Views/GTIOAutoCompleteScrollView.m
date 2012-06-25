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
        
        self.canCancelContentTouches = YES;
        self.userInteractionEnabled = YES;
        self.delaysContentTouches = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.exclusiveTouch = NO;
    }
    return self;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view { 
    return ![view isKindOfClass:[UISlider class]]; 
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{   
    NSLog(@"hi");
  // If not dragging, send event to next responder
  if (!self.dragging) 
    [self.nextResponder touchesEnded: touches withEvent:event]; 
  else
    [super touchesEnded: touches withEvent: event];
}



#pragma mark UIScrollView methods

- (void) clearScrollView {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[GTIOAutoCompleteButton class]])
            [view removeFromSuperview];
    }
    [self setContentSize:CGSizeMake( 0, 50 )];
    
}



- (void) showButtonsWithAutoCompleters:(NSArray *) buttons {
        
    [self clearScrollView];
    
    [self addButtonOptionsToScrollViewWithAutoCompleters:buttons];
       
}



- (void) addButtonOptionsToScrollViewWithAutoCompleters:(NSArray *) buttons{
    
    int btnWidth = 5;
    int i = 0;
    
    for (GTIOAutoCompleter *option in buttons){
        
        

        GTIOAutoCompleteButton *optionButton = [[GTIOAutoCompleteButton alloc] initWithFrame:(CGRect){ btnWidth,11,30,34 } tapHandler:^(id sender) {
            NSLog(@"touch!!");
            [self AutoCompleterButtonTouched:((GTIOAutoCompleteButton *)sender)];
        } withCompleter:option];

        [optionButton addTarget:self action:@selector(AutoCompleterButtonTouched:) forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:optionButton];
        
        btnWidth += CGRectGetWidth(optionButton.frame) + 5;
        
        [self setContentSize:CGSizeMake( btnWidth, 50 )];

        i++;
    }
            
}

#pragma mark - Buttons

- (void)AutoCompleterButtonTouched:(GTIOAutoCompleteButton* )button
{
    GTIOAutoCompleter* completer = button.completer;
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleterIdSelected:)]) {
        
        [self.autoCompleteDelegate autoCompleterIdSelected:completer.completer_id];
    }
    
    [self clearScrollView];
}



@end
