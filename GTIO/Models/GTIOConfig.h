//
//  GTIOConfig.h
//  GTIO
//
//  Created by Scott Penrose on 5/9/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOConfig : NSObject

typedef void(^GTIOConfigHandler)(NSError *error, GTIOConfig *config);

@property (nonatomic, strong) NSArray *introScreens;

+ (void)loadConfigUsingBlock:(GTIOConfigHandler)configHandler;

@end
