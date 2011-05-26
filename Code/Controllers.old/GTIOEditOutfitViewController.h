//
//  GTIOEditOutfitViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOTableViewController.h"
#import "GTIOOutfit.h"
#import "GTIOOutfitViewController.h"

@interface GTIOEditOutfitViewController : GTIOTableViewController <TWTPickerDelegate, UITextViewDelegate> {
	GTIOOutfit* _outfit;
	TWTPickerControl* _whereYouAreGoingPicker;
	UITextView* _tellUsMoreAboutItTextView;
	GTIOOutfitViewController* _outfitViewController;
}

@property (nonatomic, retain) GTIOOutfitViewController *outfitViewController;
@property (nonatomic, retain) GTIOOutfit *outfit;

@end
