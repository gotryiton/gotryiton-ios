//
//  GTIOTrack.m
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOTrack.h"

#import <RestKit/RestKit.h>

NSString * const kGTIOTrackIDKey = @"GTIOTrackIDKey";
NSString * const kGTIOPageNumberKey = @"GTIOPageNumberKey";

@implementation GTIOTrack

@synthesize trackID = _trackID, visit = _visit;
@synthesize pageNumber = _pageNumber;

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

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.trackID = [coder decodeObjectForKey:kGTIOTrackIDKey];
        self.pageNumber = [coder decodeObjectForKey:kGTIOPageNumberKey];
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
}

@end
