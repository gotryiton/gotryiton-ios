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

#import "GTIOConfig.h"
#import "GTIOConfigManager.h"

#import "GTIOResizePhotoOperation.h"

#import "GTIOPhotoShootGridViewController.h"
#import "GTIOPhotoConfirmationViewController.h"
#import "GTIOPostALookViewController.h"

NSString * const kGTIOPhotoAcceptedNotification = @"GTIOPhotoAcceptedNotification";

static CGFloat const kGTIOToolbarHeight = 53.0f;

@interface GTIOCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;

@property (nonatomic, strong) GTIOCameraToolbarView *photoToolbarView;
@property (nonatomic, strong) GTIOPhotoShootProgressToolbarView *photoShootProgresToolbarView;
@property (nonatomic, strong) GTIOButton *flashButton;
@property (nonatomic, strong) UIImageView *shutterFlashOverlay;
@property (nonatomic, strong) GTIOPhotoShootTimerView *photoShootTimerView;

@property (nonatomic, strong) NSMutableArray *capturedImages;
@property (nonatomic, assign) NSInteger capturedImageCount;
@property (nonatomic, strong) NSMutableArray *resizedImages;
@property (nonatomic, strong) NSOperationQueue *photoResizeQueue;

@property (nonatomic, assign) NSInteger startingPhotoCount;
@property (nonatomic, strong) NSTimer *imageWaitTimer;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) GTIOPostALookViewController *postALookViewController;

@property (nonatomic, assign, getter = isShootingPhotoShoot) BOOL shootingPhotoShoot;

@end

@implementation GTIOCameraViewController

