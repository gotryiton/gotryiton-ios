//
//  GTIOCameraViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOCameraViewController.h"

#import "GTIOCameraToolbarView.h"
#import "GTIOPhotoShootProgressToolbarView.h"
#import "GTIOPhotoShootTimerView.h"
#import "GTIOPopOverView.h"

#import "GTIOConfig.h"
#import "GTIOConfigManager.h"

#import "GTIOPhotoManager.h"
#import "GTIOProcessImageRequest.h"

#import "GTIOFilterManager.h"

#import "GTIOPhotoShootGridViewController.h"
#import "GTIOPhotoConfirmationViewController.h"
#import "GTIOPostALookViewController.h"
#import "GTIOPickAProductViewController.h"

NSString * const kGTIOPhotoAcceptedNotification = @"GTIOPhotoAcceptedNotification";

static CGFloat const kGTIOToolbarHeight = 53.0f;
static CGFloat const kGTIOSourcePopOverXOriginPadding = 4.0f;
static CGFloat const kGTIOSourcePopOverYOriginPadding = 42.0f;
static CGFloat const kGTIOPhotoShootModePopOverXOriginPadding = 25.5f;
static CGFloat const kGTIOPhotoShootModePopOverYOriginPadding = 30.0f;

NSString * const kGTIOPhotoShootModeCountUserDefaults = @"GTIOPhotoShootModeCountUserDefaults";
static NSInteger kGTIOShowPhotoShootModeHelperCount = 3;

@interface GTIOCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nonatomic, strong) GTIOCameraToolbarView *photoToolbarView;
@property (nonatomic, strong) GTIOPhotoShootProgressToolbarView *photoShootProgresToolbarView;
@property (nonatomic, strong) GTIOUIButton *flashButton;
@property (nonatomic, strong) UIImageView *shutterFlashOverlay;
@property (nonatomic, strong) GTIOPhotoShootTimerView *photoShootTimerView;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) GTIOPopOverView *sourcePopOverView;
@property (nonatomic, strong) UIImageView *photoShootPopOverView;

@property (nonatomic, assign) NSInteger capturedImageCount;
@property (nonatomic, assign) NSInteger photoShootModeCount;
@property (nonatomic, assign, getter = isPhotoShootModeFirstToggle) BOOL photoShootModeFirstToggle;
@property (nonatomic, assign, getter = isForcePhotoShootModeButtonToggle) BOOL forcePhotoShootModeButtonToggle;

@property (nonatomic, assign) NSInteger startingPhotoCount;
@property (nonatomic, strong) NSTimer *imageWaitTimer;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) GTIOPostALookViewController *postALookViewController;

@property (nonatomic, assign, getter = isShootingPhotoShoot) BOOL shootingPhotoShoot;

@end

@implementation GTIOCameraViewController

