//
//  GTIOConfigManager.m
//  GTIO
//
//  Created by Scott Penrose on 5/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "GTIOConfigManager.h"

#import <RestKit/RestKit.h>

#import "SDImageCache.h"
#import "GTIOIntroScreen.h"

NSString * const kGTIOConfigKey = @"kGTIOConfigKey";
NSString * const kGTIOIntroScreenImagesDir = @"Documents/IntroScreenImages";
NSInteger const kGTIOImageDownloadTimeout = 30;

@interface GTIOConfigManager ()

@property (nonatomic, assign) NSInteger imagesDownloading;

@end

@implementation GTIOConfigManager

@synthesize imagesDownloading = _imagesDownloading;

+ (id)sharedManager 
{
    static GTIOConfigManager *configManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[self alloc] init];
    });
    return configManager;
}

- (void)loadConfigFromWebUsingBlock:(GTIOConfigHandler)configHandler
{
    // TODO: On first load we need to put images from bundle into disk cache with keys
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/config" usingBlock:^(RKObjectLoader *loader) {
        loader.onDidLoadObject = ^(id object) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                if (loader.response.statusCode == 200 && ![loader.response wasLoadedFromCache]) {
                    GTIOConfig *config = object;
                    GTIOConfig *currentConfig = [self config];
                    
                    // No current config download all images
                    if (!currentConfig) {
                        for (GTIOIntroScreen *introScreen in config.introScreens) {
                            [self downloadImageForIntroScreen:introScreen];
                        }
                    } else {                
                        // Load images if new
                        for (GTIOIntroScreen *introScreen in config.introScreens) {
                            for (GTIOIntroScreen *currentIntroScreen in currentConfig.introScreens) {
                                if ([introScreen.introScreenID isEqual:currentIntroScreen.introScreenID] && 
                                    (![[introScreen.imageURL absoluteURL] isEqual:[currentIntroScreen.imageURL absoluteURL]] || 
                                     ![[SDImageCache sharedImageCache] imageFromKey:introScreen.introScreenID])) {
                                        
                                        [self downloadImageForIntroScreen:introScreen];
                                    }
                            }
                        }
                    }
                    
                    // Save config
                    [self saveConfig:config];
                }
                
                // Block on image downloads
                while (self.imagesDownloading > 0) {
                    [NSThread sleepForTimeInterval:0.2];
                }
                
                if (configHandler) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        configHandler(object, nil);
                    });
                }
            });
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            if (configHandler) {
                configHandler(nil, error);
            }
        };
    }];
}

- (GTIOConfig *)config
{
    NSData *dataRepresentingSavedConfig = [[NSUserDefaults standardUserDefaults] objectForKey:kGTIOConfigKey];
    if (dataRepresentingSavedConfig) {
        GTIOConfig *config = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedConfig];
        return config;
    }
    return nil;
}

- (void)saveConfig:(GTIOConfig *)config
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:config] forKey:kGTIOConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers

- (void)downloadImageForIntroScreen:(GTIOIntroScreen *)introScreen
{
    // This is a new image so load it and save to filesystem
    self.imagesDownloading++;
    __block NSString *imageKey = introScreen.introScreenID;
    [[SDWebImageManager sharedManager] downloadWithURL:introScreen.imageURL delegate:self options:0 success:^(UIImage *image) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
        self.imagesDownloading--;
    } failure:^(NSError *error) {
        NSLog(@"Failed to download intro screen image: %@", [error localizedDescription]);
        self.imagesDownloading--;
    }];
}

@end
