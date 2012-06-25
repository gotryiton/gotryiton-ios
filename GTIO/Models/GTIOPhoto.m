//
//  GTIOPhoto.m
//  GTIO
//
//  Created by Geoffrey Mackey on 6/6/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import "GTIOPhoto.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>

@interface GTIOPhoto()

@property (nonatomic, strong) RKRequest *currentCreatePhotoRequest;

@end

@implementation GTIOPhoto

@synthesize photoID = _photoID, userID = _userID, url = _url, width = _width, height = _height, currentCreatePhotoRequest = _currentCreatePhotoRequest;
@synthesize mainImageURL = _mainImageURL, squareThumbnailURL = _squareThumbnailURL, smallThumbnailURL = _smallThumbnailURL;

+ (GTIOPhoto *)createGTIOPhotoWithUIImage:(UIImage *)image framed:(BOOL)framed filter:(NSString *)filterName completionHandler:(GTIOPhotoCreationHandler)completionHandler
{
    GTIOPhoto *photo = [[self alloc] init];
    NSString *createPhotoResourcePath = @"/photo/create";
    
    [[RKClient sharedClient] post:createPhotoResourcePath usingBlock:^(RKRequest *request) {
        photo.currentCreatePhotoRequest = request;
        RKParams *params = [RKParams params];
        [params setValue:filterName forParam:@"using_filter"];
        [params setValue:[NSNumber numberWithBool:framed] forParam:@"using_frame"];
        NSData* imageData = UIImagePNGRepresentation(image);
        [params setData:imageData MIMEType:@"image/jpeg" forParam:@"image"];
        
        request.params = params;
        
        request.backgroundPolicy = RKRequestBackgroundPolicyRequeue;
        
        request.onDidLoadResponse = ^(RKResponse *response) {
            GTIOPhoto *photo = nil;
            RKObjectMappingProvider* provider = [RKObjectManager sharedManager].mappingProvider;
            NSDictionary *parsedBody = [[response bodyAsString] objectFromJSONString];
            if (parsedBody) {
                RKObjectMapper *mapper = [RKObjectMapper mapperWithObject:parsedBody mappingProvider:provider];
                RKObjectMappingResult *result = [mapper performMapping];
                photo = (GTIOPhoto *)[result asObject];
            }
            if (completionHandler) {
                completionHandler(photo, nil);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
        };
    }];
    
    return photo;
}

- (void)cancel
{
    [self.currentCreatePhotoRequest cancel];
}

- (CGSize)photoSize
{
    return (CGSize){ [self.width intValue], [self.height intValue] };
}

#warning Used for testing
- (NSNumber *)width
{
    return [NSNumber numberWithInt:454];
}

- (NSNumber *)height
{
    return [NSNumber numberWithInt:604];
}
#warning End Used for testing

@end
