//
//  GTIOScrollView.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOScrollView.h"
#import "GTIOOutfitTableHeaderDragRefreshView.h"
#import "GTIOOutfitPageView.h"

@interface TTScrollView (Private)

- (UIEdgeInsets)stretchTouchEdges:(UIEdgeInsets)edges toPoint:(CGPoint)point;
- (UIEdgeInsets)squareTouchEdges:(UIEdgeInsets)edges;
- (CGPoint)touchLocation:(UITouch*)touch;
- (UIEdgeInsets)resistPageEdges:(UIEdgeInsets)edges;
- (BOOL)edgesAreZoomed:(UIEdgeInsets)edges;
- (void)updateZooming:(UIEdgeInsets)edges;
- (BOOL)canZoom;
- (CGFloat)overflowForFrame:(CGRect)frame;
- (NSInteger)realPageIndex;

@end

@implementation GTIOScrollView

@dynamic pinched;
@dynamic pageWidth;
@dynamic zoomFactor;
@dynamic flipped;
@synthesize dragToRefresh = _dragToRefresh;
@synthesize lastPageIndex = _lastPageIndex;
@synthesize shouldScroll = _shouldScroll;

- (void)dealloc {
    [_refreshView release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		_shouldScroll = YES;
	}
	return self;
}

- (void)setDragToRefresh:(BOOL)dragToRefresh {
    _dragToRefresh = dragToRefresh;
    if (dragToRefresh) {
        // add refresh view
        if (nil == _refreshView) {
            _refreshView = [[GTIOOutfitTableHeaderDragRefreshView alloc] initWithFrame:CGRectMake(0,-327,self.size.width, 320)];
        }
        [self addSubview:_refreshView];
    } else {
        [_refreshView removeFromSuperview];
    }
}

- (void)layoutSubviews {
	if (_visiblePageIndex != _centerPageIndex && self.centerPage) {
		self.lastPageIndex = _visiblePageIndex;
	}
    _refreshView.frame = CGRectOffset(_refreshView.bounds, 0, -327 + _pageEdges.top);
    
    // TODO: fix
//    if (![_refreshView isFlipped] && _pageEdges.top >= 50) {
//        [_refreshView flipImageAnimated:YES];
//        [_refreshView setStatus:TTTableHeaderDragRefreshReleaseToReload];
//    } else if ([_refreshView isFlipped] && _pageEdges.top < 50) {
//        [_refreshView flipImageAnimated:YES];
//        if (UIEdgeInsetsEqualToEdgeInsets(_edgeInsets, UIEdgeInsetsZero)) {
//            // TODO: figure out a better way to tell if we are loading
//            [_refreshView setStatus:TTTableHeaderDragRefreshPullToReload];
//        }
//    }
    
	[super layoutSubviews];
}

- (void)doneReloading {
    _edgeInsets = UIEdgeInsetsZero;
    
    // TODO: fix
    NSLog(@"Hide Activity");
//    [_refreshView showActivity:NO];
//    self.scrollEnabled = YES;
    [_refreshView setStatus:TTTableHeaderDragRefreshPullToReload];
    [[self viewWithTag:1234] removeFromSuperview];
}

