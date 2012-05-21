//
//  GTIOConfigManager.h
//  GTIO
//
//  Created by Scott Penrose on 5/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOConfig.h"

#import "SDWebImageManager.h"

typedef void(^GTIOConfigHandler)(GTIOConfig *config, NSError *error);

@interface GTIOConfigManager : NSObject <SDWebImageManagerDelegate>

+ (id)sharedManager;

- (void)loadConfigFromWebUsingBlock:(GTIOConfigHandler)configHandler;

/** Current config saved to disk
 */
- (GTIOConfig *)config;

@end
