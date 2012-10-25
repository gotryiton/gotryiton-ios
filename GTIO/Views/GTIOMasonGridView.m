//
//  GTIOMasonGridView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridView.h"
#import "GTIOMasonGridColumn.h"
#import "GTIOMasonGridItemWithFrameView.h"
#import "GTIOProgressHUD.h"
#import "UIImage+Resize.h"

static CGFloat const kGTIOFrameImageWidth = 102.0f;
static CGFloat const kGTIOImageWidth = 94.0;
static CGFloat const kGTIOHorizontalSpacing = 2.5;
static CGFloat const kGTIOFirstColumnXOrigin = 5.0f;

@interface GTIOMasonGridView() <SSPullToLoadMoreViewDelegate, SSPullToRefreshViewDelegate>

@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, strong) NSMutableArray *gridItems;

@end

@implementation GTIOMasonGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _padding = 5.0f;
        self.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [self.pullToRefreshView removeObservers];
    [self.pullToLoadMoreView removeObservers];
}

- (void)didFinishLoadingGridItem:(GTIOMasonGridItem *)gridItem
{    
    CGFloat widthRatio = kGTIOImageWidth / gridItem.image.size.width;
    gridItem.image = [gridItem.image imageScaledToSize:(CGSize){ kGTIOImageWidth, gridItem.image.size.height * widthRatio }];
    
    // Find shortest column
    GTIOMasonGridColumn *shortestColumn = nil;
    for (GTIOMasonGridColumn *column in self.columns) {
        if (!shortestColumn || column.height < shortestColumn.height) {
            shortestColumn = column;
        }
    }
    
    CGFloat gridItemWithFrameViewOriginX = kGTIOFirstColumnXOrigin +  shortestColumn.columnNumber * kGTIOFrameImageWidth + shortestColumn.columnNumber * kGTIOHorizontalSpacing;
    CGFloat gridItemWithFrameViewOriginY = self.padding + (shortestColumn.height == 0 ? 0.0 : shortestColumn.height) + (shortestColumn.height == 0 ? 0.0 : shortestColumn.imageSpacer);
    GTIOMasonGridItemWithFrameView *gridItemWithFrameView = [[GTIOMasonGridItemWithFrameView alloc] initWithFrame:(CGRect){ { gridItemWithFrameViewOriginX, gridItemWithFrameViewOriginY }, { kGTIOFrameImageWidth, gridItem.image.size.height + kGTIOGridItemPhotoPadding + kGTIOGridItemPhotoBottomPadding } } gridItem:gridItem];
    [gridItemWithFrameView setTapHandler:self.gridItemTapHandler];
    gridItemWithFrameView.alpha = 0.0;
    [self addSubview:gridItemWithFrameView];
    
    // Add item to grid
    [shortestColumn.items addObject:gridItem];
    
    // Change content size
    CGFloat tallestColumnHeight = 0.0f;
    for (GTIOMasonGridColumn *column in self.columns) {
        if (column.height > tallestColumnHeight) {
            tallestColumnHeight = column.height;
        }
    }
    if (tallestColumnHeight + 12 < self.bounds.size.height) {
        tallestColumnHeight = self.bounds.size.height - 11;
    }
    [self setContentSize:(CGSize){ self.frame.size.width, tallestColumnHeight + 12 + self.padding }];
    
    // Fade in
    [UIView animateWithDuration:0.25 animations:^{
        gridItemWithFrameView.alpha = 1.0;
    }];
}

- (void)gridItem:(GTIOMasonGridItem *)gridItem didFailToLoadWithError:(NSError *)error
{
    [self.gridItems removeObject:gridItem];
}

