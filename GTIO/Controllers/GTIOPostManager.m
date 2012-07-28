//
//  GTIOPostManager.m
//  GTIO
//
//  Created by Scott Penrose on 7/3/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPostManager.h"

#import "GTIOPhoto.h"

@interface GTIOPostManager () <RKRequestDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) GTIOPhoto *photo;
@property (nonatomic, strong) RKRequest *uploadImageRequest;

@property (nonatomic, strong) NSString *postDescription;
@property (nonatomic, strong) NSDictionary *attachedProducts;
@property (nonatomic, strong) NSDictionary *filterNames;

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
        
        request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
        
        request.onDidLoadResponse = ^(RKResponse *response) {
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
                    [self savePostWithDescription:self.postDescription attachedProducts:self.attachedProducts completionHandler:self.postCompletionHandler];
                }
            } else {
                [self changeState:GTIOPostStateError];
                NSLog(@"Error uploading image");
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            [self changeState:GTIOPostStateError];
            NSLog(@"There was an error while posting the photo. (Server error: %@)", [error localizedDescription]);
        };
        
        request.delegate = self;
    }];
}

- (void)cancelUploadImage
{
    [self changeState:GTIOPostStateCancelled];
    [self.uploadImageRequest cancel];
}

- (void)savePostWithDescription:(NSString *)description attachedProducts:(NSDictionary *)attachedProducts completionHandler:(GTIOPostCompletionHandler)completionHandler
{
    self.postDescription = description;
    self.attachedProducts = attachedProducts;
    self.postCompletionHandler = completionHandler;
    
    if (self.state == GTIOPostStateUploadingImageComplete && self.photo) {
        [self changeState:GTIOPostStateSavingPost];
        [self savePhotoToDisk];
        [GTIOPost postGTIOPhoto:self.photo description:self.postDescription attachedProducts:self.attachedProducts completionHandler:^(GTIOPost *post, NSError *error) {
            if (!error) {
                _post = post;
                [self changeState:GTIOPostStateComplete];
            } else {
                [self changeState:GTIOPostStateError];
                NSLog(@"There was an error while posting the post. (Server error: %@)", [error localizedDescription]);
            }
            
            if (self.postCompletionHandler) {
                self.postCompletionHandler(post, error);
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
    if (totalBytesExpectedToWrite > 0) {
        CGFloat progress = ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
        [self changeProgress:progress];
    }
}

@end
