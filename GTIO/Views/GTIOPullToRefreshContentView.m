//
//  GTIOPullToRefreshContentView.m
//  GTIO
//
//  Created by Geoffrey Mackey on 7/5/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)

#import "GTIOPullToRefreshContentView.h"

static CGFloat const kGTIOArrowOriginX = 291.0f;
static CGFloat const kGTIOActivityIndicatorView = 201.0f;
static CGFloat const kGTIOActivityIndicatorOffset = -15.0f;
static CGFloat const kGTIOPullToRefreshYOffset = 8.0f;

@interface GTIOPullToRefreshContentView()

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation GTIOPullToRefreshContentView

@synthesize scrollInsets = _scrollInsets;
@synthesize background = _background, statusLabel = _statusLabel, activityIndicatorView = _activityIndicatorView, arrow = _arrow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptr-bg.png"]];
        [self addSubview:_background];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
        _statusLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:10.0];
        _statusLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_statusLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
		[self addSubview:_activityIndicatorView];
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ptr-arrow.png"]];
        [self addSubview:_arrow];
        
        [self setFrame:(CGRect){ self.frame.origin, { self.frame.size.width, _background.image.size.height } }];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.background.frame = (CGRect){ { 0, self.scrollInsets.top }, self.bounds.size };
    self.statusLabel.frame = (CGRect){ { self.bounds.size.width - 100 - 51, self.bounds.size.height - 37 + self.scrollInsets.top + kGTIOPullToRefreshYOffset }, { 100, 20 } };
    self.activityIndicatorView.frame = (CGRect){ { kGTIOActivityIndicatorView, self.bounds.size.height - self.activityIndicatorView.bounds.size.height + kGTIOActivityIndicatorOffset + self.scrollInsets.top +  kGTIOPullToRefreshYOffset }, self.activityIndicatorView.frame.size };
    self.arrow.frame = (CGRect){ { kGTIOArrowOriginX, 90 + self.scrollInsets.top + kGTIOPullToRefreshYOffset }, self.arrow.image.size };
}

- (void)setScrollInsets:(UIEdgeInsets)scrollInsets
{
    _scrollInsets = scrollInsets;
    [self.arrow setFrame:(CGRect){ { kGTIOArrowOriginX, 90 + self.scrollInsets.top }, self.arrow.image.size }];
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
    self.statusLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
    
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
