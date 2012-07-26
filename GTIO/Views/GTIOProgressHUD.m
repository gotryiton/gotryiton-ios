//
//  GTIOProgressHUD.m
//  GTIO
//
//  Created by Scott Penrose on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProgressHUD.h"

@implementation GTIOProgressHUD

+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    GTIOProgressHUD *progressHUD = [self setupHUDAddedTo:view showBackground:YES dimScreen:NO];
    [progressHUD show:YES];
    return progressHUD;
}

+ (GTIOProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated dimScreen:(BOOL)dimScreen
{
    GTIOProgressHUD *progressHUD = [self setupHUDAddedTo:view showBackground:YES dimScreen:dimScreen];
    [progressHUD show:animated];
    return progressHUD;
}

+ (GTIOProgressHUD *)showPlainHUDAddedTo:(UIView *)view animated:(BOOL)animated dimScreen:(BOOL)dimScreen
{
    GTIOProgressHUD *progressHUD = [self setupHUDAddedTo:view showBackground:YES dimScreen:dimScreen];
    [progressHUD show:YES];
    return progressHUD;
}

+ (GTIOProgressHUD *)setupHUDAddedTo:(UIView *)view showBackground:(BOOL)showBackground dimScreen:(BOOL)dimScreen
{
    GTIOProgressHUD *progressHUD = [[GTIOProgressHUD alloc] initWithView:view];
    [view addSubview:progressHUD];
    
    if (showBackground) {
        UIImage *hudBG = [[UIImage imageNamed:@"spinner-normal-bg.png"] resizableImageWithCapInsets:(UIEdgeInsets){ 30, 35, 30, 35 }];
        [progressHUD setCustomBackgroundImage:hudBG];
    }
    
    [progressHUD setLabelFont:[UIFont gtio_archerFontWithWeight:GTIOFontArcherMediumItal size:13.0f]];
    [progressHUD setLabelTextColor:[UIColor gtio_pinkTextColor]];
    [progressHUD setDimBackground:dimScreen];
    [progressHUD setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    return progressHUD;
}

@end
