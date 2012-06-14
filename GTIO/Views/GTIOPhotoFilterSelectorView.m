//
//  GTIOPhotoFilterSelecterView.m
//  GTIO
//
//  Created by Scott Penrose on 6/11/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhotoFilterSelectorView.h"

#import "GTIOPhotoFilterView.h"

static CGFloat const kGTIOFilterViewPadding = 5.0f;

@interface GTIOPhotoFilterSelectorView () <GTIOPhotoFilterViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, getter = isSelectedPhotoFilterView) GTIOPhotoFilterView *selectedPhotoFilterView;

@end

@implementation GTIOPhotoFilterSelectorView

@synthesize scrollView = _scrollView;
@synthesize selectedPhotoFilterView = _selectedPhotoFilterView;
@synthesize photoFilterSelectedHandler = _photoFilterSelectedHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, 101 } }];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"upload.filter.shadow.bg.png"]]];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        CGFloat xOrigin = kGTIOFilterViewPadding;
        for (int i = 0; i < (sizeof GTIOFilterOrder)/(sizeof GTIOFilterOrder[0]); i++) {
            GTIOPhotoFilterView *filterView = [[GTIOPhotoFilterView alloc] initWithFrame:(CGRect){ { xOrigin, 5 }, { 69, 90 } } filterType:GTIOFilterOrder[i] filterSelected:i == 0];
            [filterView setDelegate:self];
            [_scrollView addSubview:filterView];
            xOrigin += filterView.frame.size.width + 3;
            
            if (filterView.isFilterSelected) {
                _selectedPhotoFilterView = filterView;
            }
        }
        xOrigin += kGTIOFilterViewPadding;
        
        [_scrollView setContentSize:(CGSize){ xOrigin, frame.size.height }];
    }
    return self;
}

#pragma mark - GTIOPhotoFilterViewDelegate

- (void)didSelectFilterView:(GTIOPhotoFilterView *)filterView
{
    [self.selectedPhotoFilterView setFilterSelected:NO];
    self.selectedPhotoFilterView = filterView;
    [filterView setFilterSelected:YES];
    
    if (self.photoFilterSelectedHandler) {
        self.photoFilterSelectedHandler(filterView.filterType);
    }
}

@end
