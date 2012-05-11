//
//  GTIOTrack.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOTrack.h"

#import <RestKit/RestKit.h>

@implementation GTIOTrack

@synthesize trackID = _trackID, visit = _visit;

+ (GTIOTrack *)track
{
    GTIOTrack *track = [[self alloc] init];
    
    track.trackID = [NSNumber numberWithInt:123];
    track.visit = [GTIOVisit visit];
    
    return track;
}

+ (void)postTrackUsingBlock:(GTIOTrackHandler)trackHandler
{
    [[RKObjectManager sharedManager] postObject:[GTIOTrack track] usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object) {
            if (trackHandler) {
                trackHandler(nil, object);
            }
        };
        loader.onDidFailWithError = ^(NSError *error) {
            if (trackHandler) {
                trackHandler(error, nil);
            }
        };
    }];
}

@end
