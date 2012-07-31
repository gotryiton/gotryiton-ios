//
//  GTIOMasonGridItemWithFrameView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/28/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOMasonGridItemWithFrameView.h"

@interface GTIOMasonGridItemWithFrameView()

@property (nonatomic, strong) UIImageView *gridFrameImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *star;

@end

@implementation GTIOMasonGridItemWithFrameView


- (id)initWithFrame:(CGRect)frame gridItem:(GTIOMasonGridItem *)gridItem
{
    self = [super initWithFrame:frame];
    if (self) {
        _gridItem = gridItem;
        
        // Image frame with shadow
        _gridFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"grid-thumbnail-frame.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 0.0, 6.0, 0.0)]];
        [_gridFrameImageView setFrame:self.bounds];
        [self addSubview:_gridFrameImageView];
        
        // Actual image
        _imageView = [[UIImageView alloc] initWithImage:gridItem.image];
        [_imageView setFrame:(CGRect){ { kGTIOGridItemPhotoPadding, kGTIOGridItemPhotoPadding }, gridItem.image.size }];
        [self addSubview:_imageView];
        
        if (gridItem.object.photo.isStarred ){
            _star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star-corner-grid.png"]];
            [_star setFrame:(CGRect){ self.bounds.size.width - _star.bounds.size.width - kGTIOGridItemPhotoPadding, kGTIOGridItemPhotoPadding, _star.bounds.size}];
            [self addSubview:_star];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPhoto:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)tapOnPhoto:(UIGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateRecognized == gesture.state) {
        if (self.tapHandler) {
            self.tapHandler(self.gridItem);
        }
    }
}

@end
