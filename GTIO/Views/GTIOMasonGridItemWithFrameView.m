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
        [_gridFrameImageView setFrame:self.bounds];
        [self addSubview:_gridFrameImageView];
        
        // Actual image
        _imageView = [[UIImageView alloc] initWithImage:image];
        [_imageView setFrame:(CGRect){ { kGTIOGridItemPhotoPadding, kGTIOGridItemPhotoPadding }, image.size }];
        [self addSubview:_imageView];
    }
    return self;
}

@end