@synthesize captureSession = _captureSession, stillImageOutput = _stillImageOutput, captureVideoPreviewLayer = _captureVideoPreviewLayer, captureDevice = _captureDevice;
@synthesize photoToolbarView = _photoToolbarView, photoShootProgresToolbarView = _photoShootProgresToolbarView, photoShootTimerView = _photoShootTimerView, sourcePopOverView = _sourcePopOverView, photoShootPopOverView = _photoShootPopOverView;
@synthesize flashButton = _flashButton;
@synthesize flashOn = _flashOn, shutterFlashOverlay = _shutterFlashOverlay;
@synthesize dismissHandler = _dismissHandler;
@synthesize capturedImageCount = _capturedImageCount;
@synthesize imageWaitTimer = _imageWaitTimer;
@synthesize startingPhotoCount = _startingPhotoCount;
@synthesize imagePickerController = _imagePickerController;
@synthesize postALookViewController = _postALookViewController;
@synthesize shootingPhotoShoot = _shootingPhotoShoot;
@synthesize focusImageView = _focusImageView;
@synthesize photoShootModeCount = _photoShootModeCount;
@synthesize photoShootModeFirstToggle = _photoShootModeFirstToggle;
@synthesize forcePhotoShootModeButtonToggle = _forcePhotoShootModeButtonToggle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setWantsFullScreenLayout:YES];
        
        _captureSession = [[AVCaptureSession alloc] init];
        
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self changeFlashMode:AVCaptureFlashModeOff];
        
        _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        if (!input) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        if ([_captureSession canAddInput:input]) {
            [_captureSession addInput:input];
        } else {
            NSLog(@"Can't add video");
        }
        
        _capturedImageCount = 0;
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
        
        _postALookViewController = [[GTIOPostALookViewController alloc] initWithNibName:nil bundle:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoAcceptedNotification:) name:kGTIOPhotoAcceptedNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [tapGestureRecognizer setDelegate:self];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        
        // Load the filters so they are ready to go
        [GTIOFilterManager sharedManager];
        
        _photoShootModeCount = [[[NSUserDefaults standardUserDefaults] objectForKey:kGTIOPhotoShootModeCountUserDefaults] integerValue];
        _photoShootModeFirstToggle = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:self.tabBarController.view.bounds];
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor gtio_toolbarBGColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup preview
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CGRect layerRect = self.view.layer.bounds;
    layerRect.size.height -= kGTIOToolbarHeight;
    [self.captureVideoPreviewLayer setBounds:layerRect];
    [self.captureVideoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    // Setup output
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.captureSession addOutput:self.stillImageOutput];
    
    // Flash button
    self.flashButton = [GTIOUIButton buttonWithGTIOType:GTIOButtonTypePhotoFlash];
    [self.flashButton setFrame:(CGRect){ { 5, 26 }, self.flashButton.frame.size }];
    __block typeof(self) blockSelf = self;
    [self.flashButton setTapHandler:^(id sender) {
        blockSelf.flashOn = !blockSelf.isFlashOn;
    }];
    
    if ([self.captureDevice isFlashAvailable]) {
        [self.view addSubview:self.flashButton];
    }
    
    // Photo Shoot Pop Over
    self.photoShootPopOverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoshoot-info-callout.png"]];
    
    // Photo Shoot Toolbar
    self.photoShootProgresToolbarView = [[GTIOPhotoShootProgressToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - kGTIOToolbarHeight, self.view.frame.size.width, kGTIOToolbarHeight }];
    [self.photoShootProgresToolbarView setAlpha:0.0f];
    [self.view addSubview:self.photoShootProgresToolbarView];
    
    // Source Pop Over View
    self.sourcePopOverView = [GTIOPopOverView cameraSourcesPopOverView];
    [self.sourcePopOverView setFrame:(CGRect){ { kGTIOSourcePopOverXOriginPadding, self.view.frame.size.height - self.sourcePopOverView.frame.size.height - kGTIOSourcePopOverYOriginPadding }, self.sourcePopOverView.frame.size }];
    [self.sourcePopOverView setTapHandler:^(GTIOButton *buttonModel) {
        GTIOPickAProductViewController *pickAProductViewController = nil;
        if ([buttonModel.action.destination isEqualToString:@"gtio://camera-roll"] && 
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            [blockSelf presentViewController:self.imagePickerController animated:YES completion:nil];
        } else if ([buttonModel.action.destination isEqualToString:@"gtio://hearted-products"]) {
            pickAProductViewController = [[GTIOPickAProductViewController alloc] initWithNibName:nil bundle:nil];
            [pickAProductViewController setStartingProductType:GTIOProductTypeHearted];
        } else if ([buttonModel.action.destination isEqualToString:@"gtio://popular-products"]) {
            pickAProductViewController = [[GTIOPickAProductViewController alloc] initWithNibName:nil bundle:nil];
            [pickAProductViewController setStartingProductType:GTIOProductTypePopular];
        }
        
        // Setup Pick a product
        if (pickAProductViewController) {
            __block typeof(pickAProductViewController) blockPickAProductViewController = pickAProductViewController;
            [pickAProductViewController setDidSelectProductHandler:^(GTIOProduct *product) {
                [blockPickAProductViewController dismissModalViewControllerAnimated:YES];
                [blockSelf openPhotoConfirmationScreenWithProduct:product];
            }];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pickAProductViewController];
            [blockSelf presentViewController:navController animated:YES completion:nil];
        }
    }];
    
    // Toolbar
    self.photoToolbarView = [[GTIOCameraToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - kGTIOToolbarHeight, self.view.frame.size.width, kGTIOToolbarHeight }];
    [self.photoToolbarView.closeButton setTapHandler:^(id sender) {
        if (blockSelf.dismissHandler) {
            blockSelf.dismissHandler(blockSelf);
        }
    }];
    [self.photoToolbarView.shutterButton setShutterButtonTapHandler:^(id sender) {
        if (self.photoToolbarView.shutterButton.isPhotoShootMode) {
            [blockSelf photoShootModeButtonPress];
        } else {
            [blockSelf singleModeButtonPress];
        }
    }];
    [self.photoToolbarView.photoSourceButton setTapHandler:^(id sender) {
        if ([self.sourcePopOverView isDescendantOfView:self.view]) {
            [self.sourcePopOverView removeFromSuperview];
        } else {
            [self.view addSubview:self.sourcePopOverView];
        }
    }];
    [self.photoToolbarView.photoShootGridButton setTapHandler:^(id sender){
        GTIOPhotoShootGridViewController *photoShootGridViewController = [[GTIOPhotoShootGridViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:photoShootGridViewController animated:YES];
    }];
    [self.photoToolbarView.shutterButton setPhotoModeSwitchChangedHandler:^(BOOL on) {
        [blockSelf showFlashButton:!on];
        
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            NSError *error;
            if ([self.captureDevice lockForConfiguration:&error]) {
                [self.captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.captureDevice unlockForConfiguration];
            }
        }
        
        if (!blockSelf.isForcePhotoShootModeButtonToggle) {
            [blockSelf showPhotoShootModePopOverView];
        }
    }];
    [self.view addSubview:self.photoToolbarView];
    
    // Shutter flash overlay
    self.shutterFlashOverlay = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.photoToolbarView.frame.size.height } }];
    [self.shutterFlashOverlay setImage:[UIImage imageNamed:@"snap-overlay.png"]];
    [self.shutterFlashOverlay setAlpha:0.0f];
    [self.view addSubview:self.shutterFlashOverlay];
    
    // Photo shoot timer
    self.photoShootTimerView = [[GTIOPhotoShootTimerView alloc] initWithFrame:(CGRect){ (self.view.frame.size.width - 74) / 2, (self.view.frame.size.height - self.photoShootProgresToolbarView.frame.size.height - 74) / 2, 74, 74 }];
    [self.photoShootTimerView showPhotoShootTimer:NO];
    [self.view addSubview:self.photoShootTimerView];
    
    // Focus
    self.focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus-target.png"]];
    [self.focusImageView setFrame:(CGRect){ CGPointZero, self.focusImageView.image.size }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.flashButton = nil;
    self.photoToolbarView = nil;
    self.shutterFlashOverlay = nil;
    self.photoShootTimerView = nil;
    self.focusImageView = nil;
    
    [self.captureSession removeOutput:self.stillImageOutput];
    self.stillImageOutput = nil;
    self.captureVideoPreviewLayer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.photoShootModeFirstToggle = YES;
    
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.captureSession startRunning];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NSNotifications

