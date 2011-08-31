//
//  GTIOTellUsAboutItViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 8/31/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOTellUsAboutItViewController is a [GTIOTableViewController](GTIOTableViewController) that provides controls 
/// for the user to give more information about an outfit in a [GTIOpinionRequest](GTIOpinionRequest)

#import "GTIOTableViewController.h"
#import "GTIOOpinionRequest.h"
#import <TWTPickerControl.h>

@interface GTIOTellUsAboutItViewController : GTIOConcreteBackgroundTableViewController <UITextViewDelegate, TWTPickerDelegate, TTTextEditorDelegate> {
	GTIOOpinionRequest* _opinionRequest;
	TWTPickerControl* _whereYouAreGoingPicker;
	TTTextEditor* _tellUsMoreAboutItTextView;
    UILabel* _tellUsAboutItPlaceholderLabel;
    UILabel* _brandsPlaceholderTextLabel;
}

/// opinion request 
@property (nonatomic, retain) GTIOOpinionRequest *opinionRequest;

@end
