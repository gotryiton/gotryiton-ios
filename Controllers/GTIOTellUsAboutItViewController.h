//
//  GTIOTellUsAboutItViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/31/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"
#import <TWTCommon/TWTPickerControl.h>

@interface GTIOTellUsAboutItViewController : GTIOTableViewController <UITextViewDelegate, TWTPickerDelegate, TTTextEditorDelegate> {
	GTIOOpinionRequest* _opinionRequest;
	TWTPickerControl* _whereYouAreGoingPicker;
	TTTextEditor* _tellUsMoreAboutItTextView;
    UILabel* _tellUsAboutItPlaceholderLabel;
    UILabel* _brandsPlaceholderTextLabel;
}

@property (nonatomic, retain) GTIOOpinionRequest *opinionRequest;

@end