- (void)didEnterBackgroundNotification:(NSNotification *)notification
{
    if (self.isShootingPhotoShoot) {
        self.photoShootTimerView.completionHandler = nil;
        [self.imageWaitTimer invalidate];
        [[GTIOPhotoManager sharedManager] removeAllPhotos];
        [self.photoShootTimerView setAlpha:0.0f];
        [self resetView];
        self.shootingPhotoShoot = NO;
    }
}

- (void)photoAcceptedNotification:(NSNotification *)notification
{
    UIImage *originalPhoto = [notification.userInfo objectForKey:@"originalPhoto"];
    UIImage *filteredPhoto = [notification.userInfo objectForKey:@"filteredPhoto"];
    NSString *filterName = [notification.userInfo objectForKey:@"filterName"];
    NSNumber *produdctID = [notification.userInfo objectForKey:@"productID"];
    
    if (filteredPhoto) {
        [self.postALookViewController setOriginalImage:originalPhoto filteredImage:filteredPhoto filterName:filterName productID:produdctID];
    }
    
    if ([self.navigationController.viewControllers containsObject:self.postALookViewController]) {
        // Pop filter view controller
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController pushViewController:self.postALookViewController animated:YES];
    }
}

#pragma mark

- (void)resetView
{
    [self.photoToolbarView setAlpha:1.0f];
    [self.photoShootProgresToolbarView setAlpha:0.0f];
    
    if ([[GTIOPhotoManager sharedManager] photoCount] > 0) {
        [self.photoToolbarView showPhotoShootGrid:YES];
    } else {
        [self.photoToolbarView showPhotoShootGrid:NO];
    }
    
    [self.photoToolbarView enableAllButtons:YES];
    [self showFlashButton:!self.photoToolbarView.shutterButton.isPhotoShootMode];
    [self.sourcePopOverView removeFromSuperview];
    
    self.forcePhotoShootModeButtonToggle = YES;
    [self.photoToolbarView.shutterButton setPhotoShootMode:NO];
    self.forcePhotoShootModeButtonToggle = NO;
}

