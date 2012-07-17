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

@interface GTIOMasonGridView()

@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation GTIOMasonGridView

@synthesize columns = _columns, items = _items;
@synthesize topPadding = _topPadding;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topPadding = 5.0f;
    }
    return self;
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
    CGFloat gridItemWithFrameViewOriginY = self.topPadding + (shortestColumn.height == 0 ? 0.0 : shortestColumn.height) + (shortestColumn.height == 0 ? 0.0 : shortestColumn.imageSpacer);
    GTIOMasonGridItemWithFrameView *gridItemWithFrameView = [[GTIOMasonGridItemWithFrameView alloc] initWithFrame:(CGRect){ { gridItemWithFrameViewOriginX, gridItemWithFrameViewOriginY }, { kGTIOFrameImageWidth, gridItem.image.size.height + kGTIOGridItemPhotoPadding + kGTIOGridItemPhotoBottomPadding } } image:gridItem.image];
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
    [self setContentSize:(CGSize){ self.frame.size.width, tallestColumnHeight + 12 }];
    
    // Fade in
    [UIView animateWithDuration:0.25 animations:^{
        gridItemWithFrameView.alpha = 1.0;
    }];
}

- (void)gridItem:(GTIOMasonGridItem *)gridItem didFailToLoadWithError:(NSError *)error
{
    [self.items removeObject:gridItem];
}

- (void)setPosts:(NSArray *)posts postsType:(GTIOPostType)postsType
{
    // cancel any image downloads, reset items array
    [self cancelAllItemDownloads];
    self.items = [NSMutableArray array];
    
    // clear the view
    for (UIView *subview in self.subviews) {
        if ([subview isMemberOfClass:[GTIOMasonGridItemWithFrameView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    // reset columns
    self.columns = [NSMutableArray arrayWithObjects:
                [GTIOMasonGridColumn gridColumnWithColumnNumber:0],
                [GTIOMasonGridColumn gridColumnWithColumnNumber:1],
                [GTIOMasonGridColumn gridColumnWithColumnNumber:2],
                nil];
    
    // bring in the new data
    for (GTIOPost *post in posts) {
        GTIOMasonGridItem *item = [[GTIOMasonGridItem alloc] init];
        item.delegate = self;
        item.URL = post.photo.smallThumbnailURL;
        [item downloadImage];
        [self.items addObject:item];
    }
}

- (void)cancelAllItemDownloads
{
    for (GTIOMasonGridItem *item in self.items) {
        [item cancelImageDownload];
    }
}

@end
