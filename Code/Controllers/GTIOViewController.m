//
//  GTIOViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 8/31/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOViewController.h"


@implementation GTIOViewController

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

@end