- (void)setItems:(NSArray *)items postsType:(GTIOPostType)postsType
{
    // cancel any image downloads, reset items array
    [self cancelAllItemDownloads];
    self.gridItems = [NSMutableArray array];
    
    // clear the view
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[GTIOMasonGridItemWithFrameView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self setContentOffset:CGPointZero animated:NO];
    
    // reset columns
    self.columns = [NSMutableArray arrayWithObjects:
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:0],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:1],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:2],
                    nil];
    
    // bring in the new data
    for (id<GTIOGridItem> item in items) {
        [self addItem:item postType:postsType];
    }
}

- (void)addItem:(id<GTIOGridItem>)item postType:(GTIOPostType)postType
{
    GTIOMasonGridItem *masonGridItem = [GTIOMasonGridItem itemWithObject:item];
    masonGridItem.delegate = self;
    [masonGridItem downloadImage];
    [self.gridItems addObject:masonGridItem];
}

- (void)cancelAllItemDownloads
{
    for (GTIOMasonGridItem *item in self.gridItems) {
        [item cancelImageDownload];
    }
}

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.pullToRefreshView.contentView setFrame:(CGRect){ self.pullToRefreshView.contentView.frame.origin, { self.frame.size.width, self.pullToRefreshView.contentView.frame.size.height } }];
    [self.pullToLoadMoreView.contentView setFrame:(CGRect){ self.pullToLoadMoreView.contentView.frame.origin, { self.frame.size.width, self.pullToLoadMoreView.contentView.frame.size.height } }];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // since we don't have dequeue'ing or 'willDisplayGridItemAtRowAndColumn' or something similar...
    // take the tallest column, find the last 3 images, and if you've scrolled to the top one yet, pagniate
    GTIOMasonGridColumn *tallestColumn = nil;
    for (GTIOMasonGridColumn *column in self.columns) {
        if (tallestColumn == nil || column.height > tallestColumn.height) {
            tallestColumn = column;
        }
    }
    
    NSInteger numImages = [[tallestColumn items] count] > 3 ? 3 : [[tallestColumn items] count];
    CGFloat heightOfImages = 0.0f;
    for(int i = 0; i < numImages; i++) {
        heightOfImages += ((GTIOMasonGridItem *)[[tallestColumn items] objectAtIndex:(numImages-1)-i]).image.size.height;
        heightOfImages += self.padding;
    }
    
//    NSLog(@"masonGridView scrollView.contentOffset: %f, pagniation threshold: %f", scrollView.contentOffset.y + scrollView.frame.size.height, (scrollView.contentSize.height - heightOfImages));
    if( (scrollView.contentOffset.y + scrollView.frame.size.height) > (scrollView.contentSize.height - heightOfImages) ) {
        if(self.pagniationDelegate && [self.pagniationDelegate respondsToSelector:@selector(masonGridViewShouldPagniate:)]) {
            [self.pagniationDelegate masonGridViewShouldPagniate:self];
        }
    }
    
}

#pragma mark - Pull to ...

- (void)attachPullToRefreshAndPullToLoadMore
{
    [self attachPullToRefresh];
    [self attachPullToLoadMore];
}

- (void)attachPullToRefresh
{
    // Pull to refresh
    _pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self delegate:self];
    _pullToRefreshView.contentView = [[GTIOPullToRefreshContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.frame.size.width, 0 } }];
}

- (void)attachPullToLoadMore
{
    // Pull to load more
    _pullToLoadMoreView = [[SSPullToLoadMoreView alloc] initWithScrollView:self delegate:self];
    _pullToLoadMoreView.contentView = [[GTIOPullToLoadMoreContentView alloc] initWithFrame:(CGRect){ CGPointZero, { self.frame.size.width, 0.0f } }];
}

#pragma mark - SSPullToRefreshDelegate Methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    if (self.pullToRefreshHandler) {
        self.pullToRefreshHandler(self, view, NO);
    }
}

#pragma mark - SSPullToLoadMoreDelegate Methods

- (void)pullToLoadMoreViewDidStartLoading:(SSPullToLoadMoreView *)view
{
    if (self.pullToLoadMoreHandler) {
        self.pullToLoadMoreHandler(self, view);
    }
}

@end
