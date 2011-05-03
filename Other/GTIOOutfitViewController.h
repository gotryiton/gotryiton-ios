//
//  GTIOOutfitViewController.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOPaginatedTTModel.h"
#import "GTIOOutfitViewScrollDataSource.h"
#import "GTIOOutfit.h"
#import "GTIOScrollView.h"
#import "GTIOOutfitHeaderView.h"

typedef enum {
	GTIOOutfitViewStateShowControls,
	GTIOOutfitViewStateFullscreen,
	GTIOOutfitViewStateFullDescription,
//	GTIOOutfitViewStateVoteFeedback,
//	GTIOOutfitViewStateHasVerdict
} GTIOOutfitViewState;

// Note: I inherit from TTViewController, not TTModelViewController because I do not create my own model, I am provided one.
@interface GTIOOutfitViewController : TTViewController <TTModelDelegate, TTScrollViewDelegate, RKObjectLoaderDelegate> {
	GTIOScrollView* _scrollView;
	GTIOPaginatedTTModel* _model;
	int _outfitIndex;
	GTIOOutfitViewState _state;
	GTIOOutfitViewScrollDataSource* _scrollViewDataSource;
	GTIOOutfitHeaderView* _headerView;
   	UIImageView* _headerShadowView;
    
    RKObjectLoader* _loader;
}

@property (nonatomic, assign) GTIOOutfitViewState state;
@property (nonatomic, assign) int outfitIndex;
@property (nonatomic, retain) GTIOPaginatedTTModel *model;

@property (nonatomic, readonly) GTIOOutfit* outfit;

- (id)initWithModel:(GTIOPaginatedTTModel*)model outfitIndex:(int)index;

- (void)saveOutfit:(GTIOOutfit*)outfit withNewEventID:(NSNumber*)eventID description:(NSString*)description;

@end