- (void)startReloading {
    UIView* overlayView = [[TTActivityLabel alloc] initWithFrame:self.bounds style:TTActivityLabelStyleBlackBox text:@"loading..."];
    overlayView.userInteractionEnabled = NO;
    overlayView.tag = 1234;
    [self addSubview:overlayView];
    [overlayView release];
    _edgeInsets = UIEdgeInsetsMake(50,0,50,0);
//    _pageEdges = _edgeInsets;
    
    // TODO: fix
    NSLog(@"Show Activity!");
//    [_refreshView showActivity:YES];
    
//    self.scrollEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(scrollView:shouldReloadPage:)]) {
        [self.delegate scrollView:self shouldReloadPage:self.centerPage];
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
//    NSLog(@"Touch Count:%d", [touches count]);
    if ([self viewWithTag:1234]) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [super touchesEnded:touches withEvent:event];
    if (_pageEdges.top >= 50 && self.dragToRefresh == YES) {
        [self startReloading];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
    
    TT_INVALIDATE_TIMER(_holdingTimer);
    
	if (_scrollEnabled && !_holding && _touchCount && !_animationTimer) {
		if (!_dragging) {
			_dragging = YES;
			TT_INVALIDATE_TIMER(_tapTimer);
			
			if ([_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
				[_delegate scrollViewWillBeginDragging:self];
			}
		}
		
		_touchEdges = UIEdgeInsetsZero;
		for (UITouch* touch in [event allTouches]) {
			if (touch == _touch1 || touch == _touch2) {
				_touchEdges = [self stretchTouchEdges:_touchEdges toPoint:[self touchLocation:touch]];
			}
		}
		
		UIEdgeInsets edges = [self squareTouchEdges:_touchEdges];
		CGFloat left = _pageStartEdges.left + (edges.left - _touchStartEdges.left);
		CGFloat right = _pageStartEdges.right + (edges.right - _touchStartEdges.right);
		CGFloat top = _pageEdges.top;
		CGFloat bottom = _pageEdges.bottom;
		if ((_touchCount == 2 || self.zoomed) && _zoomEnabled && !_holding) {
			// XXXjoe I am sure this "r" had a purpose at one point, but months after writing it I'll
			// be damned if I remember.  It's causing the image to get out of sync with your finger
			// while dragging, so disabling it for now.
			CGFloat r = 1;//self.pageHeight / self.pageWidth;
			top = _pageStartEdges.top + (edges.top - _touchStartEdges.top) * r;
			bottom = _pageStartEdges.bottom + (edges.bottom - _touchStartEdges.bottom) * r;
		}
		
		// We are going to look for a scroll view below us. If it has a page to the left or right, we scroll it and not this one.
		TTScrollView* scrollView = [self.centerPage.subviews objectWithClass:[TTScrollView class]];
        
        // This is the piece of code that enables drag to refresh:
		if (_dragToRefresh && scrollView.zoomed == NO) {
			CGFloat r = 1;
			top = _pageStartEdges.top + (edges.top - _touchStartEdges.top) * r;
			bottom = _pageStartEdges.bottom + (edges.bottom - _touchStartEdges.bottom) * r;
            
//            NSLog(@"Page Edges: %@", NSStringFromUIEdgeInsets(_pageEdges));
            
            if (top >= abs(_pageEdges.left) - 10) {
                left = 0;
                right = 0;
            } else {
                top = 0;
                bottom = 0;
            }
            if (top < 0) {
                top = 0;
                bottom = 0;
            }
            // Gravity substitute.
            if (top > 95) {
                top=95;
                bottom=95;
            }
		}
		
		UIEdgeInsets newEdges = UIEdgeInsetsMake(top, left, bottom, right);
		UIEdgeInsets pageEdges = [self resistPageEdges:newEdges];
		
		if (![self edgesAreZoomed:pageEdges] || self.canZoom) {
			
            // This is teh piece of code that doesn't let you scroll the top view while the bottom is zoomed.
			if (scrollView.zoomed) {
				pageEdges.right = pageEdges.right - pageEdges.left;
				pageEdges.left = 0;
			}
			
			if (pageEdges.left < 0 && scrollView.centerPageIndex + 1 < scrollView.numberOfPages) {
				pageEdges.right = pageEdges.right - pageEdges.left;
				pageEdges.left = 0;
			}
			if (pageEdges.left > 0 && scrollView.centerPageIndex  > 0) {
				pageEdges.right = pageEdges.right - pageEdges.left;
				pageEdges.left = 0;
			}
			if ((!self.zoomed && !_shouldScroll) || // Single outfit view
				(!self.zoomed && pageEdges.left < 0 && self.centerPageIndex >= (self.numberOfPages - 1) && !scrollView) || // Scrolling Right. Internal scroll view.
				(!self.zoomed && pageEdges.left > 0 && self.centerPageIndex == 0 && !scrollView)) { // Scrolling Left. Internal scroll view.
				pageEdges.right = pageEdges.right - pageEdges.left;
				pageEdges.left = 0;
			}
			// end shenanagins.
        //}   
			_pageEdges = pageEdges;
			[self updateZooming:pageEdges];
			[self setNeedsLayout];
		}
	}
}

- (UIEdgeInsets)zoomPageEdgesTo:(CGPoint)point {
  UIEdgeInsets edges = _pageEdges;
	
  CGFloat zoom = 0.75 * self.pageWidth;
  CGFloat r = self.height / self.pageWidth;
	
  CGFloat xd = [self pageWidth]/2 - point.x;
  CGFloat yd = self.height/2 - point.y;
	
  edges.left = (-zoom + xd);
  edges.right = zoom + xd;
  edges.top = (-zoom + yd) * r;
  edges.bottom = (zoom + yd) * r;
	
  if (edges.left > 0) {
    edges.right += edges.left;
    edges.left = 0;
  } else if (edges.right < 0) {
    edges.left += -edges.right;
    edges.right = 0;
  }
	
  if (edges.top > 0) {
    edges.bottom += edges.top;
    edges.top = 0;
  } else if (edges.bottom < 0) {
    edges.top += -edges.bottom;
    edges.bottom = 0;
  }
	
  return edges;
}

- (void)stopAnimation:(BOOL)resetEdges {
    if (_animationTimer) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        TT_RELEASE_SAFELY(_animationStartTime);
        _overshoot = 0;
        // This bit of sneakyness fixes the issues with zooming the scroll view when
        // zoomed out that we were experiencing.
//        TTScrollView* scrollView = [self.centerPage.subviews objectWithClass:[TTScrollView class]];
//        GTIOOutfitPageView* page = (GTIOOutfitPageView*)self.centerPage;
//        if (self.zoomEnabled) {
//            [self updateZooming:UIEdgeInsetsMake(1,1,-1,-1)];
//        } else {
            [self updateZooming:UIEdgeInsetsZero];
//        }
        
        
        NSInteger realIndex = [self realPageIndex];
        if (realIndex != _centerPageIndex) {
            [self moveToPageAtIndex:realIndex resetEdges:resetEdges];
        }
    }
}

- (void)updateZooming:(UIEdgeInsets)edges {
//    TTScrollView* scrollView = [self.centerPage.subviews objectWithClass:[TTScrollView class]];
//    GTIOOutfitPageView* page = (GTIOOutfitPageView*)self.centerPage;
//    if (nil == scrollView) { // && page.state == GTIOOutfitViewStateFullscreen) {
//        self.centerPage.userInteractionEnabled = NO;
//    } else {
//        self.centerPage.userInteractionEnabled = YES;
//    }
    
    if (!_zooming && (self.zoomed || [self edgesAreZoomed:edges])) {
        _zooming = YES;
        //self.centerPage.userInteractionEnabled = NO;
        
        if ([_delegate respondsToSelector:@selector(scrollViewDidBeginZooming:)]) {
            [_delegate scrollViewDidBeginZooming:self];
        }
        
    } else if (_zooming && !self.zoomed) {
        _zooming = NO;
        //self.centerPage.userInteractionEnabled = YES;
        
        if ([_delegate respondsToSelector:@selector(scrollViewDidEndZooming:)]) {
            [_delegate scrollViewDidEndZooming:self];
        }
    }
}

@end
