//
//  GTIOTrack.h
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOVisit.h"

extern NSString * const kGTIOTrackAppLaunch;
extern NSString * const kGTIOTrackPhotoShootStarted;
extern NSString * const kGTIOTrackAppResumeFromBackground;
extern NSString * const kGTIOTrackSignIn; // 1.3 Sign in screen

@class GTIOTrack;

typedef void(^GTIOTrackHandler)(GTIOTrack *track, NSError *error);

@interface GTIOTrack : NSObject <NSCoding>

@property (nonatomic, strong) NSString *trackID;
@property (nonatomic, strong) GTIOVisit *visit;

@property (nonatomic, copy) GTIOTrackHandler trackHandler;

/** Intro screens */
@property (nonatomic, strong) NSNumber *pageNumber;

+ (void)postTrack:(GTIOTrack *)track handler:(GTIOTrackHandler)trackHandler;
+ (void)postTrackWithID:(NSString *)trackID handler:(GTIOTrackHandler)trackHandler;
+ (void)postTrackAndVisitWithID:(NSString *)trackID handler:(GTIOTrackHandler)trackHandler;

@end
