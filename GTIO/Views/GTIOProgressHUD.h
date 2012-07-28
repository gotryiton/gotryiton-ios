//
//  GTIOProgressHUD.h
//  GTIO
//
//  Created by Scott Penrose on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "MBProgressHUD.h"

@interface GTIOProgressHUD : MBProgressHUD

+ (GTIOProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated dimScreen:(BOOL)dimScreen;

+ (GTIOProgressHUD *)showPlainHUDAddedTo:(UIView *)view animated:(BOOL)animated dimScreen:(BOOL)dimScreen;

@end
