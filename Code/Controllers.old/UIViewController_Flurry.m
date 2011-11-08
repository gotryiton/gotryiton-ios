//
//  UIViewController_Flurry.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/16/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "UIViewController_Flurry.h"
#import "SupersequentImplementation.h"
#import "GTIOAnalyticsTracker.h"

@implementation UIViewController (Flurry)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = invokeSupersequent(nibNameOrNil, nibBundleOrNil))) {
        self.navigationItem.backBarButtonItem = [[[GTIOBarButtonItem alloc] initWithTitle:@"back" 
                                                                                  
                                                                                 target:nil 
                                                                                 action:nil] autorelease];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    invokeSupersequent(animated);
    [[GTIOAnalyticsTracker sharedTracker] trackViewControllerDidAppear:[self class]];
}

@end

@implementation UINavigationController (Flurry)

- (id)init {
    if ((self = invokeSupersequentNoParameters())) {
        [FlurryAnalytics logAllPageViews:self];

    }
    return self;
}

@end

@implementation UITabBarController (Flurry)

- (id)init {
    if ((self = invokeSupersequentNoParameters())) {
        [FlurryAnalytics logAllPageViews:self];
    }
    return self;
}

@end