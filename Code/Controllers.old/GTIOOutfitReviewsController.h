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
#import "GTIOProduct.h"

@interface GTIOOutfitReviewsController : TTTableViewController <TTTextEditorDelegate, RKObjectLoaderDelegate, UIGestureRecognizerDelegate> {
	TTTextEditor* _editor;
    UIButton* _closeButton;
	UILabel* _placeholder;
    NSMutableArray* _imageViews;
    NSMutableArray* _buttons;
    UIButton* _keyboardOverlayButton1;
    UIButton* _keyboardOverlayButton2;
    BOOL _exitAfterPostingReview;
    BOOL _loading;
    UIButton* _recommendButton;
}
/// outfit object
@property (nonatomic, retain) GTIOOutfit* outfit;
@property (nonatomic, retain) GTIOProduct* product;

@end
