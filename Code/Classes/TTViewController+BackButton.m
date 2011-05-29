//
//  TTViewController+BackButton.m
//  GTIO
//
//  Created by Daniel Hammond on 5/27/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//
/// TTViewController+BackButton is a helper category that sets the correct GTIO Styled back button on TTViewControllers
#import "GTIOBarButtonItem.h"

@interface TTViewController (BackButton)
@end

@implementation TTViewController (BackButton)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [GTIOBarButtonItem backButton];
    }
    return self;
}
@end
