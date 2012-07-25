//
//  GTIOPullToLoadMoreContentView.m
//  GTIO
//
//  Created by Scott Penrose on 7/18/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)

#import "GTIOPullToLoadMoreContentView.h"

#import "GTIOPostHeaderView.h"

static CGFloat const kGTIOFrameHeight = 60.0f;
static CGFloat const kGTIOArrowOriginX = 291.0f;
static CGFloat const kGTIOActivityIndicatorView = 201.0f;
static CGFloat const kGTIOStatusLabelWidth = 75.0f;
static CGFloat const kGTIOPaddingBetweenControls = 5.0f;

static CGFloat const kGTIOTopOffset = -5.0f;
static CGFloat const kGTIOCustomFontOffset = 2;

@interface GTIOPullToLoadMoreContentView()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *topAccentLine;

@end

@implementation GTIOPullToLoadMoreContentView

@synthesize statusLabel = _statusLabel, activityIndicatorView = _activityIndicatorView, topAccentLine = _topAccentLine;
@synthesize shouldShowTopAccentLine = _shouldShowTopAccentLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:(CGRect){ self.frame.origin, { self.frame.size.width, kGTIOFrameHeight } }];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
        _statusLabel.font = [UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:10.0];
        _statusLabel.textAlignment = UITextAlignmentLeft;
        [self addSubview:_statusLabel];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView setTransform:CGAffineTransformMakeScale(0.75, 0.75)];
		[self addSubview:_activityIndicatorView];
        
        // Accent line
        _topAccentLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accent-line.png"]];
        [_topAccentLine setHidden:YES];
        [self addSubview:_topAccentLine];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_statusLabel setFrame:(CGRect){ { self.bounds.size.width - kGTIOStatusLabelWidth - kGTIOAccentLinePixelsFromRightSizeOfScreen, (self.frame.size.height - 20) / 2 + kGTIOCustomFontOffset + kGTIOTopOffset }, { kGTIOStatusLabelWidth, 20 } }];
    [_activityIndicatorView setFrame:(CGRect){ { _statusLabel.frame.origin.x - _activityIndicatorView.frame.size.width - kGTIOPaddingBetweenControls, (self.bounds.size.height - _activityIndicatorView.frame.size.height) / 2 + kGTIOTopOffset }, _activityIndicatorView.frame.size }];
    [_topAccentLine setFrame:(CGRect){ { self.frame.size.width - kGTIOAccentLinePixelsFromRightSizeOfScreen, 0 }, { _topAccentLine.image.size.width, self.frame.size.height } }];
}

- (void)setState:(SSPullToLoadMoreViewState)state withPullToLoadMoreView:(SSPullToLoadMoreView *)view
{
    self.activityIndicatorView.hidden = YES;
    self.statusLabel.textColor = [UIColor gtio_grayTextColor8F8F8F];
    
    switch (state) {
        case SSPullToLoadMoreViewStateNormal:
            self.statusLabel.text = @"";
            break;
        case SSPullToLoadMoreViewStateReady:
            self.statusLabel.text = @"";
            [self.topAccentLine setHidden:!self.shouldShowTopAccentLine];
            break;
        case SSPullToLoadMoreViewStateLoading:
            self.statusLabel.text = @"loading more...";
            self.statusLabel.textColor = [UIColor gtio_grayTextColor585858];
            self.activityIndicatorView.hidden = NO;
            [self.activityIndicatorView startAnimating];
            break;
        case SSPullToLoadMoreViewStateClosing:
            [self.activityIndicatorView stopAnimating];
            break;
        default:
            self.statusLabel.text = @"";
            break;
    }
}

@end
