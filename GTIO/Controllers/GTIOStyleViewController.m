//
//  GTIOShopViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOStyleViewController.h"

@interface GTIOStyleViewController()

@property (nonatomic, assign) BOOL shouldRefreshAfterInactive;

@end

@implementation GTIOStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOFeedControllerShouldRefreshAfterInactive object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefreshAfterInactive object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, kGTIOStyleResourcePath]];
    [super viewDidLoad];
}

#pragma mark - Refresh After Inactive

- (void)appReturnedFromInactive
{
    self.shouldRefreshAfterInactive = YES;
}

- (void)refreshAfterInactive
{
    if(self.shouldRefreshAfterInactive) {
        self.shouldRefreshAfterInactive = NO;
        [self.webView loadGTIORequestWithURL:self.URL];
        // load all the rest here
        [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOAllControllersShouldRefreshAfterInactive object:nil];
    }
}

@end
