//
//  GTIOMyManagementScreen.h
//  GTIO
//
//  Created by Geoffrey Mackey on 6/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIOMyManagementScreen : NSObject

@property (nonatomic, strong) NSArray *userInfo;
@property (nonatomic, strong) NSArray *management;

/** Load screen layout data from API
 */
+ (void)loadScreenLayoutDataWithCompletionHandler:(GTIOCompletionHandler)completionHandler;

@end