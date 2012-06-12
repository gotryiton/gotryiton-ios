//
//  GTIOPhotoFilterView.m
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoFilterView.h"

@interface GTIOPhotoFilterView ()

@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *overlayImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GTIOPhotoFilterView

@synthesize filter = _filter, filterSelected = _filterSelected;
@synthesize selectedImageView = _selectedImageView, pictureImageView = _pictureImageView, titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image name:(NSString *)name filterSelected:(BOOL)filterSelected
{
    self = [self initWithFrame:frame];
    if (self) {
        _filterSelected = filterSelected;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { 70, 90 } }];
        
        _selectedImageView = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, { 69, 69 } }];
        [self addSubview:_backgroundImageView];
        
        _pictureImageView = [[UIImageView alloc] initWithFrame:(CGRect){ 3, 3, 61, 61 }];
        [self addSubview:_pictureImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, _backgroundImageView.frame.size.height, self.frame.size.width, 20}];
        [_titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:10.0f]];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
        
        _filterSelected = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.pictureImageView setImage:self.image];
    [self.titleLabel setText:[self.name uppercaseString]];
    
    CGFloat textAlpha = 60.0f;
    NSString *bgImageName = @"upload.filter.overlay.png";
    if (self.filterSelected) {
        textAlpha = 80.0f;
        bgImageName = @"upload.filter.overlay.selected.png";
    }
    [self.titleLabel setAlpha:textAlpha];
    [self.backgroundImageView setImage:[UIImage imageNamed:bgImageName]];
}

#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsLayout];
}

- (void)setName:(NSString *)name
{
    _name = name;
    [self setNeedsLayout];
}

- (void)setFilterSelected:(BOOL)filterSelected
{
    _filterSelected = filterSelected;
    [self setNeedsLayout];   
}

@end
