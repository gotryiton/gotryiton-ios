//
//  GTIOPushPersonalStylistsViewController.m
//  GTIO
//
//  Created by Jeremy Ellison on 6/30/11.
//  Copyright 2011 Two Toasters, LLC. All rights reserved.
//

#import "GTIOPushPersonalStylistsViewController.h"


@implementation GTIOPushPersonalStylistsViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pspush.png"]];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pspush-navbar-header.png"]] autorelease];
    
    UIButton* screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    screenButton.frame = self.view.bounds;
    [screenButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:screenButton];
    
    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"pspush-add-button-OFF.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"pspush-add-button-ON.png"] forState:UIControlStateHighlighted];
    addButton.frame = CGRectMake(8,self.view.bounds.size.height - 98, 304, 48);
    [addButton addTarget:self action:@selector(addButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    GTIOBarButtonItem* nextButton = [[[GTIOBarButtonItem alloc] initWithTitle:@"skip" target:self action:@selector(skip:)] autorelease];
    self.navigationItem.rightBarButtonItem = nextButton;
}

- (void)skip:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addButtonWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:NO];
    TTOpenURL(@"gtio://stylists/add");
}

@end
