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
#import <QuartzCore/QuartzCore.h>

@interface GTIOPostALookViewController()

@property (nonatomic, strong) GTIOLookSelectorView *lookSelectorView;
@property (nonatomic, strong) GTIOLookSelectorControl *lookSelectorControl;
@property (nonatomic, strong) GTIOPostALookOptionsView *optionsView;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *descriptionBox;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *tagBox;
@property (nonatomic, strong) UIButton *postThisButton;
@property (nonatomic, strong) UIAlertView *emptyDescriptionAlert;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGRect originalFrame;

@property (nonatomic, strong) NSTimer *photoSaveTimer;

@property (nonatomic, assign) BOOL scrollingToTop;

@end

@implementation GTIOPostALookViewController

@synthesize lookSelectorView = _lookSelectorView, lookSelectorControl = _lookSelectorControl, optionsView = _optionsView, descriptionBox = _descriptionBox, tagBox = _tagBox, scrollView = _scrollView, originalFrame = _originalFrame, postThisButton = _postThisButton, photoSaveTimer = _photoSaveTimer, emptyDescriptionAlert = _emptyDescriptionAlert, scrollingToTop = _scrollingToTop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithTitle:@"post a look" leftNavBarButton:[GTIOButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }] rightNavBarButton:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookSelectorViewUpdated:) name:kGTIOLooksUpdated object:nil];
        _scrollingToTop = NO;
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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50 - 44 }];
    [self.scrollView setDelegate:self];
    [self.scrollView setBounces:NO];
    [self.view addSubview:self.scrollView];
    
    self.lookSelectorView = [[GTIOLookSelectorView alloc] initWithFrame:(CGRect){ 8, 8, 237, 312 } photoSet:NO];
    [self.scrollView addSubview:self.lookSelectorView];
    
    self.lookSelectorControl = [[GTIOLookSelectorControl alloc] initWithFrame:(CGRect){ 253, 13, 60, 107 }];
    [self.lookSelectorControl setDelegate:self.lookSelectorView];
    [self.scrollView addSubview:self.lookSelectorControl];
    
    self.optionsView = [[GTIOPostALookOptionsView alloc] initWithFrame:(CGRect){ 253, 174, 60, 143 }];
    [self.scrollView addSubview:self.optionsView];
    
    self.tagBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 195, 330, 119, 120 } title:@"tag brands" icon:[UIImage imageNamed:@"brands-box-icon.png"] nextTextView:nil];
    [self.scrollView addSubview:self.tagBox];
    
    self.descriptionBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 6, 330, 186, 120 } title:@"add a description" icon:[UIImage imageNamed:@"description-box-icon.png"] nextTextView:self.tagBox.textView];
    [self.scrollView addSubview:self.descriptionBox];
    
    self.originalFrame = self.scrollView.frame;
    
    UIImage *postThisButtonBackgroundImage = [UIImage imageNamed:@"post-button-bg.png"];
    UIImageView *postThisButtonBackground = [[UIImageView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - postThisButtonBackgroundImage.size.height - self.navigationController.navigationBar.bounds.size.height, postThisButtonBackgroundImage.size }];
    [postThisButtonBackground setImage:postThisButtonBackgroundImage];
    [postThisButtonBackground setUserInteractionEnabled:YES];
    [self.view addSubview:postThisButtonBackground];

    self.postThisButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePostThis];
    [self.postThisButton setFrame:(CGRect){ 5, 10, postThisButtonBackground.bounds.size.width - 10, postThisButtonBackground.bounds.size.height - 15 }];
    [self.postThisButton addTarget:self action:@selector(postThis:) forControlEvents:UIControlEventTouchUpInside];
    [self.postThisButton setEnabled:NO];
    [postThisButtonBackground addSubview:self.postThisButton];
    
    [self.scrollView setContentSize:(CGSize){ self.view.bounds.size.width, self.descriptionBox.frame.origin.y + self.descriptionBox.bounds.size.height + 5 }];
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
    self.postThisButton = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.scrollView setFrame:(CGRect){ self.originalFrame.origin, self.originalFrame.size.width, self.originalFrame.size.height - 165 }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self.scrollView setFrame:self.originalFrame];
    [self.scrollView setContentOffset:(CGPoint){ 0, 0 } animated:YES];
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if (targetContentOffset->y > (scrollView.contentSize.height - scrollView.frame.size.height) / 2 ) {
//        targetContentOffset->y = scrollView.contentSize.height - scrollView.frame.size.height;
//        [self.descriptionBox.textView becomeFirstResponder];
//    } else {
//        targetContentOffset->y = 0;
//        [self.descriptionBox.textView resignFirstResponder];
//        [self.tagBox.textView resignFirstResponder];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self snapScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self snapScrollView:scrollView];
    }
}

- (void)snapScrollView:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    NSLog(@"Content offset: %@", NSStringFromCGPoint(contentOffset));
    
    CGRect scrollToRect;
    BOOL top = NO;
    if (contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) / 2 ) {
        scrollToRect = CGRectMake(0, scrollView.contentSize.height - 1, 1, 1);
//        [scrollView setContentOffset:(CGPoint){ 0, scrollView.contentSize.height - scrollView.frame.size.height } animated:YES];
    } else {
        scrollToRect = CGRectMake(0, 0, 1, 1);
        top = YES;
//        [scrollView setContentOffset:(CGPoint){ 0, 0 } animated:YES];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [scrollView scrollRectToVisible:scrollToRect animated:YES];
    } completion:^(BOOL finished) {
        if (top) {
            [self.tagBox.textView resignFirstResponder];
            [self.descriptionBox.textView resignFirstResponder];
        } else {
            [self.descriptionBox.textView becomeFirstResponder];
        }
    }];
}

- (void)postThis:(id)sender
{
    if ([self.descriptionBox.textView.text length] == 0) {
            self.emptyDescriptionAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to post without a description?" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Cancel", nil];
            [self.emptyDescriptionAlert show];
    } else {
        [self savePhotoToDisk];
    }
}

- (void)savePhotoToDisk
{
    [self.lookSelectorView hideDeleteButtons:YES];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.lookSelectorView.photoCanvasSize, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.lookSelectorView.photoCanvasSize);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.lookSelectorView.photoSet) {
        // crop out the white border
        CGContextTranslateCTM(context, -5, -5);
    }
    [[self.lookSelectorView compositeCanvas].layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();   
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    [self.lookSelectorView hideDeleteButtons:NO];
}

- (void)lookSelectorViewUpdated:(id)sender
{
    [self.postThisButton setEnabled:[self.lookSelectorView selectionsComplete]];
    [self.photoSaveTimer invalidate];
    self.photoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createGTIOPhoto:) userInfo:nil repeats:NO];
}

- (void)createGTIOPhoto:(id)sender
{
    if ([self.lookSelectorView selectionsComplete]) {
        NSLog(@"safe to post photo");
    } else {
        NSLog(@"NOT SAFE to post photo");
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self savePhotoToDisk];
    }
}

@end
