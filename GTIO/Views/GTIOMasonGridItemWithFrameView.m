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

@end

@implementation GTIOMasonGridItemWithFrameView

@synthesize gridFrameImageView = _gridFrameImageView, imageView = _imageView;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Image frame with shadow
        _gridFrameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"grid-thumbnail-frame.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 0.0, 6.0, 0.0)]];
        
        // Actual image
        _imageView = [[UIImageView alloc] initWithImage:image];
        
        // Size and position
        [_imageView setFrame:(CGRect){ 0, 0, frame.size }];
        [_gridFrameImageView setFrame:(CGRect){ _imageView.frame.origin.x - 4, _imageView.frame.origin.y - 4, _imageView.bounds.size.width + 8, _imageView.bounds.size.height + 9 }];
        
        [self addSubview:_gridFrameImageView];
        [self addSubview:_imageView];
    }
    return self;
}

@end
