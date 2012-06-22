//
//  GTIOButton.h
//  GTIO
//
//  Created by Scott Penrose on 6/22/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kGTIOPhotoHeartButton = @"photo-heart-button";

@interface GTIOButton : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *attribute;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSNumber *chevron;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) GTIOButtonAction *action;

@end
