//
//  GTIOOutfitPageView.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/27/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//
/// GTIOOutfitPageView is a subview of [GTIOOutfitPageViewController](GTIOOutfitPageViewController) that displays a single 
/// look and provides brand information, voting behavior, and multiple outfit selection

#import "GTIOOutfit.h"
#import "GTIOOutfitTopControlsView.h"
#import "GTIOOutfitViewController.h"
#import "GTIOMultiOutfitOverlay.h"
#import <RestKit/RestKit.h>
#import "GTIOVerdictView.h"
#import "GTIOChangeItReasonsView.h"

extern CGRect const changeItFrame;
extern CGRect const wearNoneFrame;
extern CGRect const wear1of1Frame;
extern CGRect const wear1of2Frame;
extern CGRect const wear2of2Frame;
extern CGRect const wear1of3Frame;
extern CGRect const wear2of3Frame;
extern CGRect const wear3of3Frame;
extern CGRect const wear1of4Frame;
extern CGRect const wear2of4Frame;
extern CGRect const wear3of4Frame;
extern CGRect const wear4of4Frame;


@interface GTIOOutfitPageView : UIView <TTScrollViewDelegate, RKObjectLoaderDelegate, UIGestureRecognizerDelegate> {
	GTIOOutfit* _outfit;
    BOOL _isFirstPage;
    BOOL _isLastPage;
	GTIOScrollView* _photosView;
	
	GTIOMultiOutfitOverlay* _overlay;
	UIImageView* _arrowIndicator;
	
	GTIOOutfitTopControlsView* _topControlsView;
	
	UIView* _bottomControlsView;
	UIView* _buttonView;
	UIButton* _wearItButton1;
	UIButton* _wearItButton2;
	UIButton* _wearItButton3;
	UIButton* _wearItButton4;
	UIButton* _changeItButton;
	
	UIView* _brandsView;
	UILabel* _brandsLabel;
	UIButton* _brandInfoButton;
	
	UIButton* _goLeftButton;
	UIButton* _goRightButton;
	
	GTIOChangeItReasonsView* _changeItReasonsOverlay;
	
	GTIOVerdictView* _verdictView;
	
	GTIOOutfitViewState _state;
	
	NSTimer* _draggingTimer;
	BOOL _skipSetLook; // TODO: can we clean this up? it's used to skip animations in case we animated while the overlay was fullscreen.
	
	UIImageView* _roundedCornerImageView;
    
    UIView* _overlayView;
    
    RKObjectLoader* _voteRequest;
}
/// State of the view as defined in [GTIOOutfitViewController](GTIOOutfitViewController) 
@property (nonatomic, assign) GTIOOutfitViewState state;
/// true if this is the first page in the set
@property (nonatomic, assign) BOOL isFirstPage;
/// true if this is the last page in the set
@property (nonatomic, assign) BOOL isLastPage;
/// index of the outfit in the set
@property (nonatomic, assign) NSInteger outfitIndex;
/// outfit object
@property (nonatomic, retain) GTIOOutfit *outfit;
/// dictionary representing the current outfit photo information
@property (nonatomic, readonly) NSDictionary* currentPhoto;
/// set the state of the pageView, optionally animated
- (void)setState:(GTIOOutfitViewState)state animated:(BOOL)animated;
/** whether to continue passing on a touch event
*
* Note that this method may actually modify the state as it takes a reference, not a value.
*/
- (BOOL)continueAfterHandlingTouch:(UITouch*)touch forState:(GTIOOutfitViewState*)state;
/// true if the outfit has multiple looks
- (BOOL)isMultiLookOutfit;
/// whether there is another look available further in the photos array
- (BOOL)hasNextLook;
/// whether there is another look available earlier in the photos array
- (BOOL)hasPreviousLook;
/// display the next look
- (void)showNextLook;
/// display the previous look
- (void)showPreviousLook;
/// called by [GTIOOutfitPageViewController](GTIOOutfitPageViewController) viewDidAppear: to get animation correct
- (void)didAppear;
/// prepares for reuse
- (void)mayHaveDisappeared;
/// set whether or not the view will be animated in from left
- (void)setWillMoveInFromLeft:(BOOL)fromLeft;
/// sets the outfit property without displaying a multi overlay
- (void)setOutfitWithoutMultiOverlay:(GTIOOutfit *)outfit;
/// hides arrows and displays the full description
- (void)showFullDescription:(BOOL)show;
@end
