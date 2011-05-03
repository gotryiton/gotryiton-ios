//
//  UIViewController_Flurry.m
//  GoTryItOn
//
//  Created by Jeremy Ellison on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController_Flurry.h"
#import "SupersequentImplementation.h"
#import "GTIOAnalyticsTracker.h"

@implementation UIViewController (Flurry)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = invokeSupersequent(nibNameOrNil, nibBundleOrNil))) {
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"back" 
                                                                                  style:UIBarButtonItemStyleBordered 
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
        [FlurryAPI logAllPageViews:self];

    }
    return self;
}

@end

@implementation UITabBarController (Flurry)

- (id)init {
    if ((self = invokeSupersequentNoParameters())) {
        [FlurryAPI logAllPageViews:self];
    }
    return self;
}

@end