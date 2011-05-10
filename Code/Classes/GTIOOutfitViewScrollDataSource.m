//
//  GTIOOutfitViewScrollDataSource.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GTIOOutfitViewScrollDataSource.h"
#import "GTIOOutfitPageView.h"

@implementation GTIOOutfitViewScrollDataSource

@synthesize model = _model;
@synthesize moreToLoad = _moreToLoad;

- (id)init {
    if (self = [super init]) {
        _moreToLoad = YES;
    }
    return self;
}

- (void)dealloc {
	[_model release];
	_model = nil;
	[super dealloc];
}

- (void)setModel:(GTIOPaginatedTTModel *)model {
    [model retain];
    [_model release];
    _model = model;
//    _moreToLoad = [model hasMoreToLoad];
}

- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
//    if (_moreToLoad) {
//        return [_model.objects count] + 1;
//    }
	return [_model.objects count];
}

- (void)loadMoreCall {
    [_model load:TTURLRequestCachePolicyDefault more:YES];
}


- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
	if (pageIndex + 1 == [self numberOfPagesInScrollView:scrollView]) {
		if (![_model isLoadingMore]) {
			NSLog(@"Load More");
			[_model load:TTURLRequestCachePolicyDefault more:YES];
            // For testing: (make load take longer)
//            [self performSelector:@selector(loadMoreCall) withObject:nil afterDelay:5];
		}
	}
	
	
	GTIOOutfitPageView* page = (GTIOOutfitPageView*)[scrollView dequeueReusablePage];
	if (nil == page) {
		page = [[[GTIOOutfitPageView alloc] initWithFrame:scrollView.bounds] autorelease];
	}
    if (pageIndex >= [_model.objects count]) {
        // loading page
        page.outfit = nil;
        page.isLastPage = YES;
        return page;
    }
	page.outfit = [_model.objects objectAtIndex:pageIndex];
    page.isFirstPage = (pageIndex == 0);
    page.isLastPage = (pageIndex == [_model.objects count] - 1);
    NSLog(@"is last page: %d", page.isLastPage);
	[page setWillMoveInFromLeft:(pageIndex < scrollView.centerPageIndex)];
	return page;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
	return scrollView.bounds.size;
}

@end