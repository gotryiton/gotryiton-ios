//
//  GTIOMultiOutfitOverlay.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/26/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

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

@property (nonatomic, retain) GTIOOutfit *outfit;
@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, assign) CGRect collapsedFrame;
@property (nonatomic, readonly) NSInteger lookIndex;

- (void)setLook:(NSInteger)lookIndex animated:(BOOL)animated;
- (void)setLookPart2:(NSInteger)lookIndex animated:(BOOL)animated;

- (int)expandOrContractWithTouch:(UITouch*)touch;
- (void)zoomOutAfterDelay:(NSInteger)delay;
- (void)draggedWithLeftOffset:(double)offset;
- (void)setOutfitWithoutResettingOverlay:(GTIOOutfit *)outfit;

@end
