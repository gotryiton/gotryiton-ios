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
#import "GTIOTakePhotoView.h"
#import "GTIOPhoto.h"
#import "GTIOPost.h"
#import "GTIOProgressHUD.h"

#import "GTIOScrollView.h"

static NSInteger const kGTIOBottomButtonSize = 50;
static NSInteger const kGTIONavBarSize = 44;
static NSInteger const kGTIOMaskingViewTag = 100;

@interface GTIOPostALookViewController() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GTIOLookSelectorView *lookSelectorView;
@property (nonatomic, strong) GTIOLookSelectorControl *lookSelectorControl;
@property (nonatomic, strong) GTIOPostALookOptionsView *optionsView;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *descriptionBox;
@property (nonatomic, strong) UIButton *postThisButton;

@property (nonatomic, strong) GTIOScrollView *scrollView;
@property (nonatomic, assign) CGRect originalFrame;

@property (nonatomic, strong) NSTimer *photoSaveTimer;

@property (nonatomic, strong) GTIOPhoto *photoForCreationRequests;
@property (nonatomic, strong) GTIOPhoto *photoForPosting;
@property (nonatomic, assign) BOOL creatingPhoto;
@property (nonatomic, assign) BOOL postButtonPressed;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation GTIOPostALookViewController

@synthesize lookSelectorView = _lookSelectorView, lookSelectorControl = _lookSelectorControl, optionsView = _optionsView, descriptionBox = _descriptionBox, scrollView = _scrollView, originalFrame = _originalFrame, postThisButton = _postThisButton, photoSaveTimer = _photoSaveTimer, photoForCreationRequests = _photoForCreationRequests;
@synthesize mainImage = _mainImage, secondImage = _secondImage, thirdImage = _thirdImage, photoForPosting = _photoForPosting, creatingPhoto = _creatingPhoto, postButtonPressed = _postButtonPressed;
@synthesize maskView = _maskView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookSelectorViewUpdated:) name:kGTIOLooksUpdated object:nil];
        self.photoForCreationRequests = [[GTIOPhoto alloc] init];
        self.creatingPhoto = NO;
        self.postButtonPressed = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GTIONavigationTitleView *navTitleView = [[GTIONavigationTitleView alloc] initWithTitle:@"post a look" italic:YES];
    [self useTitleView:navTitleView];
    
    GTIOButton *cancelButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        if (self.postThisButton.enabled) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to exit without posting?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", @"Cancel", nil];
            [alert setTag:kGTIOEmptyPostAlertTag];
            [alert show];
        } else {
            [self cancelPost];
        }
    }];
    [self setLeftNavigationButton:cancelButton];
    
    self.scrollView = [[GTIOScrollView alloc] initWithFrame:(CGRect){ 0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kGTIOBottomButtonSize - kGTIONavBarSize }];
    [self.scrollView setOffsetFromBottom:kGTIOBottomButtonSize];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    self.lookSelectorView = [[GTIOLookSelectorView alloc] initWithFrame:(CGRect){ 8, 8, 237, 312 } photoSet:NO launchCameraHandler:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.lookSelectorView.singlePhotoView setImage:self.mainImage];
    [self.scrollView addSubview:self.lookSelectorView];
    
    self.lookSelectorControl = [[GTIOLookSelectorControl alloc] initWithFrame:(CGRect){ 253, 13, 60, 107 }];
    [self.lookSelectorControl setDelegate:self.lookSelectorView];
    [self.scrollView addSubview:self.lookSelectorControl];
    
    self.optionsView = [[GTIOPostALookOptionsView alloc] initWithFrame:(CGRect){ 253, 174, 60, 143 }];
    [self.scrollView addSubview:self.optionsView];
    
    self.descriptionBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 0, 330, self.scrollView.frame.size.width, 155 } title:@"add a description" icon:[UIImage imageNamed:@"description-box-icon.png"]];
    [self.descriptionBox setTextViewWillBecomeActiveHandler:^(GTIOPostALookDescriptionBox *descriptionBox) {        
        CGFloat bottomOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        
        if (self.scrollView.contentOffset.y == bottomOffset) {
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.descriptionBox.textView.textInput becomeFirstResponder];
            });
        } else {
            [self.scrollView scrollRectToVisible:(CGRect){ 0, self.scrollView.contentSize.height - 1, 1, 1 } animated:YES];
        }
    }];
    [self.descriptionBox setTextViewDidBecomeActiveHandler:^(GTIOPostALookDescriptionBox *descriptionBox) {
        [self.lookSelectorView setUserInteractionEnabled:NO];
    }];
    [self.descriptionBox setTextViewDidEndHandler:^(GTIOPostALookDescriptionBox *descriptionBox, BOOL scrollToTop) {
        [self.descriptionBox.textView.textInput resignFirstResponder];
        [self.lookSelectorView setUserInteractionEnabled:YES];
        
        if (scrollToTop) {
            [self.scrollView scrollRectToVisible:(CGRect){ 0, 0, 1, 1 } animated:YES];
        }
    }];
    [self.scrollView addSubview:self.descriptionBox];

    self.originalFrame = self.scrollView.frame;
    
    UIImage *postThisButtonBackgroundImage = [UIImage imageNamed:@"post-button-bg.png"];
    UIImageView *postThisButtonBackground = [[UIImageView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - postThisButtonBackgroundImage.size.height - self.navigationController.navigationBar.bounds.size.height, postThisButtonBackgroundImage.size }];
    [postThisButtonBackground setImage:postThisButtonBackgroundImage];
    [postThisButtonBackground setUserInteractionEnabled:YES];
    [self.view addSubview:postThisButtonBackground];

    self.postThisButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePostThis];
    [self.postThisButton setFrame:(CGRect){ 5, 11, postThisButtonBackground.bounds.size.width - 10, postThisButtonBackground.bounds.size.height - 15 }];
    [self.postThisButton addTarget:self action:@selector(postThis:) forControlEvents:UIControlEventTouchUpInside];
    [self.postThisButton setEnabled:NO];
    [postThisButtonBackground addSubview:self.postThisButton];
    
    [self.scrollView setContentSize:(CGSize){ self.view.bounds.size.width, self.descriptionBox.frame.origin.y + self.descriptionBox.bounds.size.height + 5 }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNavigationBar:)];
    [tapGestureRecognizer setDelegate:self];
    [self.navigationController.navigationBar addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGTIOLooksUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.lookSelectorView = nil;
    self.lookSelectorControl = nil;
    self.optionsView = nil;
    self.descriptionBox = nil;
    self.postThisButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UIScrollViewDelegate

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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.descriptionBox.forceBecomeFirstResponder) {
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.descriptionBox.textView becomeFirstResponder];
            [self.descriptionBox setForceBecomeFirstResponder:NO];
        });
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self.descriptionBox.textView resignFirstResponder];
    return YES;
}

