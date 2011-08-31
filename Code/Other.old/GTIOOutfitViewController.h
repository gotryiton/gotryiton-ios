//
//  GTIOOutfitViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOOutfitViewController is the main view controller in control of viewing an outfit through its [GTIOScrollView](GTIOScrollView) containing many [GTIOOutfitPageView](GTIOOutfitPageView)

#import <Foundation/Foundation.h>
#import "GTIOViewController.h"
#import "GTIOPaginatedTTModel.h"
#import "GTIOOutfitViewScrollDataSource.h"
#import "GTIOOutfit.h"
#import "GTIOScrollView.h"
#import "GTIOOutfitTitleView.h"

typedef enum {
	GTIOOutfitViewStateShowControls,
	GTIOOutfitViewStateFullscreen,
	GTIOOutfitViewStateFullDescription,
//	GTIOOutfitViewStateVoteFeedback,
//	GTIOOutfitViewStateHasVerdict
} GTIOOutfitViewState;

// Note: I inherit from GTIOViewController, not TTModelViewController because I do not create my own model, I am provided one.
@interface GTIOOutfitViewController : GTIOViewController <TTModelDelegate, TTScrollViewDelegate, RKObjectLoaderDelegate> {
	GTIOScrollView* _scrollView;
	GTIOPaginatedTTModel* _model;
	int _outfitIndex;
	GTIOOutfitViewState _state;
	GTIOOutfitViewScrollDataSource* _scrollViewDataSource;
	GTIOOutfitTitleView* _headerView;
   	UIImageView* _headerShadowView;
    
    RKObjectLoader* _loader;
}
/// current state of the view controller 
@property (nonatomic, assign) GTIOOutfitViewState state;
/// current outfit index 
@property (nonatomic, assign) int outfitIndex;
/// model containing outfits
@property (nonatomic, retain) GTIOPaginatedTTModel *model;
/// current outfit
@property (nonatomic, readonly) GTIOOutfit* outfit;
/// initialize view controller with outfit and index
- (id)initWithModel:(GTIOPaginatedTTModel*)model outfitIndex:(int)index;
/// called from the [GTIOEditOutfitViewController](GTIOEditOutfitViewController) to update outfit
- (void)saveOutfit:(GTIOOutfit*)outfit withNewEventID:(NSNumber*)eventID description:(NSString*)description;

@end
