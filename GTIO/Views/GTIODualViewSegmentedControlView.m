//
//  GTIODualViewSegmentedControlView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/25/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIODualViewSegmentedControlView.h"
#import "GTIOSegmentedControl.h"
#import "GTIOPostMasonryView.h"

@interface GTIODualViewSegmentedControlView()

@property (nonatomic, strong) GTIOSegmentedControl *dualViewSegmentedControl;

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
        NSArray *segmentedControlItems = [NSArray arrayWithObjects:leftControlTitle, rightControlTitle, nil];
        self.dualViewSegmentedControl = [[GTIOSegmentedControl alloc] initWithItems:segmentedControlItems];
        [self.dualViewSegmentedControl setFrame:CGRectZero];
        [self.dualViewSegmentedControl setSelectedSegmentIndex:0];
        [self.dualViewSegmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.dualViewSegmentedControl];
        
        self.leftPostsView = [[GTIOPostMasonryView alloc] initWithGTIOPostType:leftControlPostsType];
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

- (void)setPosts:(NSArray *)posts GTIOPostType:(GTIOPostType)postType userProfile:(GTIOUserProfile *)userProfile
{
    if (postType == self.leftConrolPostsType) {
        [self.leftPostsView setPosts:posts userProfile:userProfile];
    } else if (postType == self.rightControlPostsType) {
        [self.rightPostsView setPosts:posts userProfile:userProfile];
    }
    [self setNeedsLayout];
}

@end