- (void)snapScrollView:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGRect scrollToRect;
    BOOL top = NO;
    if (contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height - scrollView.scrollIndicatorInsets.bottom)) / 2 ) {
        scrollToRect = CGRectMake(0, scrollView.contentSize.height - 1, 1, 1);
    } else {
        scrollToRect = CGRectMake(0, 0, 1, 1);
        top = YES;
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        [scrollView scrollRectToVisible:scrollToRect animated:YES];
    } completion:^(BOOL finished) {
        if (top) {
            [self.descriptionBox.textView resignFirstResponder];
        } else {
            [self.descriptionBox.textView becomeFirstResponder];
        }
    }];
}

#pragma mark -

- (void)postThis:(id)sender
{
    if ([[self.descriptionBox.textView processDescriptionString] length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to post without a description?" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Cancel", nil];
        [alert setTag:kGTIOEmptyDescriptionAlertTag];
        [alert show];
    } else {
        NSLog(@"description submissionText: %@", [self.descriptionBox.textView processDescriptionString] );
        
        [self beginPostLookToGTIO];
    }
}

- (void)savePhotoToDisk
{
    UIImage *viewImage = [self getCompositeImage];
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}

- (void)lookSelectorViewUpdated:(id)sender
{
    [self.postThisButton setEnabled:[self.lookSelectorView selectionsComplete]];
    [self.photoSaveTimer invalidate];
    self.photoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createGTIOPhoto:) userInfo:nil repeats:NO];
    self.photoForPosting = nil;
}

- (void)createGTIOPhoto:(id)sender
{
    if ([self.lookSelectorView selectionsComplete]) {
        UIImage *uploadImage = [self getCompositeImage];
        [self.photoForCreationRequests cancel];
        self.creatingPhoto = YES;
        self.photoForCreationRequests = [GTIOPhoto createGTIOPhotoWithUIImage:uploadImage framed:self.lookSelectorView.photoSet filter:@"" completionHandler:^(GTIOPhoto *photo, NSError *error) {
            self.creatingPhoto = NO;
            if (!error && photo) {
                self.photoForPosting = photo;
                if (self.postButtonPressed) {
                    self.postButtonPressed = NO;
                    [self postLookToGTIO];
                }
            } else {
                NSLog(@"There was an error while posting the photo. (Server error:%@)", [error localizedDescription]);
            }
        }];
    }
}

- (UIImage *)getCompositeImage
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
    [self.lookSelectorView hideDeleteButtons:NO];
    return viewImage;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == kGTIOEmptyDescriptionAlertTag) {
        [self beginPostLookToGTIO];
    }
    if (buttonIndex == 0 && alertView.tag == kGTIOEmptyPostAlertTag) {
        [self cancelPost];
    }
}

- (void)postLookToGTIO
{
    if (!self.creatingPhoto && self.photoForPosting) {
        [self savePhotoToDisk];
        [GTIOPost postGTIOPhoto:self.photoForPosting description:[self.descriptionBox.textView processDescriptionString] votingEnabled:self.optionsView.votingSwitch.on completionHandler:^(GTIOPost *post, NSError *error) {
            [GTIOProgressHUD hideHUDForView:self.view animated:YES];
            if (!error && post) {
                [self.navigationController dismissModalViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There was an error posting your look. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (void)beginPostLookToGTIO
{
    self.postButtonPressed = YES;
    [GTIOProgressHUD showHUDAddedTo:self.view animated:YES];
    [self postLookToGTIO];
}

- (void)cancelPost
{
    [self.photoForCreationRequests cancel];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Photo Handlers

- (void)setMainImage:(UIImage *)mainImage
{
    _mainImage = mainImage;
    self.lookSelectorView.singlePhotoView.image = _mainImage;
}

#pragma mark - UINavigationBar

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (![[[touch view] class] isSubclassOfClass:[UIControl class]]);
}

- (void)tapNavigationBar:(UIGestureRecognizer *)gesture
{
    [self.descriptionBox.textView resignFirstResponder];
    [self.scrollView scrollRectToVisible:(CGRect){ 0, 0, 1, 1 } animated:YES];
}

@end
