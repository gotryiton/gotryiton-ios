//
//  GTIOCameraViewController.m
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOCameraViewController.h"

#import "GTIOPhotoToolbarView.h"

@interface GTIOCameraViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) GTIOPhotoToolbarView *photoToolbarView;

@end

@implementation GTIOCameraViewController

@synthesize captureSession = _captureSession;
@synthesize photoToolbarView = _photoToolbarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setWantsFullScreenLayout:YES];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:self.tabBarController.view.bounds];
    [self.view setAutoresizesSubviews:YES];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view setBackgroundColor:[UIColor greenColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    // Setup preview
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CGRect layerRect = self.view.layer.bounds;
    layerRect.size.height -= 53;
	[captureVideoPreviewLayer setBounds:layerRect];
	[captureVideoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
	[self.view.layer addSublayer:captureVideoPreviewLayer];
    
    // Toolbar
    self.photoToolbarView = [[GTIOPhotoToolbarView alloc] initWithFrame:(CGRect){ 0, self.view.frame.size.height - 53, self.view.frame.size.width, 53 }];
    [self.view addSubview:self.photoToolbarView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.captureSession = nil;
    self.photoToolbarView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.tabBarController.tabBar setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
