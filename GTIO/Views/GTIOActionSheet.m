//
//  GTIOActionSheet.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOActionSheet.h"
#import "GTIOButton.h"
#import "GTIOProgressHUD.h"
#import <RestKit/RestKit.h>
#import "GTIOLargeButton.h"

static double const containerPadding = 14.0;
static double const buttonSpacing = 8.0;
static double const cancelButtonTopMargin = 16.0;
static double const buttonHeight = 42.0;
static double const buttonWidth = 292.0;

@interface GTIOActionSheet()

@property (nonatomic, strong) GTIOUIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *otherButtons;
@property (nonatomic, strong) UIImageView *buttonsContainer;

@property (nonatomic, assign) BOOL buttonsVisible;
@property (nonatomic, assign) double buttonsContainerHeight;

@end

@implementation GTIOActionSheet

@synthesize cancelButton = _cancelButton, otherButtons = _otherButtons, windowMask = _windowMask, buttonsContainer = _buttonsContainer, buttonsVisible = _buttonsVisible, buttonsContainerHeight = _buttonsContainerHeight;
@synthesize willDismiss = _willDismiss, didDismiss = _didDismiss, willPresent = _willPresent, didPresent = _didPresent, willCancel = _willCancel, wasCancelled = _wasCancelled;

- (id)initWithButtons:(NSArray *)buttons
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self) {
        _cancelButton = [GTIOLargeButton gtio_largeCancelButton];
        __block typeof(self) blockSelf = self;
        _cancelButton.tapHandler = ^(id sender) {
            if (blockSelf.willCancel) {
                blockSelf.willCancel(blockSelf);
            }
            self.wasCancelled = YES;
            [blockSelf dismiss];
        };
        _otherButtons = [NSMutableArray array];
        
        _windowMask = [[UIView alloc] initWithFrame:CGRectZero];
        _windowMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.50];
        _windowMask.alpha = 0.0;
        _windowMask.opaque = YES;
        
        _buttonsContainer = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"actionsheet.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18.0, 0.0, 18.0, 0.0)]];
        _buttonsContainer.userInteractionEnabled = YES;
        [_windowMask addSubview:_buttonsContainer];
        
        [_buttonsContainer addSubview:_cancelButton];
        for (GTIOButton *button in buttons) {
            GTIOUIButton *actionSheetButton = nil;
            switch (button.state.intValue) {
                case 0: actionSheetButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleGray]; break;
                case 1: actionSheetButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleGreen]; break;
                case 2: actionSheetButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleRed]; break;
                default: actionSheetButton = [GTIOLargeButton largeButtonWithGTIOStyle:GTIOLargeButtonStyleGray]; break;
            }
            [actionSheetButton setTitle:button.text forState:UIControlStateNormal];
            actionSheetButton.tapHandler = ^(id sender) {
                [GTIOProgressHUD showHUDAddedTo:self.windowMask animated:YES];
                [[RKObjectManager sharedManager] loadObjectsAtResourcePath:button.action.endpoint usingBlock:^(RKObjectLoader *loader) {
                    loader.onDidLoadResponse = ^(RKResponse *response) {
                        [GTIOProgressHUD hideHUDForView:self.windowMask animated:YES];
                        [self dismiss];
                    };
                    loader.onDidFailWithError = ^(NSError *error) {
                        [GTIOProgressHUD hideHUDForView:self.windowMask animated:YES];
                        NSLog(@"%@", [error localizedDescription]);
                    };
                }];
            };
            [_otherButtons addObject:actionSheetButton];
            [_buttonsContainer addSubview:actionSheetButton];
        }
        
        _buttonsContainerHeight = containerPadding * 2 + (_otherButtons.count + 1) * (buttonSpacing + buttonHeight) + cancelButtonTopMargin;
        
        _wasCancelled = NO;
    }
    return self;
}

- (void)showWithConfigurationBlock:(GTIOActionSheetBlock)configurationBlock
{
    if (configurationBlock) {
        configurationBlock(self);
    }
    
    if (self.willPresent) {
        self.willPresent(self);
    }
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [self.windowMask setFrame:(CGRect){ 0, 0, mainWindow.bounds.size }];
    [self.cancelButton setFrame:(CGRect){ containerPadding, self.buttonsContainerHeight - buttonHeight - containerPadding, buttonWidth, buttonHeight }];
    double otherButtonsYPosition = self.cancelButton.frame.origin.y - cancelButtonTopMargin - buttonHeight;
    for (GTIOUIButton *button in self.otherButtons) {
        [button setFrame:(CGRect){ containerPadding, otherButtonsYPosition, buttonWidth, buttonHeight }];
        otherButtonsYPosition -= buttonSpacing + buttonHeight;
    }
    [self.buttonsContainer setFrame:(CGRect){ 0, self.windowMask.bounds.size.height, self.windowMask.bounds.size.width, self.buttonsContainerHeight }];
    [mainWindow insertSubview:self.windowMask aboveSubview:mainWindow];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.windowMask.alpha = 1.0;
        CGRect buttonContainerRect = self.buttonsContainer.frame;
        [self.buttonsContainer setFrame:(CGRect){ buttonContainerRect.origin.x, self.windowMask.bounds.size.height - buttonContainerRect.size.height, buttonContainerRect.size }];
    } completion:^(BOOL finished) {
        if (self.didPresent) {
            self.didPresent(self);
        }
    }];
}

- (void)show
{
    [self showWithConfigurationBlock:nil];
}

- (void)dismiss
{
    if (self.willDismiss) {
        self.willDismiss(self);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.windowMask.alpha = 0;
        CGRect buttonContainerRect = self.buttonsContainer.frame;
        [self.buttonsContainer setFrame:(CGRect){ buttonContainerRect.origin.x, self.windowMask.bounds.size.height, buttonContainerRect.size }];
    } completion:^(BOOL finished) {
        [self.windowMask removeFromSuperview];
        if (self.didDismiss) {
            self.didDismiss(self);
        }
    }];
}

@end