#pragma mark - View Animations

- (void)showFlashButton:(BOOL)showFlashButton
{
    [UIView animateWithDuration:0.15f animations:^{
        CGFloat alpha = 0.0f;
        if (showFlashButton) {
            alpha = 1.0f;
        }
        [self.flashButton setAlpha:alpha];
    }];
}

- (void)showPhotoShootModePopOverView
{
    if (self.isPhotoShootModeFirstToggle && 
        self.photoShootModeCount < kGTIOShowPhotoShootModeHelperCount) {
        
        self.photoShootModeFirstToggle = NO;
        self.photoShootModeCount++;
        
        [self.photoShootPopOverView setAlpha:1.0f];
        [self.photoShootPopOverView setFrame:(CGRect){ { self.view.frame.size.width - self.photoShootPopOverView.image.size.width - kGTIOPhotoShootModePopOverXOriginPadding, self.view.frame.size.height - self.photoShootPopOverView.image.size.height - kGTIOPhotoShootModePopOverYOriginPadding }, self.photoShootPopOverView.image.size }];
        [self.view addSubview:self.photoShootPopOverView];
        
        [UIView animateWithDuration:1.5f delay:0.25f options:0 animations:^{
            [self.photoShootPopOverView setFrame:CGRectOffset(self.photoShootPopOverView.frame, 0, -24.0f)];
            [self.photoShootPopOverView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.photoShootPopOverView removeFromSuperview];
        }];
    }
}

#pragma mark - Property

- (void)setFlashOn:(BOOL)flashOn
{
    _flashOn = flashOn;
    
    NSString *imageName = @"upload.flash-OFF.png";
    if (_flashOn) {
        imageName = @"upload.flash-ON.png";
    }
    [self.flashButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setPhotoShootModeCount:(NSInteger)photoShootModeCount
{
    _photoShootModeCount = photoShootModeCount;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:photoShootModeCount] forKey:kGTIOPhotoShootModeCountUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Capture Image

- (void)captureImageWithHandler:(GTIOImageCapturedHandler)capturedImageHandler
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    
    // Show shutter overlay
    [UIView animateWithDuration:0.15f animations:^{
        [self.shutterFlashOverlay setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f animations:^{
            [self.shutterFlashOverlay setAlpha:0.0f];
        }];
    }];
    
    // Capture image
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
                [self captureImageWithHandler:capturedImageHandler];
            } else {
//                CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                NSLog(@"Captured photo");
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                // Crop image and then return it to sender
                if (capturedImageHandler) {
                    capturedImageHandler(image);
                }
            }
    }];
}

- (void)takePhotoBurstWithNumberOfPhotos:(NSInteger)numberOfPhotos
{
    self.startingPhotoCount = self.capturedImageCount;
    
    for (int i = 0; i < numberOfPhotos; i++) {
        double delayInSeconds = i * 0.6;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.isShootingPhotoShoot) {
                [self captureImageWithHandler:^(UIImage *photo) {
                    ++self.capturedImageCount;
                    [self.photoShootProgresToolbarView setNumberOfDotsOn:self.capturedImageCount];
                    
                    [[GTIOPhotoManager sharedManager] addPhoto:photo];
                }];
            }
        });
    }
    
    // TODO: Add a timeout here
    self.imageWaitTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(waitOnImages:) userInfo:nil repeats:YES];
}

