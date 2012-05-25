//
//  GTIOProfileDataSource.h
//  GTIO
//
//  Created by Geoffrey Mackey on 5/24/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef void(^GTIOCompletionHandler)(NSArray *loadedObjects, NSError *error);

@interface GTIOProfileDataSource : NSObject

+ (GTIOProfileDataSource *)sharedDataSource;

/** User Icons from API
 */
- (void)loadUserIconsWithUserID:(NSString*)userID andCompletionHandler:(GTIOCompletionHandler)completionHandler;

@end
