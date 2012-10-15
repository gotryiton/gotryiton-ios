//
//  GTIOAlertView.m
//  GTIO
//
//  Created by Duncan Lewis on 9/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOAlertView.h"
#import "GTIOLargeButton.h"

static CGFloat const kGTIODialogWidth = 284.0f;
static CGFloat const kGTIODialogLeftOffsetToContentArea = 16.0f;
static CGFloat const kGTIODialogMaxHeightOfMessageLabel = 220.0f;
static CGFloat const kGTIODialogTitleOffsetFromTopOfDialog = 24.0f;
static CGFloat const kGTIODialogMessageTopOffset = 38.0f;
static CGFloat const kGTIODialogMessageTopOffsetWithoutTitle = 29.0f;
static CGFloat const kGTIODialogMessageLeftRightOffsetFromSideOfDialog = 23.0f;
static CGFloat const kGTIODialogButtonOffsetFromBottomOfDialog = 17.0f;
static CGFloat const kGTIODialogButtonOffsetFromBottomOfMessage = 21.0f;
static CGFloat const kGTIODialogButtonOffsetFromSidesOfDialog = 16.0f;
static CGFloat const kGTIODialogButtonHeight = 42.0f;
static CGFloat const kGTIODialogButtonPadding = 10.0f;

@interface GTIOAlertView()

@property (nonatomic, weak) UIView *darkenedBackground;
@property (nonatomic, weak) UIImageView *dialogBackground;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) GTIOLargeButton *cancelButton;
@property (nonatomic, weak) GTIOLargeButton *otherButton;

@end

