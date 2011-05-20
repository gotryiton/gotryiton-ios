//
//  GTIOScrollView.h
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20UI/TTTableHeaderDragRefreshView.h>


@interface GTIOScrollView : TTScrollView {
	NSInteger _lastPageIndex;
	BOOL _shouldScroll;
	BOOL _dragToRefresh;
    TTTableHeaderDragRefreshView* _refreshView;
    
    // TODO: this actually doesn't work at all. fix or remove.
    UIEdgeInsets _edgeInsets;
}

@property (nonatomic, assign) BOOL dragToRefresh;
@property (nonatomic, assign) NSInteger lastPageIndex;
@property (nonatomic, assign) BOOL shouldScroll;

// Should probably be private.
@property (nonatomic, readonly) BOOL pinched;
@property (nonatomic, readonly) BOOL flipped;
@property (nonatomic, readonly) CGFloat zoomFactor;
@property (nonatomic, readonly) CGFloat pageWidth;
- (void)moveToPageAtIndex:(NSInteger)pageIndex resetEdges:(BOOL)resetEdges;
- (void)doneReloading;

@end

