//
//  GTIOAlertView.h
//  GTIO
//
//  Created by Duncan Lewis on 9/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GTIOAlertViewButtonActionBlock)(void);

@class GTIOAlertView;

@protocol GTIOAlertViewDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(GTIOAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(GTIOAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(GTIOAlertView *)alertView;  // after animation

- (void)alertView:(GTIOAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(GTIOAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

@interface GTIOAlertView : UIView

@property (nonatomic, weak) id<GTIOAlertViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;
@property (nonatomic, copy) GTIOAlertViewButtonActionBlock cancelButtonBlock;
@property (nonatomic, copy) GTIOAlertViewButtonActionBlock otherButtonBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<GTIOAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<GTIOAlertViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle cancelButtonBlock:(GTIOAlertViewButtonActionBlock)cancelButtonBlock otherButtonBlock:(GTIOAlertViewButtonActionBlock)otherButtonBlock;
- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)index animated:(BOOL)animated;

@end