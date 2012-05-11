//
//  GTIOTrack.h
//  GTIO
//
//  Created by Scott Penrose on 5/10/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOVisit.h"

@class GTIOTrack;

typedef void(^GTIOTrackHandler)(NSError *error, GTIOTrack *track);

@interface GTIOTrack : NSObject

@property (nonatomic, strong) NSNumber *trackID;
@property (nonatomic, strong) GTIOVisit *visit;

+ (GTIOTrack *)track;

+ (void)postTrackUsingBlock:(GTIOTrackHandler)trackHandler;

@end
