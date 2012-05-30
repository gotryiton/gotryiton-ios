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

@interface GTIOCameraViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, strong) GTIOCameraToolbarView *photoToolbarView;
@property (nonatomic, strong) GTIOPhotoShootProgressToolbarView *photoShootProgresToolbarView;
@property (nonatomic, strong) GTIOButton *flashButton;
@property (nonatomic, assign, getter = isFlashOn) BOOL flashOn;
@property (nonatomic, strong) UIImageView *shutterFlashOverlay;

@end

@implementation GTIOCameraViewController

@synthesize captureSession = _captureSession, stillImageOutput = _stillImageOutput, captureVideoPreviewLayer = _captureVideoPreviewLayer;
@synthesize photoToolbarView = _photoToolbarView, photoShootProgresToolbarView = _photoShootProgresToolbarView;
@synthesize flashButton = _flashButton;
@synthesize flashOn = _flashOn, shutterFlashOverlay = _shutterFlashOverlay;
@synthesize dismissHandler = _dismissHandler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setWantsFullScreenLayout:YES];
        
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        if ([self.captureSession canAddInput:input]) {
            [self.captureSession addInput:input];
        } else {
            NSLog(@"Can't add video");
        }
    }
    return self;
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
    layerRect.size.height -= 53;
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
    [self.flashButton setFrame:(CGRect){ { 5, 6 }, self.flashButton.frame.size }];
    
    [self.flashButton setTapHandler:^(id sender) {
        self.flashOn = !self.isFlashOn;
        
        NSString *imageName = @"upload.flash-OFF.png";
        if (self.isFlashOn) {
            imageName = @"upload.flash-ON.png";
        }
        [self.flashButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }];
    [self.view addSubview:self.flashButton];
    
    // Photo Shoot Toolbar
    self.photoShootProgresToolbarView = [[GTIOPhotoShootProgressToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - 53, self.view.frame.size.width, 53 }];
    [self.photoShootProgresToolbarView setAlpha:0.0f];
    [self.view addSubview:self.photoShootProgresToolbarView];
    
    // Toolbar
    self.photoToolbarView = [[GTIOCameraToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - 53, self.view.frame.size.width, 53 }];
    __block typeof(self) blockSelf = self;
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
    [self.view addSubview:self.photoToolbarView];
    
    // Shutter flash overlay
    self.shutterFlashOverlay = [[UIImageView alloc] initWithFrame:(CGRect){ CGPointZero, { self.view.frame.size.width, self.view.frame.size.height - self.photoToolbarView.frame.size.height } }];
    [self.shutterFlashOverlay setImage:[UIImage imageNamed:@"snap-overlay.png"]];
    [self.shutterFlashOverlay setAlpha:0.0f];
    [self.view addSubview:self.shutterFlashOverlay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.flashButton = nil;
    self.photoToolbarView = nil;
    self.shutterFlashOverlay = nil;
    self.captureVideoPreviewLayer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.captureSession startRunning];
    });
    
    [self.flashButton setAlpha:1.0f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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

#pragma mark - Capture Image

- (void)captureImage
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
    
    // Show flash overlay
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
            } else {
                CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
                if (exifAttachments) {
                    // Do something with the attachments.
                    NSLog(@"attachements: %@", exifAttachments);
                } else {
                    NSLog(@"no attachments");
                }
                
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                
                //TODO: Handle image captured
            }
    }];
}

#pragma mark - Shutter Button

- (void)singleModeButtonPress
{
    
}

- (void)photoShootModeButtonPress
{
    [UIView animateWithDuration:0.3 animations:^{
        // Hide flash button
        [self.flashButton setAlpha:0.0f];
        
        // Switch tool bars
        [self.photoShootProgresToolbarView setAlpha:1.0f];
        [self.photoToolbarView setAlpha:0.0f];
    }];
    
    // Show timer
}

@end
