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
        _columns = [NSMutableArray arrayWithObjects:
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:0],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:1],
                    [GTIOMasonGridColumn gridColumnWithColumnNumber:2],
                    nil];
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)didFinishLoadingGridItem:(GTIOMasonGridItem *)gridItem
{
    [GTIOProgressHUD hideHUDForView:self animated:YES];
    
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
    
    for (GTIOPost *post in posts) {
        GTIOMasonGridItem *item = [[GTIOMasonGridItem alloc] init];
        item.delegate = self;
        item.URL = post.photo.smallThumbnailURL;
        [item downloadImage];
        [self.items addObject:item];
    }
}

@end
