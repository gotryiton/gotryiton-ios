//
//  GTIOPostALookViewController.m
//  GTIO
//
//  Created by Geoffrey Mackey on 5/29/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostALookViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GTIOLookSelectorView.h"
#import "GTIOLookSelectorControl.h"
#import "GTIOPostALookOptionsView.h"
#import "GTIOPostALookDescriptionBox.h"
#import "GTIOTakePhotoView.h"
#import "GTIOProgressHUD.h"
#import "GTIOScrollView.h"

#import "GTIOPostManager.h"

#import "GTIOPhoto.h"
#import "GTIOPost.h"

#import "GTIOPhotoConfirmationViewController.h"

static NSInteger const kGTIOBottomButtonSize = 50;
static NSInteger const kGTIONavBarSize = 44;
static NSInteger const kGTIOMaskingViewTag = 100;

@interface GTIOPostALookViewController() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *mainOriginalImage;
@property (nonatomic, strong) UIImage *mainFilteredImage;
@property (nonatomic, strong) NSString *mainFilterName;
@property (nonatomic, strong) NSNumber *mainProductID;

@property (nonatomic, strong) GTIOLookSelectorView *lookSelectorView;
@property (nonatomic, strong) GTIOLookSelectorControl *lookSelectorControl;
@property (nonatomic, strong) GTIOPostALookOptionsView *optionsView;
@property (nonatomic, strong) GTIOPostALookDescriptionBox *descriptionBox;
@property (nonatomic, strong) UIButton *postThisButton;

@property (nonatomic, strong) GTIOScrollView *scrollView;
@property (nonatomic, assign) CGRect originalFrame;

@property (nonatomic, strong) NSTimer *photoSaveTimer;

@property (nonatomic, strong) GTIOPhoto *photoForPosting;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation GTIOPostALookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookSelectorViewUpdated:) name:kGTIOLooksUpdated object:nil];
        
        _currentSection = GTIOPostPhotoSectionMain;
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
    
    GTIOUIButton *cancelButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypeCancelGrayTopMargin tapHandler:^(id sender) {
        if (self.postThisButton.enabled) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to exit without posting?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
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
    
    UIImageView *backdropImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-backdrop.png"]];
    [backdropImageView setFrame:(CGRect){ { 8, 8 }, backdropImageView.image.size }];
    [self.scrollView addSubview:backdropImageView];
    
    self.lookSelectorView = [[GTIOLookSelectorView alloc] initWithFrame:(CGRect){ { 4, 5 }, { 245, 0 } } photoSet:NO launchCameraHandler:^(GTIOPostPhotoSection photoSection){
        self.currentSection = photoSection;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.lookSelectorView setAddFilterHandler:^(GTIOPostPhotoSection photoSection, UIImage *originalPhoto) {
        self.currentSection = photoSection;
        GTIOPhotoConfirmationViewController *confirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
        [confirmationViewController setOriginalPhoto:originalPhoto];
        [self.navigationController pushViewController:confirmationViewController animated:YES];
    }];
    [self setOriginalImage:self.mainOriginalImage filteredImage:self.mainFilteredImage filterName:self.mainFilterName productID:self.mainProductID]; // Now that view is loaded refresh image
    [self.scrollView addSubview:self.lookSelectorView];
    
    self.lookSelectorControl = [[GTIOLookSelectorControl alloc] initWithFrame:(CGRect){ 253, 13, 60, 107 }];
    [self.lookSelectorControl setDelegate:self.lookSelectorView];
    [self.scrollView addSubview:self.lookSelectorControl];
    
    self.optionsView = [[GTIOPostALookOptionsView alloc] initWithFrame:(CGRect){ { 253, 262 }, CGSizeZero }];
    [self.scrollView addSubview:self.optionsView];
    
    self.descriptionBox = [[GTIOPostALookDescriptionBox alloc] initWithFrame:(CGRect){ 0, 330, self.scrollView.frame.size.width, 155 } title:@"add a description, tags, and brands..." icon:[UIImage imageNamed:@"description-box-icon.png"]];
    [self.descriptionBox setClipsToBounds:YES];
    __block typeof(self) blockSelf = self;
    [self.descriptionBox.textView setTextViewDidBecomeActiveHandler:^(GTIOPostAutoCompleteView *descriptionBox) {
        [blockSelf.lookSelectorView setUserInteractionEnabled:NO];
        [blockSelf.optionsView setUserInteractionEnabled:NO];
        
        [blockSelf snapScrollToBottom];
    }];
    [self.descriptionBox.textView setTextViewDidEndHandler:^(GTIOPostAutoCompleteView *descriptionBox, BOOL scrollToTop) {
        [blockSelf.descriptionBox.textView.textInput resignFirstResponder];
        
        [blockSelf.lookSelectorView setUserInteractionEnabled:YES];
        [blockSelf.optionsView setUserInteractionEnabled:YES];
        
        if (scrollToTop) {
            [blockSelf scrollToTop];
        }
    }];
    [self.scrollView addSubview:self.descriptionBox];

    self.originalFrame = self.scrollView.frame;
    
    UIImage *postThisButtonBackgroundImage = [UIImage imageNamed:@"post-button-bg.png"];
    UIImageView *postThisButtonBackground = [[UIImageView alloc] initWithFrame:(CGRect){ 0, self.view.bounds.size.height - postThisButtonBackgroundImage.size.height - self.navigationController.navigationBar.bounds.size.height, postThisButtonBackgroundImage.size }];
    [postThisButtonBackground setImage:postThisButtonBackgroundImage];
    [postThisButtonBackground setUserInteractionEnabled:YES];
    [self.view addSubview:postThisButtonBackground];

    self.postThisButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePostThis];
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

- (void)didReceiveMemoryWarning {
    // Don't release this view in the event of a memory warning, it's holding state. May be refactorable. Fixes #
    return;
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

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self.descriptionBox.textView.textInput resignFirstResponder];
    return YES;
}

