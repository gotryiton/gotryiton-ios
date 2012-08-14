//
//  GTIOLooksSegmentedControlView.m
//  GTIO
//
//  Created by Scott Penrose on 7/16/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOLooksSegmentedControlView.h"

#import "GTIOTab.h"

CGFloat const kGTIOLooksSegmentedControlViewHeight = 36.0f;

static CGFloat const kGTIOSegmentedControlHeight = 26.0f;
static CGFloat const kGTIOSegmentedControlPadding = 4.0f;
static CGFloat const kGTIOSegmentedControlTopPadding = 5.0f;
static CGFloat const kGTIOSegmentedControlVerticalTextOffset = 3.0f;
static CGFloat const kGTIOTextPadding = 12.0f;

static CGFloat const kGTIOMinTabWidth4Tabs = 83.0f;
static CGFloat const kGTIOMinTabWidth3Tabs = 100.0f;
static CGFloat const kGTIODividerPadding = 6.0f;

static NSString * const kGTIOFeaturedTab = @"featured";

@interface GTIOLooksSegmentedControlView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation GTIOLooksSegmentedControlView

@synthesize scrollView = _scrollView, segmentedControl = _segmentedControl, arrowImageView = _arrowImageView;
@synthesize tabs = _tabs;
@synthesize segmentedControlValueChangedHandler = _segmentedControlValueChangedHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ frame.origin, { frame.size.width, kGTIOLooksSegmentedControlViewHeight } }];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-bg.png"]];
        [self addSubview:backgroundImageView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setScrollsToTop:NO];
        [self addSubview:_scrollView];
        
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:(CGRect){ { kGTIOSegmentedControlPadding, kGTIOSegmentedControlTopPadding }, CGSizeZero }];
        
        [_segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIImage *unselectedImage = [UIImage imageNamed:@"tab-unselected.png"];
        UIImage *selectedImage = [UIImage imageNamed:@"tab-selected.png"];
        
        UIImage *nnDivider = [UIImage imageNamed:@"tab-divider-uns-uns.png"];
        UIImage *snDivider = [UIImage imageNamed:@"tab-divider-sel-uns.png"];
        UIImage *nsDivider = [UIImage imageNamed:@"tab-divider-uns-sel.png"];
        
        [_segmentedControl setBackgroundImage:unselectedImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setBackgroundImage:selectedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        UIFont *font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:11.0f];
        [_segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor gtio_grayTextColor8F8F8F], UITextAttributeTextColor,  
                                                   font, UITextAttributeFont,
                                                   nil] 
                                         forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor gtio_grayTextColor555556], UITextAttributeTextColor,  
                                                   font, UITextAttributeFont,
                                                   [UIColor clearColor], UITextAttributeTextShadowColor,
                                                   nil] 
                                         forState:UIControlStateSelected];
        
        [_segmentedControl setDividerImage:nnDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:snDivider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:nsDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [_segmentedControl setContentPositionAdjustment:(UIOffset){ 0, kGTIOSegmentedControlVerticalTextOffset } forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
        
        [_scrollView addSubview:_segmentedControl];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-selected-pointer-inactive.png"]];
    }
    return self;
}

