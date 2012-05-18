//
//  GTIOConfig.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOConfig : NSObject <NSCoding>

@property (nonatomic, strong) NSArray *introScreens;

@property (nonatomic, strong) NSString *facebookPermissions;
@property (nonatomic, strong) NSNumber *facebookShareDefaultOn;
@property (nonatomic, strong) NSNumber *votingDefaultOn;

@end