- (void)snapScrollView:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    
    if (contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height - scrollView.scrollIndicatorInsets.bottom)) / 2 ) {
        [self.descriptionBox.textView.textInput becomeFirstResponder];
        
        if (self.scrollView.isKeyboardShowing) {
            [self snapScrollToBottom];
        }
    } else {
        [self scrollToTop];
        [self.descriptionBox.textView.textInput resignFirstResponder];
    }
}

- (void)snapScrollToBottom
{
    CGRect scrollToRect = CGRectMake(0, self.scrollView.contentSize.height - 1, 1, 1);
    [UIView animateWithDuration:0.15 animations:^{
        [self.scrollView scrollRectToVisible:scrollToRect animated:YES];
    } completion:^(BOOL finished) {
    }];
}

- (void)scrollToTop
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark -

- (void)reset
{
    self.currentSection = GTIOPostPhotoSectionMain;
    
    self.mainOriginalImage = nil;
    self.mainFilteredImage = nil;
    
    [self.descriptionBox.textView resetView];
    [self.lookSelectorControl reset];
    [self.lookSelectorView reset];
}

- (void)postThis:(id)sender
{
    if ([[self.descriptionBox.textView processDescriptionString] length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to post without a description?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:kGTIOEmptyDescriptionAlertTag];
        [alert show];
    } else {
        NSLog(@"description submissionText: %@", [self.descriptionBox.textView processDescriptionString] );
        
        [self beginPostLookToGTIO];
    }
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
        UIImage *uploadImage = [self.lookSelectorView compositeImage];
        
        [[GTIOPostManager sharedManager] uploadImage:uploadImage framed:self.lookSelectorView.photoSet filterNames:[self filterNames] forceSavePost:NO];
    }
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

- (void)beginPostLookToGTIO
{
    // Check to see if the timer is ticking. If it is, trigger it before we go away.
    if ([self.photoSaveTimer isValid]) {
        [self.photoSaveTimer invalidate];
        [self createGTIOPhoto:self];
    }
    
    [[GTIOPostManager sharedManager] setPostPhotoButtonTouched:YES];
    
    [[GTIOPostManager sharedManager] savePostWithDescription:[self.descriptionBox.textView processDescriptionString] attachedProducts:(NSDictionary *)[self attachedProducts]];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self reset];
    }];
}

- (NSDictionary *)filterNames
{
    NSMutableDictionary *filterNames = [NSMutableDictionary dictionary];
    if (self.lookSelectorView.photoSet) {
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.mainPhotoView attachedProducts:nil filterNames:filterNames];
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.topPhotoView attachedProducts:nil filterNames:filterNames];
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.bottomPhotoView attachedProducts:nil filterNames:filterNames];
    } else {
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.singlePhotoView attachedProducts:nil filterNames:filterNames];
    }
    return filterNames;
}