- (void)setTabs:(NSArray *)tabs
{
    _tabs = tabs;
    
    [self.segmentedControl removeAllSegments];
    __block NSInteger selectedIndex = 0;
    __block CGFloat totalTabWidth = 0.0f;
    [_tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GTIOTab *tab = obj;
        
        CGFloat tabWidth = 0.0f;
        
        if ([tab.text isEqualToString:kGTIOFeaturedTab]) {
            UIImage *featuredImage = [UIImage imageNamed:@"tab-label-featured-unselected.png"];
            [self.segmentedControl insertSegmentWithImage:featuredImage atIndex:idx animated:NO];
            
            tabWidth = 0.0f; // We want this to set to the min size everytime
        } else {
            [self.segmentedControl insertSegmentWithTitle:tab.text atIndex:idx animated:NO];
            
            CGSize textSize = [tab.text sizeWithFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:11.0f]];
            tabWidth = textSize.width + 2 * kGTIOTextPadding;
        }
        
        // Tab Widths
        if ([self.tabs count] > 3) {
            if (tabWidth < kGTIOMinTabWidth4Tabs) {
                tabWidth = kGTIOMinTabWidth4Tabs;
            }
        } else {
            if (tabWidth < kGTIOMinTabWidth3Tabs) {
                tabWidth = kGTIOMinTabWidth3Tabs;
            }
        }
        
        totalTabWidth += tabWidth;
        [self.segmentedControl setWidth:tabWidth forSegmentAtIndex:idx];
        
        if (tab.selected.boolValue) {
            selectedIndex = idx;
        }
    }];
    
    totalTabWidth += ([self.tabs count] - 1) * kGTIODividerPadding;
    
    [self.scrollView setContentSize:(CGSize){ totalTabWidth + 2 * kGTIOSegmentedControlPadding, self.scrollView.frame.size.height }];
    [self.segmentedControl setFrame:(CGRect){ self.segmentedControl.frame.origin, { totalTabWidth, kGTIOSegmentedControlHeight } }];
    [self.segmentedControl setSelectedSegmentIndex:selectedIndex];
    [self valueChanged:self.segmentedControl];
}

#pragma mark - Image

- (void)updateImagesForSelectedIndex
{
    GTIOTab *tab = [self.tabs objectAtIndex:self.segmentedControl.selectedSegmentIndex];
    if ([tab.text isEqualToString:kGTIOFeaturedTab]) {
        [self.segmentedControl setImage:[UIImage imageNamed:@"tab-label-featured-selected.png"] forSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    } else {
        [self.tabs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GTIOTab *tab = obj;
            if ([tab.text isEqualToString:kGTIOFeaturedTab]) {
                [self.segmentedControl setImage:[UIImage imageNamed:@"tab-label-featured-unselected.png"] forSegmentAtIndex:idx];
                *stop = YES;
            }
        }];
    }
}

- (void)placeArrowAtCenterOfSelectedSegment:(CGFloat)centerOfSelectedSegment
{
    [self.arrowImageView setCenter:(CGPoint){ centerOfSelectedSegment, 31.5 }];
    [_scrollView addSubview:_arrowImageView];
}

#pragma mark - Scroll Helpers

- (CGFloat)centerOfSelectedSegment
{
    NSInteger selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    CGFloat segmentWidths = [self.segmentedControl widthForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    
    CGFloat totalSegmentWidths = 0.0;
    for (int i = 0; i<self.segmentedControl.selectedSegmentIndex+1; i++ ){
        totalSegmentWidths += [self.segmentedControl widthForSegmentAtIndex:i];
    }
    totalSegmentWidths -= (segmentWidths / 2);
    
    CGFloat totalSegmentDividerWidths = (selectedSegmentIndex* kGTIODividerPadding);
    CGFloat centerOfSelectedSegment = kGTIOSegmentedControlPadding + totalSegmentWidths  + totalSegmentDividerWidths;
    
    return centerOfSelectedSegment;
}

- (void)scrollToCenterOfSelectedSegment:(CGFloat)centerOfSelectedSegment
{
    CGRect scrollRect = (CGRect){ { centerOfSelectedSegment - (self.scrollView.frame.size.width / 2), 0 }, { self.scrollView.frame.size.width, kGTIOLooksSegmentedControlViewHeight } };
    [self.scrollView scrollRectToVisible:scrollRect animated:YES];
}

#pragma mark - Event Handlers

- (void)valueChanged:(id)sender
{
    [self updateImagesForSelectedIndex];
    
    CGFloat centerOfSelectedSegment = [self centerOfSelectedSegment];
    [self placeArrowAtCenterOfSelectedSegment:centerOfSelectedSegment];
    [self scrollToCenterOfSelectedSegment:centerOfSelectedSegment];
    
    if (self.segmentedControlValueChangedHandler) {
        self.segmentedControlValueChangedHandler([self.tabs objectAtIndex:self.segmentedControl.selectedSegmentIndex]);
    }
}

@end
