//
//  GTIOScrollView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//
/// GTIOScrollView is a subclass of [TTScrollView](TTScrollView) that permits nesting

#import <Foundation/Foundation.h>
#import <Three20UI/TTTableHeaderDragRefreshView.h>

@interface GTIOScrollView : TTScrollView {
	NSInteger _lastPageIndex;
	BOOL _shouldScroll;
	BOOL _dragToRefresh;
    TTTableHeaderDragRefreshView* _refreshView;
    
    // TODO: this actually doesn't work at all. fix or remove.
    UIEdgeInsets _edgeInsets;
    BOOL _reloading;
    
    int _directionLock;
}
/// Whether or not it should be a dragToRefresh scrollview
@property (nonatomic, assign) BOOL dragToRefresh;
/// index of the last page in the list
@property (nonatomic, assign) NSInteger lastPageIndex;
/// whether or not it should scroll
@property (nonatomic, assign) BOOL shouldScroll;

// Should probably be private.
/// true if the view is currently pinched
@property (nonatomic, readonly) BOOL pinched;
/// true if the view is flipped
@property (nonatomic, readonly) BOOL flipped;
/// current zoom factor of the scrollview
@property (nonatomic, readonly) CGFloat zoomFactor;
/// current page width of the scrollview
@property (nonatomic, readonly) CGFloat pageWidth;
/// scroll the scrollview to a given page index
- (void)moveToPageAtIndex:(NSInteger)pageIndex resetEdges:(BOOL)resetEdges;
/// called by [GTIOOutfitViewController](GTIOOutfitViewController) when its done reloading an outfitview
- (void)doneReloading;

@end

