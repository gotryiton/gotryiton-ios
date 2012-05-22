//
//  GTIOProgressHUD.m
//  GTIO
//
//  Created by Scott Penrose on 5/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOProgressHUD.h"

@implementation GTIOProgressHUD

+ (GTIOProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    GTIOProgressHUD *hud = (GTIOProgressHUD *)[MBProgressHUD showHUDAddedTo:view animated:animated];
    return hud;
}

@end
