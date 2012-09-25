//
//  GTIOTrack.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOTrack.h"

#import <RestKit/RestKit.h>

NSString * const kGTIOTrackAppLaunch = @"App Launch";
NSString * const kGTIOTrackAppResumeFromBackground = @"Resume from background";
NSString * const kGTIOTrackSignIn = @"Sign in view";
NSString * const kGTIOTrackPhotoShootStarted = @"Photoshoot started";
NSString * const kGTIOTrackPostSharedTwitter = @"post shared on twitter";
NSString * const kGTIOTrackPostSharedFacebook = @"post shared on facebook";
NSString * const kGTIOTrackPostSharedInstagram = @"post shared on instagram";

NSString * const kGTIOTrackIDKey = @"GTIOTrackIDKey";
NSString * const kGTIOPageNumberKey = @"GTIOPageNumberKey";
NSString * const kGTIOPostIDKey = @"GTIOPostIDKey";

@interface GTIOTrack ()

+ (void)postTrack:(GTIOTrack *)track;
+ (GTIOTrack *)trackWithID:(NSString *)trackID visit:(BOOL)visit handler:(GTIOTrackHandler)handler;

@end

@implementation GTIOTrack


+ (GTIOTrack *)trackWithID:(NSString *)trackID visit:(BOOL)visit handler:(GTIOTrackHandler)handler
{
    GTIOTrack *track = [[self alloc] init];
    track.trackID = trackID;
    track.trackHandler = handler;
    
    if (visit) {
        track.visit = [GTIOVisit visit];
    }
    
    return track;
}

+ (void)postTrack:(GTIOTrack *)track
{
    [[RKObjectManager sharedManager] postObject:track usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object) {
            if (track.trackHandler) {
                track.trackHandler(object, nil);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            if (track.trackHandler) {
                track.trackHandler(nil, error);
            }
        };
    }];
}

+ (void)postTrack:(GTIOTrack *)track handler:(GTIOTrackHandler)trackHandler
{
    track.trackHandler = trackHandler;
    [GTIOTrack postTrack:track];
}

+ (void)postTrackWithID:(NSString *)trackID handler:(GTIOTrackHandler)trackHandler
{
    GTIOTrack *track = [GTIOTrack trackWithID:trackID visit:NO handler:trackHandler];
    [GTIOTrack postTrack:track];
}

+ (void)postTrackWithID:(NSString *)trackID postID:(NSString *)postID handler:(GTIOTrackHandler)trackHandler
{
    GTIOTrack *track = [GTIOTrack trackWithID:trackID visit:NO handler:trackHandler];
    track.postID = postID;
    [GTIOTrack postTrack:track];
}

+ (void)postTrackAndVisitWithID:(NSString *)trackID handler:(GTIOTrackHandler)trackHandler
{
    GTIOTrack *track = [GTIOTrack trackWithID:trackID visit:YES handler:trackHandler];
    [GTIOTrack postTrack:track];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.trackID = [coder decodeObjectForKey:kGTIOTrackIDKey];
        self.pageNumber = [coder decodeObjectForKey:kGTIOPageNumberKey];
        self.postID = [coder decodeObjectForKey:kGTIOPostIDKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    if (self.trackID) {
        [coder encodeObject:self.trackID forKey:kGTIOTrackIDKey];
    }
    if (self.pageNumber) {
        [coder encodeObject:self.pageNumber forKey:kGTIOPageNumberKey];
    }
    if (self.postID) {
        [coder encodeObject:self.postID forKey:kGTIOPostIDKey];
    }
}

@end
