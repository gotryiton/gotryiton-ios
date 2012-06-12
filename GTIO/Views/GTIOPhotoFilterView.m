//
//  GTIOPhotoFilterView.m
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoFilterView.h"

#import "GTIOFilterButton.h"

@interface GTIOPhotoFilterView ()

@property (nonatomic, strong) UIButton *filterButton;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GTIOPhotoFilterView

@synthesize filter = _filter, filterSelected = _filterSelected;
@synthesize filterButton = _filterButton, titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame filter:(GTIOFilter)filter filterSelected:(BOOL)filterSelected
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { 69, 90 } }];
        
        _filter = filter;
        _filterSelected = filterSelected;
        
        _filterButton = [GTIOFilterButton buttonWithFilter:filter tapHandler:nil];
        [_filterButton setFrame:(CGRect){ { 0, 6 }, _filterButton.frame.size }]; 
        [self addSubview:_filterButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){ 0, _filterButton.frame.origin.y + _filterButton.frame.size.height, self.frame.size.width, 14}];
        [_titleLabel setFont:[UIFont gtio_proximaNovaFontWithWeight:GTIOFontProximaNovaSemiBold size:8.0f]];
        [_titleLabel setText:[GTIOFilterName[_filter] uppercaseString]];
        [_titleLabel setTextAlignment:UITextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat textAlpha = 0.6f;
    if (self.filterSelected) {
        textAlpha = 0.8f;
    }
    [self.titleLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:textAlpha]];
    [self.filterButton setSelected:self.filterSelected];
}

#pragma mark - Properties

- (void)setFilterSelected:(BOOL)filterSelected
{
    _filterSelected = filterSelected;
    [self setNeedsLayout];
}

@end
