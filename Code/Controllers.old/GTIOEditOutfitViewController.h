//
//  GTIOEditOutfitViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/31/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOEditOutfitViewController is a viewcontroller subclass of [GTIOTableViewController](GTIOTableViewController) that allows the user to edit one of their outfits metadata

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
/// Reference to the parent outfit view controller
@property (nonatomic, retain) GTIOOutfitViewController *outfitViewController;
/// Outfit to be edited
@property (nonatomic, retain) GTIOOutfit *outfit;

@end
