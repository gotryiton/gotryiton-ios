//
//  GTIOPostManager.m
//  GTIO
//
//  Created by Scott Penrose on 7/3/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostManager.h"

#import "GTIOPhoto.h"

static NSTimeInterval const kGTIOPhotoCreateTimeoutInterval = 15.0f;
static NSTimeInterval const kGTIOPhotoCreateInitialTimeoutInterval = 40.0f;

@interface GTIOPostManager () <RKRequestDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) RKRequest *uploadImageRequest;

@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSDictionary *attachedProducts;
@property (nonatomic, strong) NSDictionary *filterNames;

@property (nonatomic, strong) NSTimer *photoCreateTimer;

@end

@implementation GTIOPostManager

+ (GTIOPostManager *)sharedManager
{
    static GTIOPostManager *gtio_shared_postManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gtio_shared_postManager = [[self alloc] init];
    });
    return gtio_shared_postManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _state = GTIOPostStateNone;
        _progress = 0.0f;
    }
    return self;
}

- (void)dealloc
{
    [self.photoCreateTimer invalidate];
}

#pragma mark Photo

- (void)uploadImage:(UIImage *)image framed:(BOOL)framed filterNames:(NSDictionary *)filterNames forceSavePost:(BOOL)forceSavePost
{
    [self.uploadImageRequest cancel];
    
    self.image = image;
    self.framed = framed;
    self.filterNames = filterNames;
    
    _post = nil;
    self.photo = nil;
    [self changeState:GTIOPostStateUploadingImage];
    [self changeProgress:0.0f];
    
    [[RKClient sharedClient] post:@"/photo/create" usingBlock:^(RKRequest *request) {
        self.uploadImageRequest = request;
        self.photoCreateTimer = [NSTimer scheduledTimerWithTimeInterval:kGTIOPhotoCreateInitialTimeoutInterval target:self selector:@selector(uploadImageTimeout) userInfo:nil repeats:NO];
        
        RKParams *params = [RKParams params];
        [params setValue:[NSNumber numberWithBool:self.framed] forParam:@"using_frame"];
        
        if (self.framed) {
            [params setValue:[filterNames objectForKey:@"0"] forParam:@"using_filter_in_frame_0"];
            [params setValue:[filterNames objectForKey:@"1"] forParam:@"using_filter_in_frame_1"];
            [params setValue:[filterNames objectForKey:@"2"] forParam:@"using_filter_in_frame_2"];
        } else {
            [params setValue:[filterNames objectForKey:@"0"] forParam:@"using_filter"];
        }
        
        NSData* imageData = UIImagePNGRepresentation(image);
        [params setData:imageData MIMEType:@"image/jpeg" forParam:@"image"];
        
        request.params = params;
        request.backgroundPolicy = RKRequestBackgroundPolicyCancel;
        
        request.onDidLoadResponse = ^(RKResponse *response) {
            [self.photoCreateTimer invalidate];
            if (response.isSuccessful) {
                [self changeState:GTIOPostStateUploadingImageComplete];
                
                RKObjectMappingProvider* provider = [RKObjectManager sharedManager].mappingProvider;
                NSDictionary *parsedBody = [[response bodyAsString] objectFromJSONString];
                if (parsedBody) {
                    RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedBody mappingProvider:provider];
                    RKObjectMappingResult *result = [mapper performMapping];
                    self.photo = (GTIOPhoto *)[result asObject];
                }
                
                if (self.postPhotoButtonTouched || forceSavePost) {
                    self.postPhotoButtonTouched = NO;
                    [self savePostWithDescription:self.postDescription facebookShare:self.facebookShare attachedProducts:self.attachedProducts];
                }
            } else {
                [self changeState:GTIOPostStateError];
                NSLog(@"Error uploading image");
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            [self.photoCreateTimer invalidate];
            [self changeState:GTIOPostStateError];
            NSLog(@"There was an error while posting the photo. (Server error: %@)", [error localizedDescription]);
        };
        
        request.delegate = self;
    }];
}

- (void)cancelUploadImage
{
    [self changeState:GTIOPostStateCancelledImageUpload];
    [self.uploadImageRequest cancel];
}

- (void)uploadImageTimeout
{
    NSLog(@"Upload image timeout");
    [self changeState:GTIOPostStateError];
    [self.uploadImageRequest cancel];
}

#pragma mark - Post

- (void)savePostWithDescription:(NSString *)description facebookShare:(BOOL)facebookShare attachedProducts:(NSDictionary *)attachedProducts
{
    self.postDescription = description;
    self.attachedProducts = attachedProducts;
    self.facebookShare = facebookShare;
    
    if (self.state == GTIOPostStateUploadingImageComplete && self.photo) {
        [self changeState:GTIOPostStateSavingPost];
        [self savePhotoToDisk];
        [GTIOPost postGTIOPhoto:self.photo description:self.postDescription facebookShare:self.facebookShare attachedProducts:self.attachedProducts completionHandler:^(GTIOPost *post, NSError *error) {
            if (!error) {
                _post = post;
                [self changeState:GTIOPostStateComplete];
            } else {
                [self changeState:GTIOPostStateCancelledPost]; // Even though this error we want to cancel upload
                NSLog(@"There was an error while posting the post. (Server error: %@)", [error localizedDescription]);
            }
        }];
        [self setPostPhotoButtonTouched:NO];
    }
}

- (void)retry
{
    [self uploadImage:self.image framed:self.framed filterNames:self.filterNames forceSavePost:YES];
}

- (void)savePhotoToDisk
{
    UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
}

#pragma mark - KVO Helpers

- (void)changeState:(GTIOPostState)state
{
    [self willChangeValueForKey:@"state"];
    _state = state;
    [self didChangeValueForKey:@"state"];
}

- (void)changeProgress:(CGFloat)progress
{
    [self willChangeValueForKey:@"progress"];
    _progress = progress;
    [self didChangeValueForKey:@"progress"];
}

#pragma mark - RKRequestDelegate

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self.photoCreateTimer invalidate];
    self.photoCreateTimer = [NSTimer scheduledTimerWithTimeInterval:kGTIOPhotoCreateTimeoutInterval target:self selector:@selector(uploadImageTimeout) userInfo:nil repeats:NO];
    
//    NSLog(@"bytes written: %i, \ttotal bytes written: %i, \ttotal bytes expected to write: %i", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    if (totalBytesExpectedToWrite > 0) {
        CGFloat progress = ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
        [self changeProgress:progress];
    }
}

@end
