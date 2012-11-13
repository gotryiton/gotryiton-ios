//
//  GTIOConfig.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTIOExploreLooksIntro.h"

@interface GTIOConfig : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *introScreens;

@property (nonatomic, strong) NSString *facebookPermissions;
@property (nonatomic, strong) NSNumber *facebookShareDefaultOn;
@property (nonatomic, strong) NSNumber *votingDefaultOn;
@property (nonatomic, strong) NSNumber *showExploreLooksIntro;

@property (nonatomic, strong) NSNumber *photoShootFirstTimer;
@property (nonatomic, strong) NSNumber *photoShootSecondTimer;
@property (nonatomic, strong) NSNumber *photoShootThirdTimer;
@property (nonatomic, strong) GTIOExploreLooksIntro *exploreLooksIntro;

@end
