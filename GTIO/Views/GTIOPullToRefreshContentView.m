//
//  GTIOPullToRefreshContentView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPullToRefreshContentView.h"

@interface GTIOPullToRefreshContentView()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation GTIOPullToRefreshContentView

@synthesize statusLabel = _statusLabel, activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor gtio_grayTextColor];
        _statusLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:10.0];
        _statusLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_statusLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:_activityIndicatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.statusLabel.frame = (CGRect){ self.bounds.size.width - 100 - 51, self.bounds.size.height - 20 - 14, 100, 20 };
    self.activityIndicatorView.frame = (CGRect){ 195, self.statusLabel.frame.origin.y, 15, 15 };
}

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view
{
    self.activityIndicatorView.hidden = YES;
    switch (state) {
        case SSPullToRefreshViewStateNormal:
            self.statusLabel.text = @"pull down to update";
            break;
        case SSPullToRefreshViewStateReady:
            self.statusLabel.text = @"release to update";
            break;
        case SSPullToRefreshViewStateLoading:
            self.statusLabel.text = @"updating...";
            self.activityIndicatorView.hidden = NO;
            break;
        default:
            self.statusLabel.text = @"pull down to update";
            break;
    }
}

@end