- (void)waitOnImages:(NSTimer *)timer
{
    [self.photoShootProgresToolbarView setNumberOfDotsOn:self.capturedImageCount];
    if ((self.startingPhotoCount == 0 && self.capturedImageCount == 3) || 
        (self.startingPhotoCount == 3 && self.capturedImageCount == 6)) {
        
        NSTimeInterval timerDuration = [[[GTIOConfigManager sharedManager] config].photoShootSecondTimer intValue];
        if (self.capturedImageCount == 6) {
            timerDuration = [[[GTIOConfigManager sharedManager] config].photoShootThirdTimer intValue];
        }
        
        [self.imageWaitTimer invalidate];
        [self timerWithDuration:timerDuration];
        [self.photoShootTimerView showPhotoShootTimer:YES];
    } else if (self.startingPhotoCount == 6 && self.capturedImageCount == 9) {
        [self.imageWaitTimer invalidate];
        
        GTIOPhotoShootGridViewController *photoShootGridViewController = [[GTIOPhotoShootGridViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:photoShootGridViewController animated:YES];
        self.shootingPhotoShoot = NO;
    }
}

#pragma mark - Shutter Button

- (void)singleModeButtonPress
{
    
    [self.photoToolbarView enableAllButtons:NO];
    [self changeFlashForceOff:NO];
    [self captureImageWithHandler:^(UIImage *photo) {
        [self.captureSession stopRunning]; 
        // Process image
        GTIOProcessImageRequest *processImageRequest = [[GTIOProcessImageRequest alloc] init];
        [processImageRequest setRawImage:photo];
        [self openPhotoConfirmationScreenWithPhoto:processImageRequest.processedImage];
    }];
}

- (void)photoShootModeButtonPress
{
    self.shootingPhotoShoot = YES;
    [self.photoToolbarView enableAllButtons:NO];
    [self changeFlashForceOff:YES];
    [UIView animateWithDuration:0.3 animations:^{
        // Switch tool bars
        [self.photoShootProgresToolbarView setAlpha:1.0f];
        [self.photoToolbarView setAlpha:0.0f];
    }];
    
    // Clear current photos
    self.capturedImageCount = 0;
    [[GTIOPhotoManager sharedManager] removeAllPhotos];
    [self.photoShootProgresToolbarView setNumberOfDotsOn:0];
    
    // Show timer
    [self.photoShootTimerView showPhotoShootTimer:YES];
    
    [self timerWithDuration:[[[GTIOConfigManager sharedManager] config].photoShootFirstTimer intValue]];
}

- (void)timerWithDuration:(NSTimeInterval)duration
{
    [self.photoShootTimerView startWithDuration:duration completionHandler:^(GTIOPhotoShootTimerView *photoShootTimerView) {
        // Take first batch of photos
        [self.photoShootTimerView showPhotoShootTimer:NO];
        [self takePhotoBurstWithNumberOfPhotos:3];
    }];
}

#pragma mark - Flash Helpers

- (void)changeFlashForceOff:(BOOL)forceOff
{
    if (self.isFlashOn && !forceOff) {
        [self changeFlashMode:AVCaptureFlashModeOn];
    } else {
        [self changeFlashMode:AVCaptureFlashModeOff];
    }
}

- (void)changeFlashMode:(AVCaptureFlashMode)flashMode
{
    NSError *error = nil;
    if ([self.captureDevice isFlashModeSupported:flashMode] &&
            [self.captureDevice lockForConfiguration:&error]) {
            [self.captureDevice setFlashMode:flashMode];
            [self.captureDevice unlockForConfiguration];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    GTIOProcessImageRequest *processImageRequest = [[GTIOProcessImageRequest alloc] init];
    [processImageRequest setRawImage:image];
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
    [self openPhotoConfirmationScreenWithPhoto:processImageRequest.processedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Launch Screens

- (void)openPhotoConfirmationScreenWithPhoto:(UIImage *)photo
{
    GTIOPhotoConfirmationViewController *photoConfirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
    [photoConfirmationViewController setOriginalPhoto:photo];
    [self.navigationController pushViewController:photoConfirmationViewController animated:YES];
}

- (void)openPhotoConfirmationScreenWithProduct:(GTIOProduct *)product
{
    GTIOPhotoConfirmationViewController *photoConfirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
    [photoConfirmationViewController setOriginalPhotoURL:product.photo.mainImageURL];
    [photoConfirmationViewController setProductID:product.productID];
    [self.navigationController pushViewController:photoConfirmationViewController animated:YES];
}

#pragma mark - Focus

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect flashButtonTouchRect = (CGRect){ 0, 0, self.flashButton.frame.origin.x * 2 + self.flashButton.frame.size.width, (self.flashButton.frame.origin.y - 10) * 2 + self.flashButton.frame.size.height };
    
    if ([self.captureVideoPreviewLayer containsPoint:[touch locationInView:self.view]] && 
        !self.photoToolbarView.shutterButton.isPhotoShootMode  &&
        !CGRectContainsPoint(flashButtonTouchRect, [touch locationInView:self.view]) &&
        !CGRectContainsPoint(self.sourcePopOverView.frame, [touch locationInView:self.view])) {
        [self.sourcePopOverView removeFromSuperview];
        return YES;
    } else if (CGRectContainsPoint(self.sourcePopOverView.frame, [touch locationInView:self.view]) ||
               CGRectContainsPoint(self.photoToolbarView.photoSourceButton.frame, [touch locationInView:self.photoToolbarView])) {
        // Touched on Source Pop Over or source pop over button 
        return NO;
    } else {
        [self.sourcePopOverView removeFromSuperview];
        return NO;
    }
}

- (void)tapToFocus:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint locationInView = [tapGestureRecognizer locationInView:self.view];
        
        if ([self.captureVideoPreviewLayer containsPoint:locationInView]) {
            [self focusAtPoint:locationInView];
        }
    }
}

- (void)focusAtPoint:(CGPoint)point
{
    if ([self.captureDevice isFocusPointOfInterestSupported] && [self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.focusImageView setCenter:point];
        [self animateTapToFocusImage];
        
        NSError *error;
        if ([self.captureDevice lockForConfiguration:&error]) {
            CGPoint focalPoint = (CGPoint){ point.y / self.captureVideoPreviewLayer.frame.size.height, (self.captureVideoPreviewLayer.frame.size.width - point.x) / self.captureVideoPreviewLayer.frame.size.height };
            [self.captureDevice setFocusPointOfInterest:focalPoint];
            [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [self.captureDevice unlockForConfiguration];
        } else {
            NSLog(@"Could not focus: %@", [error localizedDescription]);
        }
    }
}

- (void)animateTapToFocusImage
{
    [self.view addSubview:self.focusImageView];
    
    CALayer *layerToModify = self.focusImageView.layer;
    
    CAKeyframeAnimation *pulseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D startingTransform = CATransform3DScale(layerToModify.transform, 2.0, 2.0, 2.0);
    CATransform3D scaledTransform = CATransform3DScale(layerToModify.transform, 1.2, 1.2, 1.0);
    CATransform3D halfScaleTransform = CATransform3DScale(layerToModify.transform, 0.8, 0.8, 1.0);
    CATransform3D endingTransform = layerToModify.transform;
    
    NSArray *animationValues = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:startingTransform], 
                                [NSValue valueWithCATransform3D:halfScaleTransform], 
                                [NSValue valueWithCATransform3D:scaledTransform],
                                [NSValue valueWithCATransform3D:endingTransform], 
                                nil];
    [pulseAnimation setValues:animationValues];
    
    NSArray *timeValues = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.25f],
                           [NSNumber numberWithFloat:0.4f],
                           [NSNumber numberWithFloat:0.5f],
                           nil];
    [pulseAnimation setKeyTimes:timeValues];
    
    [pulseAnimation setFillMode:kCAFillModeForwards];
    [pulseAnimation setRemovedOnCompletion:NO];
    
    
    CAKeyframeAnimation *flashAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    [flashAnimation setValues:[NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:1.0f],
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               [NSNumber numberWithFloat:0.0f],
                               nil]];
    [flashAnimation setKeyTimes:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f], 
                                 [NSNumber numberWithFloat:0.5f], 
                                 [NSNumber numberWithFloat:0.6f], 
                                 [NSNumber numberWithFloat:0.7f], 
                                 [NSNumber numberWithFloat:0.8f], 
                                 [NSNumber numberWithFloat:0.9f], 
                                 [NSNumber numberWithFloat:1.0f], 
                                 nil]];
    [flashAnimation setFillMode:kCAFillModeForwards];
    [flashAnimation setRemovedOnCompletion:YES];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:[NSArray arrayWithObjects:pulseAnimation, flashAnimation, nil]];
    [animationGroup setDuration:0.75f];
    [animationGroup setDelegate:self];
    
    [layerToModify addAnimation:animationGroup forKey:@"pulseAnimation"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.focusImageView removeFromSuperview];
}

@end
