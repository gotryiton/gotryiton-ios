//
//  GTIODualViewSegmentedControlView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIODualViewSegmentedControlView.h"
#import "GTIOPostMasonryView.h"

NSString * const kGTIOMyHeartsTitle = @"kGTIOMyHeartsTitle";

@interface GTIODualViewSegmentedControlView()

@property (nonatomic, assign) GTIOPostType leftConrolPostsType;
@property (nonatomic, assign) GTIOPostType rightControlPostsType;

@end

@implementation GTIODualViewSegmentedControlView

@synthesize dualViewSegmentedControl = _dualViewSegmentedControl, leftPostsView = _leftPostsView, rightPostsView = _rightPostsView;
@synthesize leftConrolPostsType = _leftConrolPostsType, rightControlPostsType = _rightControlPostsType;

- (id)initWithFrame:(CGRect)frame leftControlTitle:(NSString *)leftControlTitle leftControlPostsType:(GTIOPostType)leftControlPostsType rightControlTitle:(NSString *)rightControlTitle rightControlPostsType:(GTIOPostType)rightControlPostsType
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *segmentedControlItems = [NSMutableArray array];
        if ([leftControlTitle isEqualToString:kGTIOMyHeartsTitle]) {
            [segmentedControlItems addObject:[UIImage imageNamed:@"my.hearts.tab.title.png"]];
        } else {
            [segmentedControlItems addObject:leftControlTitle];
        }
        [segmentedControlItems addObject:rightControlTitle];
        
        self.dualViewSegmentedControl = [[GTIOSegmentedControl alloc] initWithItems:segmentedControlItems];
        [self.dualViewSegmentedControl setFrame:CGRectZero];
        [self.dualViewSegmentedControl setSelectedSegmentIndex:0];
        [self.dualViewSegmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.dualViewSegmentedControl];
        
        self.leftPostsView = [[GTIOPostMasonryView alloc] initWithGTIOPostType:leftControlPostsType];
        self.leftPostsView.hidden = NO;
        [self addSubview:self.leftPostsView];
        self.rightPostsView = [[GTIOPostMasonryView alloc] initWithGTIOPostType:rightControlPostsType];
        self.rightPostsView.hidden = YES;
        [self addSubview:self.rightPostsView];
        
        [self sendSubviewToBack:self.leftPostsView];
        [self sendSubviewToBack:self.rightPostsView];
        
        _leftConrolPostsType = leftControlPostsType;
        _rightControlPostsType = rightControlPostsType;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.dualViewSegmentedControl setFrame:(CGRect){ 0, 0, self.bounds.size.width, 30 }];
    [self.leftPostsView setFrame:(CGRect){ 0, self.dualViewSegmentedControl.frame.origin.y + self.dualViewSegmentedControl.bounds.size.height - 4, self.bounds.size.width, self.bounds.size.height - self.dualViewSegmentedControl.frame.origin.y - self.dualViewSegmentedControl.bounds.size.height + 4 }];
    [self.rightPostsView setFrame:(CGRect){ 0, self.dualViewSegmentedControl.frame.origin.y + self.dualViewSegmentedControl.bounds.size.height - 4, self.bounds.size.width, self.bounds.size.height - self.dualViewSegmentedControl.frame.origin.y - self.dualViewSegmentedControl.bounds.size.height + 4 }];
}

- (void)segmentedControlChanged:(id)sender
{
    GTIOSegmentedControl *segmentedControl = (GTIOSegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.rightPostsView.hidden = YES;
        self.leftPostsView.hidden = NO;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.rightPostsView.hidden = NO;
        self.leftPostsView.hidden = YES;
    }
}

- (void)setItems:(NSArray *)items GTIOPostType:(GTIOPostType)postType userProfile:(GTIOUserProfile *)userProfile
{
    if (postType == self.leftConrolPostsType) {
        [self.leftPostsView setItems:items userProfile:userProfile];
    } else if (postType == self.rightControlPostsType) {
        [self.rightPostsView setItems:items userProfile:userProfile];
    }
    [self setNeedsLayout];
}

@end
