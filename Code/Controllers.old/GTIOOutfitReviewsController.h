//
//  GTIOOutfitReviewsController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOOutfitReviewsController is a TTTableViewController that displays the reviews for an outfit and provides control to write new review

#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOOutfitReviewsController : TTTableViewController <TTTextEditorDelegate, RKObjectLoaderDelegate> {
	GTIOOutfit* _outfit;
	TTTextEditor* _editor;
    UIButton* _closeButton;
	UILabel* _placeholder;
    NSMutableArray* _imageViews;
    NSMutableArray* _buttons;
    UIButton* _keyboardOverlayButton1;
    UIButton* _keyboardOverlayButton2;
    BOOL _loading;
}
/// outfit object
@property (nonatomic, retain) GTIOOutfit* outfit;

@end
