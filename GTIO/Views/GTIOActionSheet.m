//
//  GTIOActionSheet.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOActionSheet.h"

@interface GTIOActionSheet()

@property (nonatomic, strong) GTIOButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *otherButtons;
@property (nonatomic, strong) UIView *windowMask;
@property (nonatomic, strong) UIImageView *buttonsContainer;

@property (nonatomic, assign) BOOL buttonsVisible;

@end

@implementation GTIOActionSheet

@synthesize cancelButton = _cancelButton, otherButtons = _otherButtons, windowMask = _windowMask, buttonsContainer = _buttonsContainer;

- (id)initWithCancelButton:(GTIOButton *)cancelButton otherButtons:(GTIOButton *)otherButtons, ...
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        _cancelButton = cancelButton;
        _otherButtons = [NSMutableArray array];
        [_otherButtons addObject:otherButtons];
        va_list args;
        va_start(args, otherButtons);
        GTIOButton *button;
        while( (button = va_arg( args, GTIOButton * )) ) {
            [_otherButtons addObject:button];
        }
        va_end(args);
        
        _windowMask = [[UIView alloc] initWithFrame:CGRectZero];
        _windowMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.50];
        _windowMask.alpha = 0.0;
        UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
        [mainWindow insertSubview:_windowMask aboveSubview:mainWindow];
        
        _buttonsContainer = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"actionsheet.bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18.0, 0.0, 18.0, 0.0)]];
        [_windowMask addSubview:_buttonsContainer];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.windowMask setFrame:(CGRect){ 0, 0, self.window.bounds.size }];
    if (self.buttonsVisible) {
        double containerPadding = 14.0;
        double buttonSpacing = 8.0;
        double cancelButtonTopMargin = 16.0;
        double buttonHeight = 42.0;
        double buttonWidth = 292.0;
        double buttonContainerHeight = containerPadding * 2 + self.otherButtons.count * (buttonSpacing + buttonHeight) + cancelButtonTopMargin;
        [self.buttonsContainer setFrame:(CGRect){ 0, self.windowMask.bounds.size.height - buttonContainerHeight, self.bounds.size.width, buttonContainerHeight }];
        [self.cancelButton setFrame:(CGRect){ containerPadding, self.buttonsContainer.bounds.size.height - buttonHeight - containerPadding, buttonWidth, buttonHeight }];
    }
}

- (void)showWithBlock:(GTIOActionSheetBlock)block
{
    if (block) {
        block(self);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.windowMask.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.buttonsVisible = finished;
    }];
}

@end
