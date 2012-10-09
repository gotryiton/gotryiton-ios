//
//  GTIOShopViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOStyleViewController.h"
#import "GTIOProductNativeListViewController.h"

@interface GTIOStyleViewController()

@property (nonatomic, assign) BOOL shouldRefreshAfterInactive;

@end

@implementation GTIOStyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kGTIOBaseURLString, kGTIOStyleResourcePath]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appReturnedFromInactive) name:kGTIOAppReturningFromInactiveStateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOStyleControllerShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterInactive) name:kGTIOAllControllersShouldRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectionIDNotification:) name:kGTIOStylesChangeCollectionIDNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterLogout) name:kGTIOAllControllersShouldRefreshAfterLogout object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
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
    }
}

#pragma mark - Refresh after logout

- (void)refreshAfterLogout
{
    [self.webView loadGTIORequestWithURL:self.URL];
}

#pragma mark - Notification methods

- (void)changeCollectionIDNotification:(NSNotification*)notification
{
    NSNumber *collectionID = [[notification userInfo] objectForKey:kGTIOCollectionIDUserInfoKey];
    GTIOProductNativeListViewController *viewController = [[GTIOProductNativeListViewController alloc] initWithNibName:nil bundle:nil];
    [viewController setCollectionID:collectionID];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
