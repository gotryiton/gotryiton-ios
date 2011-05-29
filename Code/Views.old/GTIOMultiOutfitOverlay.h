//
//  GTIOMultiOutfitOverlay.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// Overlay UIView displayed on [GTIOOutfitViewController](GTIOOutfitViewController) when there are more than one outfit

#import <Foundation/Foundation.h>
#import "GTIOOutfit.h"

@interface GTIOMultiOutfitOverlay : UIView {
	GTIOOutfit* _outfit;
	NSInteger _lookIndex;
	NSInteger _nextLookIndex;
	CGRect _expandedFrame;
	CGRect _collapsedFrame;
	
	UIImageView* _selectionView;
	
	UILabel* _textLabel;
	
	TTPhotoView* _look1;
	TTPhotoView* _look2;
	TTPhotoView* _look3;
	TTPhotoView* _look4;
}
/// Outfit being displayed
@property (nonatomic, retain) GTIOOutfit *outfit;
/// returns frame of view when expanded
@property (nonatomic, assign) CGRect expandedFrame;
/// returns frame of view when collapsed
@property (nonatomic, assign) CGRect collapsedFrame;
/// Index of the look
@property (nonatomic, readonly) NSInteger lookIndex;

/// displays given look
- (void)setLook:(NSInteger)lookIndex animated:(BOOL)animated;
/// displays part 2 of look ?
- (void)setLookPart2:(NSInteger)lookIndex animated:(BOOL)animated;
/// determines which look the touch is inside and collapses/expands as apropriate
- (int)expandOrContractWithTouch:(UITouch*)touch;
/// zooms out view after a delay
- (void)zoomOutAfterDelay:(NSInteger)delay;
/// tells the overlay it has been dragged left a given offset
- (void)draggedWithLeftOffset:(double)offset;
/// sets selected outfit without resetting the overlay
- (void)setOutfitWithoutResettingOverlay:(GTIOOutfit *)outfit;

@end
