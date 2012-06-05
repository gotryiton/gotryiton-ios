//
//  GTIOExploreLooksViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/8/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOExploreLooksViewController.h"

@interface GTIOExploreLooksViewController ()

@end

@implementation GTIOExploreLooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
