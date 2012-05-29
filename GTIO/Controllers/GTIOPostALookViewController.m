//
//  GTIOPostALookViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookViewController.h"
#import "GTIOLookSelectorView.h"
#import "GTIOLookSelectorControl.h"
#import "GTIOPostALookOptionsView.h"
#import "GTIOPostALookDescriptionBox.h"

@interface GTIOPostALookViewController()

@property (nonatomic, strong) GTIOLookSelectorView *lookSelectorView;
@property (nonatomic, strong) GTIOLookSelectorControl *lookSelectorControl;
@property (nonatomic, strong) GTIOPostALookOptionsView *optionsView;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *descriptionBox;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *tagBox;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation GTIOPostALookViewController

@synthesize lookSelectorView = _lookSelectorView, lookSelectorControl = _lookSelectorControl, optionsView = _optionsView, descriptionBox = _descriptionBox, tagBox = _tagBox, scrollView = _scrollView, originalFrame = _originalFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithTitle:@"post a look" andLeftNavBarButton:[GTIOButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }] andRightNavBarButton:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size }];
    [self.view addSubview:self.scrollView];
    
    self.lookSelectorView = [[GTIOLookSelectorView alloc] initWithFrame:(CGRect){ 8, 8, 237, 312 } asPhotoSet:NO];
    [self.scrollView addSubview:self.lookSelectorView];
    
    self.lookSelectorControl = [[GTIOLookSelectorControl alloc] initWithFrame:(CGRect){ 253, 13, 60, 107 }];
    [self.lookSelectorControl setDelegate:self.lookSelectorView];
    [self.scrollView addSubview:self.lookSelectorControl];
    
    self.optionsView = [[GTIOPostALookOptionsView alloc] initWithFrame:(CGRect){ 253, 174, 60, 143 }];
    [self.scrollView addSubview:self.optionsView];
    
    self.descriptionBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 6, 330, 186, 120 } andTitle:@"add a description" andIcon:[UIImage imageNamed:@"description-box-icon.png"]];
    [self.scrollView addSubview:self.descriptionBox];
    
    self.tagBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 195, 330, 119, 120 } andTitle:@"tag brands" andIcon:[UIImage imageNamed:@"brands-box-icon.png"]];
    [self.scrollView addSubview:self.tagBox];
    
    [self.scrollView setContentSize:(CGSize){ self.view.bounds.size.width, self.descriptionBox.frame.origin.y + self.descriptionBox.bounds.size.height + 50 }];
    
    self.originalFrame = self.scrollView.frame;
}

- (void)viewDidUnload
{
    [self viewDidUnload];
    
    self.scrollView = nil;
    self.lookSelectorView = nil;
    self.lookSelectorControl = nil;
    self.optionsView = nil;
    self.descriptionBox = nil;
    self.tagBox = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.scrollView setFrame:(CGRect){ self.scrollView.frame.origin, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height - 215 }];
    [self.scrollView scrollRectToVisible:(CGRect){ 0, self.descriptionBox.frame.origin.y + 50, self.descriptionBox.bounds.size } animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setFrame:self.originalFrame];
}

@end
