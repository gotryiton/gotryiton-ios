//
//  GTIOFeedViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/15/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOFeedViewController.h"

@interface GTIOFeedViewController ()

@end

@implementation GTIOFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){ 0, 390, 320, 40 }];
    [label setText:@"TEST THE JAMS"];
    [label setFont:[UIFont boldSystemFontOfSize:30.0f]];
    [label setClipsToBounds:NO];
    [self.view addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setFrame:(CGRect){ 0, 0, 600, 600 }];
    [self.view setBounds:(CGRect) { 0, 0, 600, 600 }];
    [self.view setClipsToBounds:NO];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setFrame:(CGRect){ 0, 0, 600, 600 }];
    [self.view setBounds:(CGRect) { 0, 0, 600, 600 }];
    [self.view setClipsToBounds:NO];
    
    
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