- (NSDictionary *)attachedProducts
{
    NSMutableDictionary *attachedProducts = [NSMutableDictionary dictionary];
    if (self.lookSelectorView.photoSet) {
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.mainPhotoView attachedProducts:attachedProducts filterNames:nil];
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.topPhotoView attachedProducts:attachedProducts filterNames:nil];
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.bottomPhotoView attachedProducts:attachedProducts filterNames:nil];
    } else {
        [self buildPropertyArraysForTakePhotoView:self.lookSelectorView.singlePhotoView attachedProducts:attachedProducts filterNames:nil];
    }
    return attachedProducts;
}

- (void)buildPropertyArraysForTakePhotoView:(GTIOTakePhotoView *)takePhotoView attachedProducts:(NSMutableDictionary *)attachedProducts filterNames:(NSMutableDictionary *)filterNames
{
    NSInteger key = NSNotFound;
    if (takePhotoView == self.lookSelectorView.mainPhotoView || takePhotoView == self.lookSelectorView.singlePhotoView) {
        key = 0;
    } else if (takePhotoView == self.lookSelectorView.topPhotoView) {
        key = 1;
    } else if (takePhotoView == self.lookSelectorView.bottomPhotoView) {
        key = 2;
    }
    
    if (key != NSNotFound) {
        if (takePhotoView.productID) {
            [attachedProducts setValue:[NSNumber numberWithInt:key] forKey:[takePhotoView.productID stringValue]];
        }
        if ([takePhotoView.filterName length] > 0) {
            [filterNames setValue:takePhotoView.filterName forKey:[NSString stringWithFormat:@"%i", key]];
        }
    }
}

- (void)cancelPost
{
    [[GTIOPostManager sharedManager] cancelUploadImage];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self reset];
    }];
}

#pragma mark - Photo Handlers

- (void)setOriginalImage:(UIImage *)originalImage filteredImage:(UIImage *)filteredImage filterName:(NSString *)filterName productID:(NSNumber *)productID
{
    switch (self.currentSection) {
        case GTIOPostPhotoSectionMain:
            self.mainOriginalImage = originalImage;
            self.mainFilteredImage = filteredImage;
            self.mainFilterName = filterName;
            self.mainProductID = productID;
            [self updateTakePhotoView:self.lookSelectorView.mainPhotoView originalImage:originalImage filteredImage:filteredImage filterName:filterName productID:productID];
            [self updateTakePhotoView:self.lookSelectorView.singlePhotoView originalImage:originalImage filteredImage:filteredImage filterName:filterName productID:productID];
            
            CGFloat height = kGTIOLookSelectorViewMaxHeight;
            if (self.mainFilteredImage.size.height < kGTIOLookSelectorViewMaxHeight) {
                height = kGTIOLookSelectorViewMinHeight;
            }
            [self.lookSelectorView setFrame:(CGRect){ self.lookSelectorView.frame.origin, { self.lookSelectorView.frame.size.width, height } }];
            
            break;
        case GTIOPostPhotoSectionTop: 
            [self updateTakePhotoView:self.lookSelectorView.topPhotoView originalImage:originalImage filteredImage:filteredImage filterName:filterName productID:productID];
            break;
        case GTIOPostPhotoSectionBottom: 
            [self updateTakePhotoView:self.lookSelectorView.bottomPhotoView originalImage:originalImage filteredImage:filteredImage filterName:filterName productID:productID];
            break;
        default: break;
    }
}

- (void)updateTakePhotoView:(GTIOTakePhotoView *)takePhotoView originalImage:(UIImage *)originalImage filteredImage:(UIImage *)filteredImage filterName:(NSString *)filterName productID:(NSNumber *)productID
{
    [takePhotoView setOriginalImage:originalImage];
    [takePhotoView setFilteredImage:filteredImage];
    [takePhotoView setFilterName:filterName];
    [takePhotoView setProductID:productID];
}

#pragma mark - UINavigationBar

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (![[[touch view] class] isSubclassOfClass:[UIControl class]]);
}

- (void)tapNavigationBar:(UIGestureRecognizer *)gesture
{
    [self.descriptionBox.textView.textInput resignFirstResponder];
    [self.scrollView scrollRectToVisible:(CGRect){ 0, 0, 1, 1 } animated:YES];
}

@end
