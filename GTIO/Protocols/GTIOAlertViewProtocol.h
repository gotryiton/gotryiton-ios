//
//  GTIOAlertViewProtocol.h
//  GTIO
//
//  Created by Duncan Lewis on 9/30/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTIOAlertView;

@protocol GTIOAlertViewProtocol <NSObject>

@property (nonatomic, strong) GTIOAlertView *currentAlertView;

- (void)showAlertViewInRootView:(GTIOAlertView *)alertView;
- (void)removeAlertViewInRootView;

@end
