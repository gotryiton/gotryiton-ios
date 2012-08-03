//
//  SSPullToRefreshView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//
//  Converted to pull to load more by Scott Penrose
//

#import "SSPullToLoadMoreView.h"
#import "SSPullToLoadMoreDefaultContentView.h"

@interface SSPullToLoadMoreView ()
@property (nonatomic, assign, readwrite) SSPullToLoadMoreViewState state;
@property (nonatomic, assign, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign, readwrite, getter = isExpanded) BOOL expanded;
- (void)_setContentInsetBottom:(CGFloat)bottomInset;
- (void)_setState:(SSPullToLoadMoreViewState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void (^)(void))completion;
- (void)_setPullProgress:(CGFloat)pullProgress;
@end

@implementation SSPullToLoadMoreView {
	dispatch_semaphore_t _animationSemaphore;
	CGFloat _bottomInset;
}

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize expandedHeight = _expandedHeight;
@synthesize contentView = _contentView;
@synthesize state = _state;
@synthesize expanded = _expanded;
@synthesize defaultContentInset = _defaultContentInset;

#pragma mark - Accessors

- (void)setState:(SSPullToLoadMoreViewState)state {
	BOOL loading = _state == SSPullToLoadMoreViewStateLoading;
    _state = state;
	
	// Forward to content view
	[self.contentView setState:_state withPullToLoadMoreView:self];
	
	// Update delegate
	if (loading && _state != SSPullToLoadMoreViewStateLoading) {
		if ([_delegate respondsToSelector:@selector(pullToLoadMoreViewDidFinishLoading:)]) {
			[_delegate pullToLoadMoreViewDidFinishLoading:self];
		}
	} else if (!loading && _state == SSPullToLoadMoreViewStateLoading) {
		[self _setPullProgress:1.0f];
		if ([_delegate respondsToSelector:@selector(pullToLoadMoreViewDidStartLoading:)]) {
			[_delegate pullToLoadMoreViewDidStartLoading:self];
		}
	}
}

- (void)setExpanded:(BOOL)expanded {
	_expanded = expanded;
	[self _setContentInsetBottom:expanded ? self.contentView.frame.size.height : 0.0f];
}

- (void)setScrollView:(UIScrollView *)scrollView {
	void *context = (__bridge void *)self;
    if (scrollView) {
        if ([_scrollView respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
            [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
        } else if (_scrollView) {
            [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
	
	_scrollView = scrollView;	
	_defaultContentInset = _scrollView.contentInset;
    
    if (scrollView) {
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
    }
}

- (UIView<SSPullToLoadMoreContentView> *)contentView {
	// Use the simple content view as the default
	if (!_contentView) {
		self.contentView = [[SSPullToLoadMoreDefaultContentView alloc] initWithFrame:CGRectZero];
	}
	return _contentView;
}

- (void)setContentView:(UIView<SSPullToLoadMoreContentView> *)contentView {
	[_contentView removeFromSuperview];
	_contentView = contentView;
	
	_contentView.autoresizingMask = UIViewAutoresizingNone;
	[_contentView setState:_state withPullToLoadMoreView:self];
	[self refreshLastUpdatedAt];
	[self addSubview:_contentView];
}

- (void)setDefaultContentInset:(UIEdgeInsets)defaultContentInset {
	_defaultContentInset = defaultContentInset;
	[self _setContentInsetBottom:_bottomInset];
}

#pragma mark - NSObject

- (void)dealloc
{
    [self removeObservers];
    
	self.scrollView = nil;
	self.delegate = nil;
	dispatch_release(_animationSemaphore);
}

- (void)removeObservers
{
    void *context = (__bridge void *)self;
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:context];
}

#pragma mark - UIView

- (void)removeFromSuperview {
	self.scrollView = nil;
	[super removeFromSuperview];
}

- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	CGSize contentSize = [self.contentView sizeThatFits:size];
    
	if (contentSize.width < size.width) {
		contentSize.width = size.width;
	}
    
	if (contentSize.height < _expandedHeight) {
		contentSize.height = _expandedHeight;
	}
    
	self.contentView.frame = CGRectMake(roundf((size.width - contentSize.width) / 2.0f), 0, contentSize.width, contentSize.height);
    self.frame = (CGRect){ { 0.0f, self.scrollView.contentSize.height }, { self.frame.size.width, self.contentView.frame.size.height } };
}


#pragma mark - Initializer

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<SSPullToLoadMoreViewDelegate>)delegate {
	CGRect frame = CGRectMake(0.0f, 0.0f, scrollView.bounds.size.width,
							  scrollView.bounds.size.height);
	if ((self = [self initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.scrollView = scrollView;
		self.delegate = delegate;
		self.state = SSPullToLoadMoreViewStateNormal;
		self.expandedHeight = 70.0f;
        
		// Add to scroll view
		[self.scrollView addSubview:self];
        
		// Semaphore is used to ensure only one animation plays at a time
		_animationSemaphore = dispatch_semaphore_create(0);
		dispatch_semaphore_signal(_animationSemaphore);
        
        void *context = (__bridge void *)self;
        [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:context];
	}
	return self;
}

#pragma mark - Loading

- (void)startLoading {
	[self startLoadingAndExpand:NO];
}


- (void)startLoadingAndExpand:(BOOL)shouldExpand {
	// If we're not loading, this method has no effect
    if (_state == SSPullToLoadMoreViewStateLoading) {
		return;
	}
	
	// Animate back to the loading state
	[self _setState:SSPullToLoadMoreViewStateLoading animated:YES expanded:shouldExpand completion:nil];
}


- (void)finishLoading {
	// If we're not loading, this method has no effect
    if (_state != SSPullToLoadMoreViewStateLoading) {
		return;
	}
	
	// Animate back to the normal state
	[self _setState:SSPullToLoadMoreViewStateClosing animated:YES expanded:NO completion:^{
		self.state = SSPullToLoadMoreViewStateNormal;
	}];
}


- (void)refreshLastUpdatedAt {
	NSDate *date = nil;
	if ([_delegate respondsToSelector:@selector(pullToLoadMoreViewLastUpdatedAt:)]) {
		date = [_delegate pullToLoadMoreViewLastUpdatedAt:self];
	} else {
		date = [NSDate date];
	}
	
	// Forward to content view
	if ([self.contentView respondsToSelector:@selector(setLastUpdatedAt:withPullToRefreshView:)]) {
		[self.contentView setLastUpdatedAt:date withPullToRefreshView:self];
	}
}


#pragma mark - Private

- (void)_setContentInsetBottom:(CGFloat)bottomInset {
	_bottomInset = bottomInset;
	
	// Default to the scroll view's initial content inset
	UIEdgeInsets inset = _defaultContentInset;
	
	// Add the top inset
	inset.bottom += _bottomInset;
    
//    NSLog(@"bottom inset: %f, total bottom inset: %f", bottomInset, inset.bottom);
	
	// Don't set it if that is already the current inset
	if (UIEdgeInsetsEqualToEdgeInsets(_scrollView.contentInset, inset)) {
		return;
	}
	
	// Update the content inset
	_scrollView.contentInset = inset;
}


- (void)_setState:(SSPullToLoadMoreViewState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void (^)(void))completion {
	if (!animated) {
		self.state = state;
		self.expanded = expanded;
		
		if (completion) {
			completion();
		}
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		dispatch_semaphore_wait(_animationSemaphore, DISPATCH_TIME_FOREVER);
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
				self.state = state;
				self.expanded = expanded;

                if (self.expandedHeight == 0 && _bottomInset != 0) {
                    [self.scrollView setContentOffset:(CGPoint){ 0, self.scrollView.contentSize.height - self.scrollView.frame.size.height + self.scrollView.contentInset.bottom }];
                }
			} completion:^(BOOL finished) {
				dispatch_semaphore_signal(_animationSemaphore);
				if (completion) {
					completion();
				}
			}];
		});
	});
}


