//
//  GTIOActionSheet.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GTIOActionSheet;
@class GTIOButton;

typedef void(^GTIOActionSheetBlock)(GTIOActionSheet *actionSheet);
typedef void(^GTIOActionSheetButtonTapHandler)(GTIOButton *buttonModel);

@interface GTIOActionSheet : UIView

@property (nonatomic, copy) GTIOActionSheetBlock willDismiss;
@property (nonatomic, copy) GTIOActionSheetBlock didDismiss;
@property (nonatomic, copy) GTIOActionSheetBlock willPresent;
@property (nonatomic, copy) GTIOActionSheetBlock didPresent;
@property (nonatomic, copy) GTIOActionSheetBlock willCancel;
@property (nonatomic, copy) GTIOActionSheetButtonTapHandler buttonTapHandler;

@property (nonatomic, strong) UIView *windowMask;

@property (nonatomic, assign) BOOL wasCancelled;

- (id)initWithButtons:(NSArray *)buttons buttonTapHandler:(GTIOActionSheetButtonTapHandler)buttonTapHandler;
- (void)show;
- (void)showWithConfigurationBlock:(GTIOActionSheetBlock)configurationBlock;
- (void)dismiss;

@end