@synthesize captureSession = _captureSession, stillImageOutput = _stillImageOutput, captureVideoPreviewLayer = _captureVideoPreviewLayer, captureDevice = _captureDevice;
@synthesize photoToolbarView = _photoToolbarView, photoShootProgresToolbarView = _photoShootProgresToolbarView, photoShootTimerView = _photoShootTimerView;
@synthesize flashButton = _flashButton;
@synthesize flashOn = _flashOn, shutterFlashOverlay = _shutterFlashOverlay;
@synthesize dismissHandler = _dismissHandler;
@synthesize capturedImages = _capturedImages;
@synthesize capturedImageCount = _capturedImageCount;
@synthesize resizedImages = _resizedImages;
@synthesize photoResizeQueue = _photoResizeQueue;
@synthesize imageWaitTimer = _imageWaitTimer;
@synthesize startingPhotoCount = _startingPhotoCount;
@synthesize imagePickerController = _imagePickerController;
@synthesize postALookViewController = _postALookViewController;
@synthesize shootingPhotoShoot = _shootingPhotoShoot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setWantsFullScreenLayout:YES];
        
        _captureSession = [[AVCaptureSession alloc] init];
        
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self changeFlashMode:AVCaptureFlashModeOff];
        
        if ([_captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]) {
            NSLog(@"Using preset high");
            _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        } else {
            NSLog(@"Using preset photo");
            _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        }
        
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
        
        _capturedImages = [NSMutableArray array];
        _capturedImageCount = 0;
        _resizedImages = [NSMutableArray array];
        _photoResizeQueue = [[NSOperationQueue alloc] init];
        [_photoResizeQueue setMaxConcurrentOperationCount:1];
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
        
        _postALookViewController = [[GTIOPostALookViewController alloc] initWithNibName:nil bundle:nil];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kGTIOPhotoAcceptedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            UIImage *photo = [note.userInfo objectForKey:@"photo"];
            
            if (photo) {
                [_postALookViewController setMainImage:photo];
                [self.navigationController pushViewController:_postALookViewController animated:YES];
            }
        }]; 
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            if (self.isShootingPhotoShoot) {
                self.photoShootTimerView.completionHandler = nil;
                [self.imageWaitTimer invalidate];
                [self.capturedImages removeAllObjects];
                [self.photoShootTimerView setAlpha:0.0f];
                [self resetView];
                self.shootingPhotoShoot = NO;
            }
        }];
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
    self.flashButton = [GTIOButton buttonWithGTIOType:GTIOButtonTypePhotoFlash];
    [self.flashButton setFrame:(CGRect){ { 5, 26 }, self.flashButton.frame.size }];
    __block typeof(self) blockSelf = self;
    [self.flashButton setTapHandler:^(id sender) {
        blockSelf.flashOn = !blockSelf.isFlashOn;
    }];
    
    if ([self.captureDevice isFlashAvailable]) {
        [self.view addSubview:self.flashButton];
    }
    
    // Photo Shoot Toolbar
    self.photoShootProgresToolbarView = [[GTIOPhotoShootProgressToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - kGTIOToolbarHeight, self.view.frame.size.width, kGTIOToolbarHeight }];
    [self.photoShootProgresToolbarView setAlpha:0.0f];
    [self.view addSubview:self.photoShootProgresToolbarView];
    
    // Toolbar
    self.photoToolbarView = [[GTIOCameraToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - kGTIOToolbarHeight, self.view.frame.size.width, kGTIOToolbarHeight }];
    [self.photoToolbarView.closeButton setTapHandler:^(id sender) {
        if (blockSelf.dismissHandler) {
            blockSelf.dismissHandler(blockSelf);
        }
    }];
    [self.photoToolbarView.shutterButton setTapHandler:^(id sender) {
        if (self.photoToolbarView.photoModeSwitch.isOn) {
            [blockSelf photoShootModeButtonPress];
        } else {
            [blockSelf singleModeButtonPress];
        }
    }];
    [self.photoToolbarView.photoPickerButton setTapHandler:^(id sender) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [blockSelf presentViewController:self.imagePickerController animated:YES completion:nil];
        }
    }];
    [self.photoToolbarView.photoShootGridButton setTapHandler:^(id sender){
        GTIOPhotoShootGridViewController *photoShootGridViewController = [[GTIOPhotoShootGridViewController alloc] initWithNibName:nil bundle:nil];
        [photoShootGridViewController setImages:self.capturedImages];
        [self.navigationController pushViewController:photoShootGridViewController animated:YES];
    }];
    [self.photoToolbarView setPhotoModeSwitchChangedHandler:^(BOOL on) {
        [blockSelf showFlashButton:!on];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.flashButton = nil;
    self.photoToolbarView = nil;
    self.shutterFlashOverlay = nil;
    self.captureVideoPreviewLayer = nil;
    self.photoShootTimerView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

#pragma mark - 

- (void)resetView
{
    [self.photoToolbarView setAlpha:1.0f];
    [self.photoShootProgresToolbarView setAlpha:0.0f];
    
    if ([self.resizedImages count] > 0) {
        [self.photoToolbarView showPhotoShootGrid:YES];
    } else {
        [self.photoToolbarView showPhotoShootGrid:NO];
    }
    
    [self.photoToolbarView enableAllButtons:YES];
    [self showFlashButton:![self.photoToolbarView.photoModeSwitch isOn]];
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
        double delayInSeconds = i * 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.isShootingPhotoShoot) {
                [self captureImageWithHandler:^(UIImage *photo) {
                    ++self.capturedImageCount;
                    [self.photoShootProgresToolbarView setNumberOfDotsOn:self.capturedImageCount];
                    
                    GTIOResizePhotoOperation *resizePhotoOperation = [[GTIOResizePhotoOperation alloc] initWithPhoto:photo completionHandler:^(UIImage *resizedPhoto) {
                        NSLog(@"adding image to array");
                        [self.resizedImages addObject:resizedPhoto];
                    }];
                    [self.photoResizeQueue addOperation:resizePhotoOperation];
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
        
        [self.imageWaitTimer invalidate];
        [self timerWithDuration:2];
        [self.photoShootTimerView showPhotoShootTimer:YES];
    } else if (self.startingPhotoCount == 6 && self.capturedImageCount == 9) {
        [self.imageWaitTimer invalidate];
        
        [self.photoResizeQueue waitUntilAllOperationsAreFinished];
        
        // TODO: dispatch this a second later to let the photos add
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            GTIOPhotoShootGridViewController *photoShootGridViewController = [[GTIOPhotoShootGridViewController alloc] initWithNibName:nil bundle:nil];
            [photoShootGridViewController setImages:self.resizedImages];
            [self.navigationController pushViewController:photoShootGridViewController animated:YES];
            self.shootingPhotoShoot = NO;
        });
    }
}

#pragma mark - Shutter Button

- (void)singleModeButtonPress
{
    [self.photoToolbarView enableAllButtons:NO];
    [self changeFlashForceOff:NO];
    [self captureImageWithHandler:^(UIImage *photo) {
        GTIOResizePhotoOperation *resizePhotoOperation = [[GTIOResizePhotoOperation alloc] initWithPhoto:photo completionHandler:^(UIImage *resizedPhoto) {
            [self openPhotoConfirmationScreenWithPhoto:resizedPhoto];
        }];
        [self.photoResizeQueue addOperation:resizePhotoOperation];
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
    [self.capturedImages removeAllObjects];
    [self.photoShootProgresToolbarView setNumberOfDotsOn:0];
    
    // Show timer
    [self.photoShootTimerView showPhotoShootTimer:YES];

    GTIOConfig *config = [[GTIOConfigManager sharedManager] config];
    [self timerWithDuration:6];
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
    if ([self.captureDevice lockForConfiguration:&error]) {
        [self.captureDevice setFlashMode:flashMode];
        [self.captureDevice unlockForConfiguration];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // TODO: How should we handle smaller images than 640?
//    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:(CGSize){ kGTIOPhotoResizeWidth, CGFLOAT_MAX } interpolationQuality:kCGInterpolationHigh];
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
//    [self openPhotoConfirmationScreenWithPhoto:resizedImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Launch Screens

- (void)openPhotoConfirmationScreenWithPhoto:(UIImage *)photo
{
    GTIOPhotoConfirmationViewController *photoConfirmationViewController = [[GTIOPhotoConfirmationViewController alloc] initWithNibName:nil bundle:nil];
    [photoConfirmationViewController setPhoto:photo];
    [self.navigationController pushViewController:photoConfirmationViewController animated:YES];
}

@end
