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

@end

@interface GTIOAutoCompleteScrollView : UIScrollView

@property (nonatomic, assign) id<GTIOAutoCompleteScrollViewDelegate> autoCompleteDelegate;

-(void)showButtonsWithAutoCompleters:(NSArray *) buttons;
-(void)clearScrollView;
-(BOOL)touchesShouldCancelInContentView:(UIView *) view;

@end
