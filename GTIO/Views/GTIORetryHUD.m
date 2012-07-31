//
//  GTIORetryHUD.m
//  GTIO
//
//  Created by Scott Penrose on 7/31/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIORetryHUD.h"

static CGFloat const kGTIOFrameMinHeight = 92.0f;
static CGFloat const kGTIOTextWidth = 86.0f;
static CGFloat const kGTIOTextLeftPadding = 35.0f;
static CGFloat const kGTIOTextTopPadding = 34.0f;
static CGFloat const kGTIOTextBottomPadding = 36.0f;
static CGFloat const kGTIORetryButtonRightPadding = 29.0f;

@interface GTIORetryHUD ()

@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) GTIOUIButton *retryButton;

/**
 * Removes the HUD from its parent view when hidden.
 * Defaults to NO.
 */
@property (nonatomic, assign) BOOL removeFromSuperViewOnHide;
@property (nonatomic, strong) NSDate *showStarted;
@property (nonatomic, assign) BOOL useAnimation;
@property (nonatomic, assign) CGAffineTransform rotationTransform;
@property (nonatomic, assign, getter = isFinished) BOOL finished;

@end

@implementation GTIORetryHUD

+ (GTIORetryHUD *)showHUDAddedTo:(UIView *)view text:(NSString *)text retryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
	GTIORetryHUD *hud = [[GTIORetryHUD alloc] initWithView:view];
    hud.retryHandler = retryHandler;
    hud.text = text;
	[view addSubview:hud];
	[hud show:YES];
	return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view
{
	GTIORetryHUD *hud = [GTIORetryHUD HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES];
		return YES;
	}
	return NO;
}

+ (GTIORetryHUD *)HUDForView:(UIView *)view {
	GTIORetryHUD *hud = nil;
	NSArray *subviews = view.subviews;
	Class hudClass = [GTIORetryHUD class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			hud = (GTIORetryHUD *)aView;
		}
	}
	return hud;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
        _animationType = MBProgressHUDAnimationFade;
        _rotationTransform = CGAffineTransformIdentity;
        _removeFromSuperViewOnHide = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		[self setupViews];
	}
	return self;
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	id me = [self initWithFrame:view.bounds];
	return me;
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
	_useAnimation = animated;
	// ... otherwise show the HUD imediately
    [self setNeedsDisplay];
    [self showUsingAnimation:_useAnimation];
}

- (void)hide:(BOOL)animated {
	_useAnimation = animated;
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:_useAnimation];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
	self.alpha = 0.0f;
	if (animated && _animationType == GTIORetryHUDAnimationZoom) {
		self.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (_animationType == GTIORetryHUDAnimationZoom) {
			self.transform = _rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && _showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (_animationType == MBProgressHUDAnimationZoom) {
			self.transform = CGAffineTransformConcat(_rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}
		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)done {
	self.finished = YES;
	self.alpha = 0.0f;
	if (_removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

#pragma mark - Views

- (void)setupViews
{
    self.frameImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"connect-error-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 45, 0, 45, 0 }]];
    [self addSubview:self.frameImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.textLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherBookItal size:12.0f]];
    [self.textLabel setTextColor:[UIColor gtio_grayTextColor949494]];
    [self.textLabel setNumberOfLines:0];
    [self.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.textLabel];
    
    self.retryButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeErrorRetry tapHandler:self.retryHandler];
    [self addSubview:self.retryButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat frameHeight = kGTIOTextTopPadding + self.textLabel.frame.size.height + kGTIOTextBottomPadding;
    if (frameHeight < kGTIOFrameMinHeight) {
        frameHeight = kGTIOFrameMinHeight;
    }
    
    [self.frameImageView setFrame:(CGRect){ { (self.bounds.size.width - self.frameImageView.frame.size.width) / 2, (self.bounds.size.height - frameHeight) / 2 }, { self.frameImageView.frame.size.width, frameHeight } }];
    
    CGFloat retryButtonOriginX = self.frameImageView.frame.origin.x + self.frameImageView.frame.size.width - self.retryButton.frame.size.width - kGTIORetryButtonRightPadding;
    [self.retryButton setFrame:(CGRect){ { retryButtonOriginX, (self.bounds.size.height - self.retryButton.frame.size.height) / 2 }, self.retryButton.frame.size }];
    
    CGFloat textLabelOriginX = self.frameImageView.frame.origin.x + kGTIOTextLeftPadding;
    CGFloat textLabelOriginY = (self.bounds.size.height - self.textLabel.frame.size.height) / 2;
    [self.textLabel setFrame:(CGRect){ { textLabelOriginX, textLabelOriginY }, self.textLabel.frame.size }];
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    _text = text;
    [self.textLabel setText:_text];
    
    CGSize textSize = [_text sizeWithFont:self.textLabel.font constrainedToSize:(CGSize){ kGTIOTextWidth, CGFLOAT_MAX } lineBreakMode:self.textLabel.lineBreakMode];
    [self.textLabel setFrame:(CGRect){ CGPointZero, { kGTIOTextWidth, textSize.height } }];
}

- (void)setRetryHandler:(GTIORetryHUDRetryHandler)retryHandler
{
    _retryHandler = [retryHandler copy];
    [self.retryButton setTapHandler:_retryHandler];
}

@end
