//
//  GTIOPullToRefreshContentView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)

#import "GTIOPullToRefreshContentView.h"

@interface GTIOPullToRefreshContentView()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation GTIOPullToRefreshContentView

@synthesize background = _background, statusLabel = _statusLabel, activityIndicatorView = _activityIndicatorView, arrow = _arrow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptr-bg.png"]];
        [self addSubview:_background];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor gtio_grayTextColor];
        _statusLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:10.0];
        _statusLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_statusLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:_activityIndicatorView];
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptr-arrow.png"]];
        _arrow.frame = (CGRect){ 291, 90, self.arrow.image.size };
        [self addSubview:_arrow];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.background.frame = (CGRect){ 0, -9, self.bounds.size };
    self.statusLabel.frame = (CGRect){ self.bounds.size.width - 100 - 51, self.bounds.size.height - 37, 100, 20 };
    self.activityIndicatorView.frame = (CGRect){ 201, self.bounds.size.height - self.activityIndicatorView.bounds.size.height - 22, 10, 10 };
}

- (void)setPullProgress:(CGFloat)pullProgress
{
    if (pullProgress <= 1.0 && pullProgress >= 0.0) {
        self.arrow.transform = CGAffineTransformMakeRotation(degreesToRadians(180 * pullProgress));
    }
}

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view
{
    self.activityIndicatorView.hidden = YES;
    self.statusLabel.textColor = [UIColor gtio_grayTextColor];
    
    switch (state) {
        case SSPullToRefreshViewStateNormal:
            self.statusLabel.text = @"pull down to update";
            break;
        case SSPullToRefreshViewStateReady:
            self.statusLabel.text = @"release to update";
            break;
        case SSPullToRefreshViewStateLoading:
            self.statusLabel.text = @"updating...";
            self.statusLabel.textColor = [UIColor gtio_grayTextColor585858];
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
            break;
        case SSPullToRefreshViewStateClosing:
            [self.activityIndicatorView stopAnimating];
            break;
        default:
            self.statusLabel.text = @"pull down to update";
            break;
    }
}

@end
