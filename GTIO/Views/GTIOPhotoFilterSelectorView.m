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
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        NSInteger filters[] = { GTIOFilterOriginal, GTIOFilterClementine, GTIOFilterColombe, GTIOFilterHenrik, GTIOFilterDiesel, GTIOFilterIIRG, GTIOFilterLafayette, GTIOFilterLispenard, GTIOFilterWalker };
        
        CGFloat xOrigin = kGTIOFilterViewPadding;
        for (int i = 0; i < (sizeof filters)/(sizeof filters[0]); i++) {
            GTIOPhotoFilterView *filterView = [[GTIOPhotoFilterView alloc] initWithFrame:(CGRect){ { xOrigin, 5 }, { 69, 90 } } filter:filters[i] filterSelected:i == 0];
            [_scrollView addSubview:filterView];
            xOrigin += filterView.frame.size.width + 3;
        }
        xOrigin += kGTIOFilterViewPadding;
        
        [_scrollView setContentSize:(CGSize){ xOrigin, frame.size.height }];
    }
    return self;
}

@end
