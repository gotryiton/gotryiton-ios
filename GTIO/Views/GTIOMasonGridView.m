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

static double const kGTIOImageWidth = 94.0;
static double const kGTIOHorizontalSpacing = 12.0;

@interface GTIOMasonGridView()

@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation GTIOMasonGridView

@synthesize columns = _columns, items = _items;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)didFinishLoadingGridItem:(GTIOMasonGridItem *)gridItem
{
    [GTIOProgressHUD hideHUDForView:self animated:YES];
    
    double imageSizeRatio = gridItem.image.size.height / gridItem.image.size.width;
    gridItem.image = [gridItem.image imageScaledToSize:(CGSize){ kGTIOImageWidth, kGTIOImageWidth * imageSizeRatio }];
    
    // Find shortest column
    GTIOMasonGridColumn *shortestColumn = nil;
    for (GTIOMasonGridColumn *column in self.columns) {
        if (!shortestColumn || column.height < shortestColumn.height) {
            shortestColumn = column;
        }
    }
    
    GTIOMasonGridItemWithFrameView *gridItemWithFrameView = [[GTIOMasonGridItemWithFrameView alloc] initWithFrame:(CGRect){ shortestColumn.columnNumber * kGTIOImageWidth + shortestColumn.columnNumber * kGTIOHorizontalSpacing, shortestColumn.height == 0 ? 0.0 :shortestColumn.height + shortestColumn.imageSpacer, kGTIOImageWidth, gridItem.image.size.height } image:gridItem.image];
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
    [GTIOProgressHUD showHUDAddedTo:self animated:YES];
    
    // cancel any image downloads, reset items array
    for (GTIOMasonGridItem *item in self.items) {
        [item cancelImageDownload];
    }
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

@end