- (void)_setPullProgress:(CGFloat)pullProgress {
	if ([self.contentView respondsToSelector:@selector(setPullProgress:)]) {
		[self.contentView setPullProgress:pullProgress];
	}
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// Call super if we didn't register for this notification
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
	
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        [self setFrame:CGRectMake(0.0f, height + self.contentView.frame.size.height - self.scrollView.bounds.size.height, self.scrollView.bounds.size.width,
                                  self.scrollView.bounds.size.height)];
    }
    
	// We don't care about this notificaiton
	if (object != _scrollView || ![keyPath isEqualToString:@"contentOffset"]) {
		return;
	}
	
	// Get the offset out of the change notification
	CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y + self.scrollView.frame.size.height - self.scrollView.contentInset.bottom;
    CGFloat contentSizeHeight = self.scrollView.contentSize.height;
    
	// Scroll view is dragging
	if (_scrollView.isDragging) {
		// Scroll view is ready
		if (_state == SSPullToLoadMoreViewStateReady) {
			// Dragged enough to refresh
			if (y < contentSizeHeight + _expandedHeight && y > contentSizeHeight) {
				self.state = SSPullToLoadMoreViewStateNormal;
			}
            // Scroll view is normal
		} else if (_state == SSPullToLoadMoreViewStateNormal) {
			// Update the content view's pulling progressing
			[self _setPullProgress:y - contentSizeHeight / _expandedHeight];
			
			// Dragged enough to be ready
			if (y > contentSizeHeight + _expandedHeight) {
				self.state = SSPullToLoadMoreViewStateReady;
			}
            // Scroll view is loading
		} else if (_state == SSPullToLoadMoreViewStateLoading) {
            // Just keep the insets as they are.
		}
		return;
	}
	
	// If the scroll view isn't ready, we're not interested
	if (_state != SSPullToLoadMoreViewStateReady) {
		return;
	}
	
	// We're ready, prepare to switch to loading. Be default, we should refresh.
	SSPullToLoadMoreViewState newState = SSPullToLoadMoreViewStateLoading;
	
	// Ask the delegate if it's cool to start loading
	BOOL expand = YES;
	if ([_delegate respondsToSelector:@selector(pullToLoadMoreViewShouldStartLoading:)]) {
		if (![_delegate pullToLoadMoreViewShouldStartLoading:self]) {
			// Animate back to normal since the delegate said no
			newState = SSPullToLoadMoreViewStateNormal;
			expand = NO;
		}
	}
	
	// Animate to the new state
	[self _setState:newState animated:YES expanded:expand completion:nil];
}

@end