@implementation GTIOAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<GTIOAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle cancelButtonBlock:nil otherButtonBlock:nil];
    if (self) {
        // customization
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<GTIOAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{   
    return [self initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitles];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<GTIOAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle cancelButtonBlock:(GTIOAlertViewButtonActionBlock)cancelButtonBlock otherButtonBlock:(GTIOAlertViewButtonActionBlock)otherButtonBlock
{
    self = [super init];
    if (self) {
        
        self.cancelButtonBlock = cancelButtonBlock;
        self.otherButtonBlock = otherButtonBlock;
        
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        
        [self setupView];
        
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}

#pragma mark - Helpers

- (void)setupView
{
    // setup dark background
    UIView *darkenedBackground = [[UIView alloc] init];
    [darkenedBackground setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [self addSubview:darkenedBackground];
    self.darkenedBackground = darkenedBackground;
    
    // setup dialog background
    UIImageView *dialogBackground = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"alert.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(11.0f, 13.0f, 14.0f, 13.0f)]];
    // dialog is currently a fixed size
    [dialogBackground setFrame:(CGRect){0.0f,0.0f,kGTIODialogWidth,185.0f}];
    [dialogBackground setUserInteractionEnabled:YES];
    [self addSubview:dialogBackground];
    self.dialogBackground = dialogBackground;
    
    // add titles and buttons as subviews to self.dialogBackground
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherLightItal size:22.0f]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setText:self.title];
    [self.dialogBackground addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[UIFont gtio_verlagFontWithWeight:GTIOFontVerlagLight size:16.0f]];
    [messageLabel setTextColor:[UIColor gtio_grayTextColor8F8F8F]];
    [messageLabel setTextAlignment:UITextAlignmentCenter];
    [messageLabel setText:self.message];
    [messageLabel setNumberOfLines:5];
    [self.dialogBackground addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    GTIOLargeButton *cancelButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleGray];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if([self.cancelButtonTitle length] > 0) {
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    } else {
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    [cancelButton setTitleColor:[UIColor gtio_grayTextColor8F8F8F] forState:UIControlStateNormal];
    [self.dialogBackground addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    if([self.otherButtonTitle length] > 0) {
        GTIOLargeButton *otherButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleGreen];
        [otherButton addTarget:self action:@selector(otherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [otherButton setTitle:self.otherButtonTitle forState:UIControlStateNormal];
        [otherButton setTitleColor:[UIColor gtio_grayTextColor555556] forState:UIControlStateNormal];
        [self.dialogBackground addSubview:otherButton];
        self.otherButton = otherButton;
    } else {
        self.otherButton = nil;
    }
}

- (void)sizeViewInWindow:(UIWindow *)window
{
    // setup sizing
    [self setFrame:window.bounds];
    [self.darkenedBackground setFrame:window.bounds];

    // grab sizes of strings
    CGSize titleTextSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font forWidth:self.dialogBackground.bounds.size.width-(2*kGTIODialogLeftOffsetToContentArea) lineBreakMode:UILineBreakModeTailTruncation];
    CGSize messageTextSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:CGSizeMake(self.dialogBackground.bounds.size.width - (2*kGTIODialogMessageLeftRightOffsetFromSideOfDialog), kGTIODialogMaxHeightOfMessageLabel) lineBreakMode:UILineBreakModeWordWrap];


    // all of these are subviews of the dialogBackground, sizing is relative to its frame
    [self.titleLabel setFrame:(CGRect){ kGTIODialogLeftOffsetToContentArea, kGTIODialogTitleOffsetFromTopOfDialog, self.dialogBackground.bounds.size.width-(2*kGTIODialogLeftOffsetToContentArea), (self.titleLabel.text.length == 0) ? 0 : titleTextSize.height }];
 
    [self.messageLabel setFrame:(CGRect){ kGTIODialogMessageLeftRightOffsetFromSideOfDialog, (self.titleLabel.text.length == 0) ? kGTIODialogMessageTopOffsetWithoutTitle : self.titleLabel.frame.origin.y + kGTIODialogMessageTopOffset, self.dialogBackground.bounds.size.width - (2*kGTIODialogMessageLeftRightOffsetFromSideOfDialog), messageTextSize.height }];
    
    if(!self.otherButton) {
        [self.cancelButton setFrame:(CGRect){ kGTIODialogButtonOffsetFromSidesOfDialog, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + kGTIODialogButtonOffsetFromBottomOfMessage, self.dialogBackground.bounds.size.width - (2*kGTIODialogButtonOffsetFromSidesOfDialog), kGTIODialogButtonHeight }];
    } else {
        [self.cancelButton setFrame:(CGRect){ kGTIODialogButtonOffsetFromSidesOfDialog, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + kGTIODialogButtonOffsetFromBottomOfMessage, floorf( (self.dialogBackground.bounds.size.width - (2*kGTIODialogButtonOffsetFromSidesOfDialog) - kGTIODialogButtonPadding) / 2.0f), kGTIODialogButtonHeight }];
        [self.otherButton setFrame:(CGRect) { self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width + kGTIODialogButtonPadding,self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + kGTIODialogButtonOffsetFromBottomOfMessage, floorf( (self.dialogBackground.bounds.size.width - (2*kGTIODialogButtonOffsetFromSidesOfDialog) - kGTIODialogButtonPadding) / 2.0f), kGTIODialogButtonHeight }];
    }

    CGFloat heightOfDialog = self.cancelButton.frame.origin.y + kGTIODialogButtonHeight + kGTIODialogButtonOffsetFromBottomOfDialog;
    [self.dialogBackground setFrame:(CGRect){ window.bounds.size.width/2 - kGTIODialogWidth/2, window.bounds.size.height/2 - heightOfDialog/2 , kGTIODialogWidth, heightOfDialog}];
}

#pragma mark - Presentation and dismiss methods

- (void)show
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self sizeViewInWindow:mainWindow];
    
    [self setAlpha:0.0f];
    [mainWindow addSubview:self];
    
    if([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setAlpha:1.0f];
                     }
                     completion:^(BOOL finished) {
                         if([self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
                             [self.delegate didPresentAlertView:self];
                         }
                     }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated
{
    if([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:index];
    }
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
                             [self.delegate alertView:self didDismissWithButtonIndex:index];
                         }
                     }];
}

#pragma mark - Button Action Methods

- (void)cancelButtonAction:(id)sender {
    if(self.cancelButtonBlock != nil) {
        self.cancelButtonBlock();
    } else {
        if([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:0];
        }
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)otherButtonAction:(id)sender {
    if(self.otherButtonBlock != nil) {
        self.otherButtonBlock();
    } else {
        if([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:1];
        }
    }
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

@end
