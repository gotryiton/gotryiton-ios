//
//  GTIOOutfitPageView.h
//  GoTryItOn
//
//  Created by Daniel Hammond on 12/27/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

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


@interface GTIOOutfitPageView : UIView <TTScrollViewDelegate, RKObjectLoaderDelegate> {
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

@property (nonatomic, assign) GTIOOutfitViewState state;
@property (nonatomic, assign) BOOL isFirstPage;
@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger outfitIndex;
@property (nonatomic, retain) GTIOOutfit *outfit;
@property (nonatomic, readonly) NSDictionary* currentPhoto;

- (void)setState:(GTIOOutfitViewState)state animated:(BOOL)animated;

// Note that this method may actually modify the state as it takes a reference, not a value.
- (BOOL)continueAfterHandlingTouch:(UITouch*)touch forState:(GTIOOutfitViewState*)state;

- (BOOL)isMultiLookOutfit;
- (BOOL)hasNextLook;
- (BOOL)hasPreviousLook;
- (void)showNextLook;
- (void)showPreviousLook;
- (void)didAppear;
- (void)mayHaveDisappeared;

@end
