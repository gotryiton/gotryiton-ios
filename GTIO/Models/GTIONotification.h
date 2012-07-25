//
//  GTIONotification.h
//  GTIO
//
//  Created by Geoffrey Mackey on 7/12/12.
//  Copyright (c) 2012 Go Try It On. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTIONotification : NSObject

@property (nonatomic, strong) NSNumber *notificationID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) NSURL *icon;

// local management
@property (nonatomic, strong) NSNumber *viewed;

@end
