//
//  GTIOPhotoFilterSelecterView.m
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoFilterSelectorView.h"

#import "GTIOPhotoFilterView.h"

@interface GTIOPhotoFilterSelectorView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GTIOPhotoFilterSelectorView

@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 101 } }];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"upload.filter.shadow.bg.png"]]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        
        GTIOPhotoFilterView *originalFilterView = [[GTIOPhotoFilterView alloc] initWithFrame:(CGRect){ { 5, 5 }, { 69, 101 } }];
        [originalFilterView setImage:[UIImage imageNamed:@"filter-thumb-original.png"]];
        [originalFilterView setName:@"Original"];
        [_scrollView addSubview:originalFilterView];
        
        GTIOPhotoFilterView *photoFilterView = [[GTIOPhotoFilterView alloc] initWithFrame:(CGRect){ { 80, 5 }, { 69, 101 } }];
        [photoFilterView setImage:[UIImage imageNamed:@"filter-thumb-diesel.png"]];
        [photoFilterView setName:@"Diesel"];
        [_scrollView addSubview:photoFilterView];
        
        [_scrollView setContentSize:frame.size];
    }
    return self;
}

@end
