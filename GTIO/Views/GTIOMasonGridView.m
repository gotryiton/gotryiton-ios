//
//  GTIOMasonGridView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridView.h"
#import "GTIOMasonGridColumn.h"
#import "GTIOProgressHUD.h"

static double const imageWidth = 94.0;
static double const horizontalSpacing = 12.0;

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
    
    // Image frame with shadow
    UIImageView *gridFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"grid-thumbnail-frame.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 0.0, 6.0, 0.0)]];
    gridFrameImageView.alpha = 0.0;
    
    // Actual image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:gridItem.image];
    imageView.alpha = 0.0;
    
    // Size and position
    [imageView setFrame:(CGRect){ shortestColumn.columnNumber * imageWidth + shortestColumn.columnNumber * horizontalSpacing, shortestColumn.height == 0 ? 0.0 :shortestColumn.height + shortestColumn.imageSpacer, imageWidth, imageView.bounds.size.height }];
    [gridFrameImageView setFrame:(CGRect){ imageView.frame.origin.x - 4, imageView.frame.origin.y - 4, imageView.bounds.size.width + 8, imageView.bounds.size.height + 9 }];
    
    [self addSubview:gridFrameImageView];
    [self addSubview:imageView];
    
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
        gridFrameImageView.alpha = 1.0;
        imageView.alpha = 1.0;
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
