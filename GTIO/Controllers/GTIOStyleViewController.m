//
//  GTIOShopViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOStyleViewController.h"

@implementation GTIOStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, kGTIOStyleResourcePath]];
    [super viewDidLoad];
}

- (void)refreshAfterInactive
{
    [self.webView loadGTIORequestWithURL:self.URL];
}

@end
